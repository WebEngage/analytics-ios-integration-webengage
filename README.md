# Segment-Integration-iOS
[![Version](https://img.shields.io/cocoapods/v/Segment-WebEngage.svg?style=flat)](http://cocoapods.org/pods/Segment-WebEngage)
[![License](https://img.shields.io/cocoapods/l/Segment-WebEngage.svg?style=flat)](http://cocoapods.org/pods/Segment-WebEngage)

WebEngage integration for [analytics-ios](https://github.com/segmentio/analytics-ios)

## Installation

To install the Segment-WebEngage integration, simply add this line to your [CocoaPods](http://cocoapods.org) `Podfile`:

```ruby
pod "Segment-WebEngage"
```
If you are using XCode 8 and face any build issues try following before contacting support:

```ruby
pod "Segment-WebEngage/Xcode8"
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

## Push Notifications
Please follow our [ios push notification documentation](https://docs.webengage.com/docs/ios-push-messaging)

## In-App Notifications
No further action is required to integrate in-app messages.

## Advanced
For advanced integration options such as InApp callback and manual push registration, please visit the advanced [section](https://docs.webengage.com/docs/ios-advanced) of our iOS documentation. You can find the similar flavours of methods in Segment-WebEngage's `WEGSegmentIntegrationFactory` class

## Sample App
WebEngage has created a sample iOS application that integrates WebEngage via Segment. Check it out in this Repository's Example folder.
