Pod::Spec.new do |s|  
  s.name      = 'PUSDK'
  s.version   = '2.0.6'
  s.summary   = 'PayU mobile SDK for iOS'
  s.homepage  = 'http://developers.payu.com/en/mobile_sdk.html'

  s.author    = { 'PayU' => 'sdk@payu.com' }
  s.license   = { :type => 'Apache License Version 2.0', :file => 'LICENSE' }
  s.source    = { :git => 'https://github.com/PayU-EMEA/PayU-iOS-Swift.git', :tag => s.version }

  s.platform              = :ios
  s.swift_version         = '5.10'
  s.ios.deployment_target = '12.0'

  s.subspec 'PUAPI' do |ss|
    ss.source_files       = 'PUAPI/Sources/PUAPI/**/*'
    ss.resource_bundles   = {'PUAPI' => ['PUAPI/Sources/PUAPI/Certificates/*.{cer}']}
    ss.resources          = ['PUAPI/Sources/PUAPI/Certificates/*.{cer}']
    ss.dependency         'PUSDK/PUCore'
  end

  s.subspec 'PUApplePay' do |ss|
    ss.source_files       = 'PUApplePay/Sources/PUApplePay/**/*'
    ss.framework          = 'PassKit'
  end

  s.subspec 'PUCore' do |ss|
    ss.source_files       = 'PUCore/Sources/PUCore/**/*'
    ss.resource_bundles   = {'PUCore' => ['PUCore/Resources/*.{xcassets}']}
    ss.resources          = ['PUCore/Resources/*.{xcassets}']
  end

  s.subspec 'PUPaymentCard' do |ss|
    ss.source_files       = 'PUPaymentCard/Sources/PUPaymentCard/**/*'
    ss.dependency         'PUSDK/PUAPI'
    ss.dependency         'PUSDK/PUCore'
    ss.dependency         'PUSDK/PUPaymentCardScanner'
    ss.dependency         'PUSDK/PUTheme'
    ss.dependency         'PUSDK/PUTranslations'
  end

  s.subspec 'PUPaymentCardScanner' do |ss|
    ss.source_files       = 'PUPaymentCardScanner/Sources/PUPaymentCardScanner/**/*'
    ss.framework          = 'AVFoundation'
    ss.framework          = 'CoreImage'
    ss.framework          = 'CoreGraphics'
    ss.framework          = 'Vision'
    ss.dependency         'PUSDK/PUCore'
    ss.dependency         'PUSDK/PUTheme'
    ss.dependency         'PUSDK/PUTranslations'
  end

  s.subspec 'PUPaymentMethods' do |ss|
    ss.source_files       = 'PUPaymentMethods/Sources/PUPaymentMethods/**/*'
    ss.dependency         'PUSDK/PUApplePay'
    ss.dependency         'PUSDK/PUCore'
    ss.dependency         'PUSDK/PUPaymentCard'
    ss.dependency         'PUSDK/PUTheme'
    ss.dependency         'PUSDK/PUTranslations'
  end

  s.subspec 'PUTheme' do |ss|
    ss.source_files       = 'PUTheme/Sources/PUTheme/**/*'
    ss.resource_bundles   = {'PUTheme' => ['PUTheme/Sources/PUTheme/Resources/Fonts/*.{ttf}']}
    ss.resources          = ['PUTheme/Sources/PUTheme/Resources/Fonts/*.{ttf}']
    ss.dependency         'Kingfisher', '7.11.0'
    ss.dependency         'PUSDK/PUCore'
  end

  s.subspec 'PUThreeDS' do |ss|
    ss.source_files       = 'PUThreeDS/Sources/PUThreeDS/**/*'
    ss.framework          = 'WebKit'
    ss.dependency         'PUSDK/PUAPI'
    ss.dependency         'PUSDK/PUCore'
  end

  s.subspec 'PUTranslations' do |ss|
    ss.source_files       = 'PUTranslations/Sources/PUTranslations/**/*'
    ss.resource_bundles   = {'PUTranslations' => ['PUTranslations/Sources/PUTranslations/Resources/*.{lproj}']}
    ss.resources          = ['PUTranslations/Sources/PUTranslations/Resources/*.{lproj}']
    ss.dependency         'PUSDK/PUCore'
  end

  s.subspec 'PUWebPayments' do |ss|
    ss.source_files       = 'PUWebPayments/Sources/PUWebPayments/**/*'
    ss.framework          = 'WebKit'
    ss.dependency         'PUSDK/PUAPI'
    ss.dependency         'PUSDK/PUCore'
    ss.dependency         'PUSDK/PUTheme'
    ss.dependency         'PUSDK/PUTranslations'
  end
  s.resource_bundles = {'PUSDK' => ['PUSDK/Resources/PrivacyInfo.xcprivacy']}
end
