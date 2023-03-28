//
//  PaymentCardScannerViewController.swift
//  
//  Created by PayU S.A. on 08/03/2023.
//  Copyright © 2023 PayU S.A. All rights reserved.
//

import AVFoundation
import CoreImage
import CoreGraphics
import UIKit
import Vision

#if canImport(PUCore)
import PUCore
#endif

#if canImport(PUTheme)
import PUTheme
#endif

#if canImport(PUTranslations)
import PUTranslations
#endif

/// Protocol which defines the completion result of ``PaymentCardScannerViewController``
@available(iOS 13.0, *)
public protocol PaymentCardScannerViewControllerDelegate: AnyObject {
  /// This method is called when user scanned the payment card
  /// - Parameters:
  ///   - viewController: Instance of ``PaymentCardScannerViewController`` from where the action was triggered
  ///   - result: ``PaymentCardScannerResult`` instance which contains information about the scanned payment card
  func paymentCardScannerViewController(_ viewController: PaymentCardScannerViewController, didProcess result: PaymentCardScannerResult)

  /// This method is called when the error occured during the scanning
  /// - Parameters:
  ///   - viewController: Instance of ``PaymentCardScannerViewController`` from where the action was triggered
  ///   - error: Error with details
  func paymentCardScannerViewController(_ viewController: PaymentCardScannerViewController, didFail error: Error)

  /// This method is called when the user cancelled scanning
  /// - Parameters:
  ///   - viewController: Instance of ``PaymentCardScannerViewController`` from where the action was triggered
  func paymentCardScannerViewControllerDidCancel(_ viewController: PaymentCardScannerViewController)
}

/// ViewController which is responsible for payment card scanning
@available(iOS 13.0, *)
public final class PaymentCardScannerViewController: UIViewController {

  // MARK: - Factory
  /// Factory which allows to create the ``PaymentCardScannerViewController`` instance
  public struct Factory {

    // MARK: - Private Properties
    private let assembler = PaymentCardScannerAssembler()

    // MARK: - Initialization
    public init() {  }

    // MARK: - Public Methods
    /// Returns default implementation for ``PaymentCardScannerViewController``
    /// - Parameter option: ``PaymentCardScannerOption`` value
    /// - Returns: Default implementation for ``PaymentCardScannerViewController``
    public func make(option: PaymentCardScannerOption) -> PaymentCardScannerViewController {
      assembler.makePaymentCardScannerViewController(option: option)
    }
  }

  // MARK: - Public Properties
  public weak var delegate: PaymentCardScannerViewControllerDelegate?

  // MARK: - Private Properties
  private let service: PaymentCardScannerService

  private let captureSession: AVCaptureSession
  private let captureDevice: AVCaptureDevice?
  private let captureVideoPreviewLayer: AVCaptureVideoPreviewLayer
  private let captureVideoDataOutput: AVCaptureVideoDataOutput

  private var titleLabel: UILabel!
  private var overlayView: PaymentCardScannerOverlayView!

  private let captureSessionQueue: DispatchQueue
  private let sampleBufferQueue: DispatchQueue

