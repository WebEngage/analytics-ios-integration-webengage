# [Segment-Integration-iOS](https://docs.webengage.com/docs/segment)

[![Version](https://img.shields.io/cocoapods/v/Segment-WebEngage.svg?style=flat)](http://cocoapods.org/pods/Segment-WebEngage)
[![License](https://img.shields.io/cocoapods/l/Segment-WebEngage.svg?style=flat)](http://cocoapods.org/pods/Segment-WebEngage)
[![Platform](https://img.shields.io/cocoapods/p/Segment-WebEngage.svg)](https://cocoapods.org/pods/Segment-WebEngage)
[![LastUpdated](https://img.shields.io/github/last-commit/WebEngage/analytics-ios-integration-webengage.svg)](https://cocoapods.org/pods/Segment-WebEngage)


WebEngage integration for Segment's [analytics-ios SDK](https://github.com/segmentio/analytics-ios).

Check out more information [here](https://docs.webengage.com/docs/segment).

## Installation

To install the Segment-WebEngage integration, simply add this line to your `Podfile`:

```ruby
# Avoid use_frameworks! declaration in your Podfile
pod "Segment-WebEngage"
```

## Usage

After adding the dependency, you must register the integration with our SDK.  To do this, import the WebEngage integration in your `AppDelegate`:

```
#import <Segment-WebEngage/WEGSegmentIntegrationFactory.h>
```

And add the following lines to your AppDelegate's application:didFinishLaunching:WithOptions: method

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //Initialize Segment
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
Please follow our [iOS Push Notification Documentation](https://docs.webengage.com/docs/ios-push-messaging)

## In-App Notifications
No further action is required to integrate in-app messages.

## Advanced
For advanced integration options such as InApp callback and manual push registration, please visit the [Advanced Section Documentation](https://docs.webengage.com/docs/ios-advanced). You can find the similar flavours of methods in Segment-WebEngage's `WEGSegmentIntegrationFactory` class

## Sample App
WebEngage has created a sample iOS application that integrates WebEngage via Segment. Check it out in this Repository's Example folder.


For more details check out documentation [here](https://docs.webengage.com/docs/segment).
