Pod::Spec.new do |s|
  s.name         = "Instamojo"
  s.version      = "1.0.0"
  s.summary      = "Instamojo iOS SDK"
  s.homepage     = "https://www.instamojo.com"
  s.license      = 'MIT'
  s.author       = { "Sukanya Raj" => "sukanya@innoventes.co" }
  s.source = { :git => 'https://Sukanya_raj@bitbucket.org/innoventes/instamojo-ios-sdk.git', :tag => s.version }
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.source_files = 'Pod/Classes/**/*.{swift}'
  s.resource_bundles = {
    'Instamojo' => ['Pod/Classes/**/*.{storyboard,xcassets}']
  }
  s.subspec "JuspaySafeBrowser" do |ss|
      ss.dependency "JuspaySafeBrowser"
      ss.xcconfig = { "FRAMEWORK_SEARCH_PATHS" => "$(PODS_ROOT)/JuspaySafeBrowser"}
end