  // MARK: - Initialization
  required init(service: PaymentCardScannerService) {
    self.service = service

    let captureSession = AVCaptureSession()

    self.captureSession = captureSession
    self.captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    self.captureVideoPreviewLayer.videoGravity = .resizeAspect
    self.captureDevice = AVCaptureDevice.default(for: .video)
    self.captureVideoDataOutput = AVCaptureVideoDataOutput()

    self.captureSessionQueue = DispatchQueue(label: "com.payu.swift.PaymentCardScanner.captureSessionQueue")
    self.sampleBufferQueue = DispatchQueue(label: "com.payu.swift.PaymentCardScanner.sampleBufferQueue")

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    stopCaptureSession()
  }

  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupCaptureSession()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startCaptureSession()
  }

  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    stopCaptureSession()
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    captureVideoPreviewLayer.frame = view.bounds
  }

  // MARK: - Actions
  @objc private func actionBack(_ sender: Any) {
    delegate?.paymentCardScannerViewControllerDidCancel(self)
  }

  // MARK: - Private Methods
  private func setupNavigationBar() {
    navigationItem.titleView = PUImageView(brandImageProvider: .logo)
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back".localized(), style: .plain, target: self, action: #selector(actionBack(_:)))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "   ", style: .plain, target: self, action: nil)
    navigationItem.leftBarButtonItem?.tintColor = PUTheme.theme.colorTheme.primary2
  }

  private func setupCaptureSession() {
    addCameraInput()
    addPreviewLayer()
    addVideoOutput()
    makeOverlayView()
    makeTitleLabel()
    makeTitleUpdate()
  }

  private func startCaptureSession() {
    captureSessionQueue.async { [weak self] in
      self?.captureSession.startRunning()
    }
  }

  private func stopCaptureSession() {
    captureVideoDataOutput.setSampleBufferDelegate(nil, queue: sampleBufferQueue)
    captureSession.stopRunning()
  }

  private func addCameraInput() {
    guard let device = captureDevice else {
      let error = PaymentCardScannerError(errorType: .couldNotCreateCaptureDevice, errorReason: nil)
      delegate?.paymentCardScannerViewController(self, didFail: error)
      return
    }

    do {
      let deviceInput = try AVCaptureDeviceInput(device: device)
      captureSession.addInput(deviceInput)
    } catch {
      let error = PaymentCardScannerError(errorType: .couldNotCreateCaptureDeviceInput, errorReason: error)
      delegate?.paymentCardScannerViewController(self, didFail: error)
    }
  }

  private func addPreviewLayer() {
    view.layer.addSublayer(captureVideoPreviewLayer)
  }

  private func addVideoOutput() {
    captureVideoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    captureVideoDataOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
    captureSession.addOutput(captureVideoDataOutput)

    let captureConnection = captureVideoDataOutput.connection(with: .video)
    guard let captureConnection = captureConnection else {
      let error = PaymentCardScannerError(errorType: .couldNotCreateCaptureConnection, errorReason: nil)
      delegate?.paymentCardScannerViewController(self, didFail: error)
      return
    }

    guard captureConnection.isVideoOrientationSupported else {
      let error = PaymentCardScannerError(errorType: .videoOrientationIsNotSupported, errorReason: nil)
      delegate?.paymentCardScannerViewController(self, didFail: error)
      return
    }
    captureConnection.videoOrientation = .portrait
  }

  private func makeOverlayView() {
    let recognitionRect = recognitionRect(in: view.bounds)
    overlayView = PaymentCardScannerOverlayView(rect: recognitionRect)

    view.addSubview(overlayView)
    view.backgroundColor = PUTheme.theme.colorTheme.secondaryGray4

    overlayView.translatesAutoresizingMaskIntoConstraints = false
    overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }

  private func makeTitleLabel() {
    titleLabel = UILabel()
    titleLabel.text = ""
    titleLabel.numberOfLines = 3
    titleLabel.textAlignment = .center

    let textStyle = PUTheme.theme.textTheme.headline6
    titleLabel.apply(style: textStyle)

    let originY = recognitionRect(in: view.bounds).minY - 32

    view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: originY).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
  }

  private func addVideoOutputListener() {
    captureVideoDataOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
  }

  private func removeVideoOutputListener() {
    captureVideoDataOutput.setSampleBufferDelegate(nil, queue: sampleBufferQueue)
  }

  // MARK: - Frames
  private func recognitionRect(in bounds: CGRect) -> CGRect {
    let width = bounds.width - 16
    let height = width / 1.5
    let originX = bounds.midX - width / 2
    let originY = bounds.midY - height / 2
    return CGRect(x: originX, y: originY, width: width, height: height)
  }

  // MARK: - Image Processing
  private func startProcessingTextRecognition(_ ciImage: CIImage) {
    DispatchQueue.main.async { [weak self] in
      guard let bounds = self?.view.bounds else { return }
      DispatchQueue.global().async { [weak self] in
        self?.startProcessingImageRecognition(ciImage, containerBounds: bounds)
      }
    }
  }

  private func startProcessingImageRecognition(_ ciImage: CIImage, containerBounds: CGRect) {
    guard let resizeFilter = CIFilter(name: "CILanczosScaleTransform") else { return }

    let targetSize = containerBounds.size
    let scale = targetSize.height / ciImage.extent.size.height
    let aspectRatio = targetSize.width / (ciImage.extent.size.width * scale)

    resizeFilter.setValue(ciImage, forKey: kCIInputImageKey)
    resizeFilter.setValue(NSNumber(value: scale), forKey: kCIInputScaleKey)
    resizeFilter.setValue(NSNumber(value: aspectRatio), forKey: kCIInputAspectRatioKey)

    guard let outputImage = resizeFilter.outputImage else { return }
    let outputRect = recognitionRect(in: containerBounds)
    let croppedImage = outputImage.cropped(to: outputRect)

    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = false

    do {
      let requestHandler = VNImageRequestHandler(ciImage: croppedImage)
      try requestHandler.perform([request])

      guard let results = request.results else { return }

      for result in results {
        for recognizedText in result.topCandidates(1) where recognizedText.confidence > 0.1 {
          if service.isProcessed() == false {
            makeTitleUpdate()
            if service.process(recognizedText.string) {
              completeImageProcessing()
              break
            }
          }
        }
      }
    } catch {  }
  }

  private func completeImageProcessing() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.makeTapticFeedback()
      self.stopCaptureSession()
      self.delegate?.paymentCardScannerViewController(self, didProcess: self.service.result)
    }
  }

  // MARK: - Interactions
  private func makeTitleUpdate() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      let isProcessedAtLeastOneParameter = self.service.result.isProcessedAtLeastOneParameter
      self.titleLabel.text = isProcessedAtLeastOneParameter ? "hold_still".localized() : "position_your_card_in_this_frame".localized()
    }
  }

  private func makeTapticFeedback() {
    UINotificationFeedbackGenerator().notificationOccurred(.success)
  }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
@available(iOS 13.0, *)
extension PaymentCardScannerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    let allocator = kCFAllocatorDefault
    let attachmentMode = kCMAttachmentMode_ShouldPropagate

    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
    guard let dictionaryOfAttachments = CMCopyDictionaryOfAttachments(allocator: allocator, target: sampleBuffer, attachmentMode: attachmentMode) else { return }
    guard let options = dictionaryOfAttachments as? Dictionary<CIImageOption, Any> else { return }

    let ciImage = CIImage(cvPixelBuffer: pixelBuffer, options: options)
    startProcessingTextRecognition(ciImage)

  }
}
