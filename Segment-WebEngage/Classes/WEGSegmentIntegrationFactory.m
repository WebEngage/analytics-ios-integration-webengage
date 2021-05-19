//
//  WEGSegmentIntegrationFactory.m
//  WebEngage
//
//  Created by Arpit on 25/10/16.
//  Copyright © 2016 Saumitra R. Bhave. All rights reserved.
//

#import "WEGSegmentIntegrationFactory.h"

#if defined(__has_include) && __has_include(<Analytics/SEGIntegration.h>)
#import <Analytics/SEGAnalyticsUtils.h>
#else
#import <Segment/SEGAnalyticsUtils.h>
#endif

@interface WEGSegmentIntegrationFactory ()
@property(nonatomic, strong, readwrite) UIApplication *application;
@property(nonatomic, strong, readwrite) NSDictionary *launchOptions;
@property(nonatomic, strong, readwrite) id<WEGInAppNotificationProtocol>
    notificationDelegate;
@property(nonatomic, readwrite) BOOL autoAPNSRegister;
@end

@implementation WEGSegmentIntegrationFactory

+ (instancetype)sharedInstance {
  static dispatch_once_t once;
  static WEGSegmentIntegrationFactory *sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

+ (instancetype)instanceWithApplication:(UIApplication *)application
                          launchOptions:(NSDictionary *)launchOptions {
  return [self instanceWithApplication:application
                         launchOptions:launchOptions
                  notificationDelegate:nil
                      autoAPNSRegister:YES];
}

+ (instancetype)instanceWithApplication:(UIApplication *)application
                          launchOptions:(NSDictionary *)launchOptions
                       autoAPNSRegister:(BOOL)autoRegister {

  return [self instanceWithApplication:application
                         launchOptions:launchOptions
                  notificationDelegate:nil
                      autoAPNSRegister:autoRegister];
}

+ (instancetype)instanceWithApplication:(UIApplication *)application
                          launchOptions:(NSDictionary *)launchOptions
                   notificationDelegate:
                       (id<WEGInAppNotificationProtocol>)notificationDelegate {

  return [self instanceWithApplication:application
                         launchOptions:launchOptions
                  notificationDelegate:notificationDelegate
                      autoAPNSRegister:YES];
}

+ (instancetype)instanceWithApplication:(UIApplication *)application
                          launchOptions:(NSDictionary *)launchOptions
                   notificationDelegate:
                       (id<WEGInAppNotificationProtocol>)notificationDelegate
                       autoAPNSRegister:(BOOL)autoRegister {
  WEGSegmentIntegrationFactory *factory = [self sharedInstance];
  factory.application = application;
  factory.launchOptions = launchOptions;
  factory.notificationDelegate = notificationDelegate;
  factory.autoAPNSRegister = autoRegister;

  return factory;
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings
                            forAnalytics:(SEGAnalytics *)analytics {
    BOOL __block isInited = NO;
    /*
     Adding main thread check as,
     Segment calls this method on background queue on first launch,
     From second launch onwards it calls this method on main queue.
     */
    
    [self runOnMainQueueWithoutDeadlocking:^{
        NSString *licenceCode = settings[@"licenseCode"];
        isInited = [[WebEngage sharedInstance]
                    application:self.application
                    didFinishLaunchingWithOptions:@{
                        @"WebEngage" : settings ? settings : @{},
                        @"launchOptions" : self.launchOptions ? self.launchOptions : @{}
                    }
                    notificationDelegate:self.notificationDelegate
                    autoRegister:self.autoAPNSRegister
                    setLicenseCode:licenceCode];
    }];
    
    if (isInited) {
        return [[WEGSegmentIntegration alloc] init];
    } else {
        SEGLog(@"Could Not Initialize WebEngage");
        return nil;
    }
}

- (void)runOnMainQueueWithoutDeadlocking:(void (^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (NSString *)key {
  return @"WebEngage";
}

@end
