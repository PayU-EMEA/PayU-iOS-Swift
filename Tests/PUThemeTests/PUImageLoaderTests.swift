//
//  PUImageLoaderTests.swift
//
//  Created by PayU S.A. on 26/11/2026.
//  Copyright © 2026 PayU S.A. All rights reserved.
//

import XCTest
@testable import PUTheme

final class PUImageLoaderTests: XCTestCase {

  // MARK: - Private Properties
  private let url = URL(string: "https://example.com/logo.png")!
  private var directory: URL!
  private var requestCount = 0

  // MARK: - Lifecycle
  override func setUpWithError() throws {
    directory = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString, isDirectory: true)
    requestCount = 0
    StubURLProtocol.handler = { [unowned self] request in
      requestCount += 1
      return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, makePNG())
    }
  }

  override func tearDownWithError() throws {
    StubURLProtocol.handler = nil
    try? FileManager.default.removeItem(at: directory)
  }

  // MARK: - Tests
  func testLoadImageShouldDownloadImageAndCallCompletionOnMainThread() {
    let sut = makeSUT()
    let completed = expectation(description: "completion")

    sut.loadImage(from: url) { image in
      XCTAssertTrue(Thread.isMainThread)
      XCTAssertNotNil(image)
      completed.fulfill()
    }

    wait(for: [completed], timeout: 2)
    XCTAssertEqual(requestCount, 1)
  }

  func testLoadImageShouldSaveDownloadedImageOnDisk() throws {
    let sut = makeSUT()

    load(url, with: sut)

    XCTAssertEqual(try FileManager.default.contentsOfDirectory(atPath: directory.path).count, 1)
  }

  func testLoadImageShouldUseMemoryCacheOnSecondLoad() {
    let sut = makeSUT()
    load(url, with: sut)
    var completed = false

    let task = sut.loadImage(from: url) { _ in completed = true }

    XCTAssertNil(task)
    XCTAssertTrue(completed)
    XCTAssertEqual(requestCount, 1)
  }

  func testLoadImageShouldUseDiskCacheWhenMemoryCacheIsEmpty() {
    load(url, with: makeSUT())
    var completed = false

    let task = makeSUT().loadImage(from: url) { _ in completed = true }

    XCTAssertNil(task)
    XCTAssertTrue(completed)
    XCTAssertEqual(requestCount, 1)
  }

  func testLoadImageShouldIgnoreDiskFileOlderThan14Days() throws {
    load(url, with: makeSUT())
    try setModificationDate(Date(timeIntervalSinceNow: -15 * 24 * 60 * 60))

    load(url, with: makeSUT())

    XCTAssertEqual(requestCount, 2)
  }

  func testLoadImageShouldUseDiskFileYoungerThan14Days() throws {
    load(url, with: makeSUT())
    try setModificationDate(Date(timeIntervalSinceNow: -13 * 24 * 60 * 60))

    load(url, with: makeSUT())

    XCTAssertEqual(requestCount, 1)
  }

  func testLoadImageShouldRefreshModificationDateWhenReadingFromDisk() throws {
    load(url, with: makeSUT())
    let old = Date(timeIntervalSinceNow: -10 * 24 * 60 * 60)
    try setModificationDate(old)

    load(url, with: makeSUT())

    XCTAssertGreaterThan(try modificationDate(), old.addingTimeInterval(24 * 60 * 60))
  }

  func testLoadImageShouldNotCallCompletionNorSaveFileWhenStatusCodeIsNotSuccessful() throws {
    StubURLProtocol.handler = { request in
      (HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!, Data())
    }
    let sut = makeSUT()
    let notCompleted = expectation(description: "completion")
    notCompleted.isInverted = true

    sut.loadImage(from: url) { _ in notCompleted.fulfill() }

    wait(for: [notCompleted], timeout: 0.5)
    XCTAssertFalse(FileManager.default.fileExists(atPath: directory.path))
  }

  func testInitShouldRemoveOldestFilesUntilSizeIsWithin20MB() throws {
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    for (name, daysAgo) in [("oldest", 3), ("middle", 2), ("newest", 1)] {
      let file = directory.appendingPathComponent(name)
      try Data(count: 8 * 1024 * 1024).write(to: file)
      try FileManager.default.setAttributes(
        [.modificationDate: Date(timeIntervalSinceNow: -Double(daysAgo) * 24 * 60 * 60)],
        ofItemAtPath: file.path
      )
    }
    let removed = expectation(for: NSPredicate { [directory] _, _ in
      !FileManager.default.fileExists(atPath: directory!.appendingPathComponent("oldest").path)
    }, evaluatedWith: nil)

    let sut = makeSUT()

    wait(for: [removed], timeout: 2)
    withExtendedLifetime(sut) {}
    XCTAssertFalse(FileManager.default.fileExists(atPath: directory.appendingPathComponent("oldest").path))
    XCTAssertTrue(FileManager.default.fileExists(atPath: directory.appendingPathComponent("middle").path))
    XCTAssertTrue(FileManager.default.fileExists(atPath: directory.appendingPathComponent("newest").path))
  }

  func testInitShouldKeepFilesWhenSizeDoesNotExceed20MB() throws {
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    try Data(count: 1024).write(to: directory.appendingPathComponent("small"))
    let sut = makeSUT()
    let notRemoved = expectation(for: NSPredicate { [directory] _, _ in
      !FileManager.default.fileExists(atPath: directory!.appendingPathComponent("small").path)
    }, evaluatedWith: nil)
    notRemoved.isInverted = true

    wait(for: [notRemoved], timeout: 0.5)
    withExtendedLifetime(sut) {}
  }

  // MARK: - Helpers
  private func makeSUT() -> PUImageLoader {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [StubURLProtocol.self]
    return PUImageLoader(session: URLSession(configuration: configuration), directory: directory)
  }

  private func load(_ url: URL, with sut: PUImageLoader) {
    let completed = expectation(description: "completion")
    sut.loadImage(from: url) { _ in completed.fulfill() }
    wait(for: [completed], timeout: 2)
  }

  private func makePNG() -> Data {
    UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).pngData { _ in }
  }

  private var fileURL: URL {
    get throws {
      let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
      return try XCTUnwrap(files.first)
    }
  }

  private func setModificationDate(_ date: Date) throws {
    try FileManager.default.setAttributes([.modificationDate: date], ofItemAtPath: try fileURL.path)
  }

  private func modificationDate() throws -> Date {
    try XCTUnwrap(try fileURL.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate)
  }
}

// MARK: - StubURLProtocol
private final class StubURLProtocol: URLProtocol {

  static var handler: ((URLRequest) -> (HTTPURLResponse, Data))?

  override class func canInit(with request: URLRequest) -> Bool { true }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

  override func startLoading() {
    guard let handler = Self.handler else {
      client?.urlProtocol(self, didFailWithError: URLError(.unknown))
      return
    }

    let (response, data) = handler(request)
    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    client?.urlProtocol(self, didLoad: data)
    client?.urlProtocolDidFinishLoading(self)
  }

  override func stopLoading() {}
}
