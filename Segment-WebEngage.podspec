Pod::Spec.new do |s|
  s.name             = "Segment-WebEngage"
  s.version          = "1.0.3"
  s.summary          = "WebEngage Integration for Segment's analytics-ios library"

  s.description      = <<-DESC
                        WebEngage integration for analytics-ios library provided by
                        Segment.com to provide WebEngage SDK functionality using the 
                        analytics-ios APIs.
                       DESC
  s.homepage         = "https://segment.com"
  s.license          = { :type => "MIT" }
  s.author           = { "Saumitra Bhave" => "saumitra@webklipper.com" }
  s.source           = { :git => "https://github.com/WebEngage/analytics-ios-integration-webengage.git", 
                          :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/segment"

  s.ios.deployment_target = '8.0'

  s.source_files = 'Segment-WebEngage/Classes/**/*'
  
  s.subspec 'Xcode8' do |xc8|
    xc8.dependency 'WebEngage/Xcode8', '~> 4.0.1'
    xc8.dependency 'Analytics'
  end

  s.subspec 'Xcode9' do |xc9|
    xc9.dependency 'WebEngage', '~> 4.0.1'
    xc9.dependency 'Analytics'
  end

  s.default_subspec = 'Xcode9'

end
