Pod::Spec.new do |s|

  s.license      = "MIT"
  s.author       = { "qqc" => "20599378@qq.com" }
  s.platform     = :ios, "8.0"
  s.requires_arc  = true

  s.name         = "QqcGuideView"
  s.version      = "1.0.2"
  s.summary      = "QqcGuideView"
  s.homepage     = "https://github.com/xukiki/QqcGuideView"
  s.source       = { :git => "https://github.com/xukiki/QqcGuideView.git", :tag => "#{s.version}" }
  
  s.source_files  = ["QqcGuideView/*.{h,m}"]
  s.dependency "UIView-Qqc"
  
end
