Pod::Spec.new do |s|
  s.name         = "ScratchImage"
  s.version      = "0.2.0"
  s.summary      = "Scratchable UIImageView"
  s.homepage     = "https://github.com/cashwalk/ScratchImage"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "DongHee Kang" => "kanglpmg@gmail.com" }
  s.source       = { :git => "https://github.com/cashwalk/ScratchImage.git", :tag => s.version.to_s }
  s.documentation_url = 'https://github.com/cashwalk/ScratchImage/blob/master/README.md'

  s.ios.source_files  = "Sources/*.swift"
  s.ios.deployment_target = "8.0"
end
