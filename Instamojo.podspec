Pod::Spec.new do |s|
  s.name         = "Instamojo"
  s.version      = "1.0.10"
  s.summary      = "Instamojo iOS SDK"
  s.homepage     = "https://www.instamojo.com"
  s.license      = "LGPL"
  s.author       = { "Instamojo" => "sukanya@innoventes.co" }
  s.source 		 = { :git => 'https://github.com/Instamojo/ios-sdk.git', :tag => s.version.to_s }
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.vendored_frameworks = 'Instamojo.framework'
  s.resource = 'JuspaySafeBrowser.bundle'
end
