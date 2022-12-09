Pod::Spec.new do |spec|

  spec.name         = 'Segment-WebEngage'
  spec.version      = '1.2.2'

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
  spec.author            = { "WebEngage" => "https://webengage.com" }
  spec.source            = { :git => 'https://github.com/WebEngage/analytics-ios-integration-webengage.git', :tag => spec.version.to_s }
  spec.source_files      = 'Segment-WebEngage/Classes/**/*'
  spec.platform          = :ios
  spec.ios.deployment_target = '11.0'
  
  spec.dependency 'WebEngage'
  spec.dependency 'Analytics'

end
