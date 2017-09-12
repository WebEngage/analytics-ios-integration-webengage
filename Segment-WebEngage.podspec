Pod::Spec.new do |s|
  s.name             = "Segment-WebEngage"
  s.version          = "1.0.1"
  s.summary          = "WebEngage Integration for Segment's analytics-ios library"

  s.description      = <<-DESC
                        WebEngage integration for analytics-ios library provided by
                        Segment.com to provide WebEngage SDK functionality using the 
                        analytics-ios APIs.
                       DESC
  s.homepage         = "https://segment.com"
  s.license          = { :type => "MIT" }
  s.author           = { "Arpit Agrawal" => "arpit@webklipper.com" }
  s.source           = { :git => "https://github.com/WebEngage/analytics-ios-integration-webengage.git", 
                          :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/segment"

  s.ios.deployment_target = '7.0'

  s.source_files = 'Segment-WebEngage/Classes/**/*'
  
  s.subspec 'Xcode7' do |xc7|
    xc7.dependency 'WebEngage/Xcode7', '~> 3.5.6'
    xc7.dependency 'Analytics'
  end

  s.subspec 'Xcode8' do |xc8|
    xc8.dependency 'WebEngage', '~> 3.5.6'
    xc8.dependency 'Analytics'
  end

  s.subspec 'NoWebEngage' do |o|
    o.dependency 'Analytics'
  end

  s.default_subspec = 'Xcode8'

end
