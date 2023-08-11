//
//  WEGSegmentIntegrationFactory.m
//  WebEngage
//
//  Copyright (c) 2022 Webklipper Technologies Pvt Ltd. All rights reserved.
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
@property(nonatomic, strong, readwrite) id<WEGInAppNotificationProtocol> notificationDelegate;
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
        
        
        // Check if license code has been overridden or not
        NSString *LicenseCodeFromInfoPlist = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"WEGLicenseCode"];
        if ([LicenseCodeFromInfoPlist length] != 0){
            SEGLog(@"WebEngage is getting initialised with an overridden LC, received from analytics: %@ but configured LC %@. If you wish to use %@ from analytics, kindly remove `WEGLicenseCode` from info.plist",licenceCode , LicenseCodeFromInfoPlist, licenceCode);
            licenceCode = LicenseCodeFromInfoPlist;
        }
        
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
        [self setVersionOfSegmentation];
        return [[WEGSegmentIntegration alloc] init];
    } else {
        SEGLog(@"Could Not Initialize WebEngage");
        return nil;
    }
}


- (void)setVersionOfSegmentation {
    // Get the bundle for the "com.webengage.WEPersonalization" identifier
    NSBundle *SegmentationBundle = [NSBundle bundleWithIdentifier:@"org.cocoapods.Segment-WebEngage"];
    if (!SegmentationBundle) {
        NSLog(@"SegmentationBundle bundle not found.");
        return;
    }
    
    // Fetch the value for the key "WEGPersonalizationSDKVersion" from the Info.plist of the specified bundle
    NSString *version = [SegmentationBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (![version isKindOfClass:[NSString class]] || version.length == 0) {
        NSLog(@"CFBundleShortVersionString not available or invalid.");
        return;
    }
    WegVersionKey key = WegVersionKeySEG;
    [[WebEngage sharedInstance] setVersionForChildSDK:version forKey:key];
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
