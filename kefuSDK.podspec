Pod::Spec.new do |s|
    s.name         = "kefuSDK"
    s.version      = "1.0.0"
    s.summary      = "环信客服 SDK"
    s.homepage     = "https://github.com/easemob/helpdeskdemo-ios"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.platform     = :ios, "8.0"
    s.author       = { "afanda" => "fan_apple1990@163.com" }
    s.source       = { :git => "https://github.com/easemob/helpdeskdemo-ios.git", :tag => s.version }
    s.requires_arc = true
    s.source_files = "CustomerSystem-ios/HelpDeskSDK/include/*.{h,m}"
    s.resources    = "CustomerSystem-ios/HelpDeskSDK/lib/*.{a,h}"
    s.frameworks   = "Foundation"
end
