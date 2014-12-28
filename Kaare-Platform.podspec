Pod::Spec.new do |s|
  s.name           = "Kaare-Platform"
  s.version        = "1.0.0"
  s.summary        = "Kaare extensions which provides access to native OS functionality like: HttpRequest and XPath"
  s.description    = "Provides wrappers around native functions for iOS which you can use through Kaare from your JavaScript logic"
  s.homepage       = "https://github.com/artemyarulin/Kaare-Platform"
  s.license        = { :type => 'MIT', :file => 'LICENSE' }
  s.author         = { "Artem Yarulin" => "artem.yarulin@fessguid.com" }
  s.platform       = :ios, "7.0"
  s.source         = { :git => "https://github.com/artemyarulin/Kaare-Platform.git", :tag => "1.0.0" }
  s.source_files   = ["iOS/Kaare-Platform/KaarePlatform.{h,m}",
                      "iOS/Kaare-Platform/Modules/*.{h,m}"]
  s.resource_bundles = { 
    'KaarePlatform' => ['js/build/kaare.platform.js'] 
  }
  s.public_header_files = "iOS/Kaare-Platform/KaarePlatform.h"
  s.framework     = "JavaScriptCore"
  s.requires_arc  = true

  s.dependency "ReactiveCocoa", "~> 2.3.1"
  s.dependency "GDataXML-HTML", "~> 1.1"
  s.dependency "Kaare", "~> 1.0.0"

  # CocoaPods wouldn't handle it for us, so let's expose build flags from GDataXml-HTML
  s.library = 'xml2'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
end
