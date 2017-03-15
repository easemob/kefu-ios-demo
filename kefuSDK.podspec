Pod::Spec.new do |s|
    s.name          = "kefuSDK"
    s.version       = "1.0.6"
    s.summary       = "环信移动客服 SDK"
    s.homepage      = "https://github.com/easemob/helpdeskdemo-ios"
    s.license       = { :type => "MIT", :file => "LICENSE" }
    s.platform      = :ios, "8.0"
    s.author        = { "afanda" => "fan_apple1990@163.com" }
    s.source        = { :git => "https://github.com/easemob/helpdeskdemo-ios.git", :tag => s.version }
    s.requires_arc  = true
    s.frameworks    = "CoreMedia","AudioToolbox","AVFoundation","ImageIO","MobileCoreServices"
    s.libraries     = "c++","z","sqlite3","stdc++.6.0.9"
    s.vendored_libraries = "CustomerSystem-ios/HelpDeskSDK/lib/libhelpdesk_sdk.a"
    s.xcconfig      = {"OTHER_LDFLAGS" => "-ObjC"}
    s.default_subspec = 'include','header'

    s.subspec 'header' do |ss|
    ss.source_files = 'CustomerSystem-ios/HelpDeskSDK/helpdesk_sdk.h'
    end

    s.subspec 'include' do |ss|
        ss.source_files = 'CustomerSystem-ios/HelpDeskSDK/include/*.h'
    end

    s.subspec 'HyphenateLite' do |ss|
        ss.dependency 'kefuSDK/header'
        ss.dependency 'kefuSDK/include'
        ss.source_files = 'CustomerSystem-ios/HyphenateSDK_H/*.h'
    end
end
