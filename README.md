# Segment-WebEngage

[![CI Status](http://img.shields.io/travis/segment-integrations/analytics-ios-integration-webengage.svg?style=flat)](https://travis-ci.org/segment-integrations/analytics-ios-integration-webengage)
[![Version](https://img.shields.io/cocoapods/v/Segment-WebEngage.svg?style=flat)](http://cocoapods.org/pods/Segment-WebEngage)
[![License](https://img.shields.io/cocoapods/l/Segment-WebEngage.svg?style=flat)](http://cocoapods.org/pods/Segment-WebEngage)

WebEngage integration for analytics-ios.

## Installation

To install the Segment-WebEngage integration, simply add this line to your [CocoaPods](http://cocoapods.org) `Podfile`:

```ruby
pod "Segment-WebEngage"
```
If you are using XCode 7 use:

```ruby
pod "Segment-WebEngage/Xcode7"
```

## Usage

After adding the dependency, you must register the integration with our SDK.  To do this, import the WebEngage integration in your `AppDelegate`:

```
#import <Segment-WebEngage/WEGSegmentIntegrationFactory.h>
```

And add the following lines to your AppDelegate's application:didFinishLaunching:WithOptions: method

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Initialise Segment
    SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:@"XXXXXXXXXXXXXXXXXXXXXXXXXXX"];
    
    //Additional Segment Configuration
    configuration.trackApplicationLifecycleEvents = NO; // Enable this to record certain application events automatically!
    configuration.recordScreenViews = NO; // Enable this to record screen views automatically!
    
    //Register WebEngage Integration With Segment
    [configuration use:[WEGSegmentIntegrationFactory instanceWithApplication:application launchOptions:launchOptions]];
    
    [SEGAnalytics setupWithConfiguration:configuration];
    
    return YES;
}
```