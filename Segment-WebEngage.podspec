Pod::Spec.new do |spec|

  spec.name         = 'Segment-WebEngage'
  spec.version      = '1.1.0'

  spec.summary      = 'WebEngage Integration for Segment\'s analytics-ios library'
  spec.description  = <<-DESC
                        WebEngage integration for analytics-ios library provided by
                        Segment.com to provide WebEngage SDK functionality using the
                        analytics-ios APIs.
                      DESC

  spec.license           = 'MIT'
  spec.homepage          = 'https://webengage.com'
  spec.social_media_url  = 'http://twitter.com/webengage'
  spec.documentation_url = 'https://docs.webengage.com/docs/segment-advanced-integration#section-ios'
  spec.author            = 'Saumitra Bhave', 'Yogesh Singh'
  spec.source            = { :git => 'https://github.com/WebEngage/analytics-ios-integration-webengage.git', :tag => spec.version.to_s }
  spec.source_files      = 'Segment-WebEngage/Classes/**/*'
  spec.platform          = :ios
  spec.ios.deployment_target = '8.0'

  spec.subspec 'Xcode10' do |xc10|
    xc10.dependency 'WebEngage'
    xc10.dependency 'Analytics'
  end

  spec.subspec 'Xcode9' do |xc9|
    xc9.dependency 'WebEngage/Xcode9'
    xc9.dependency 'Analytics'
  end

  spec.default_subspec = 'Xcode10'

end
