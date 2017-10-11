//
//  WEGSegmentIntegrationFactory.m
//  WebEngage
//
//  Created by Arpit on 25/10/16.
//  Copyright © 2016 Saumitra R. Bhave. All rights reserved.
//

#import "WEGSegmentIntegrationFactory.h"
#import <Analytics/SEGAnalyticsUtils.h>

@interface WEGSegmentIntegrationFactory()
@property (nonatomic,strong, readwrite) UIApplication* application;
@property (nonatomic,strong, readwrite) NSDictionary* launchOptions;
@property (nonatomic,strong, readwrite) id<WEGInAppNotificationProtocol> notificationDelegate;
@property (nonatomic, readwrite) BOOL autoAPNSRegister;
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

+(instancetype)instanceWithApplication:(UIApplication *)application
                         launchOptions:(NSDictionary *)launchOptions {
    return [self instanceWithApplication:application
                           launchOptions:launchOptions
                    notificationDelegate:nil
                        autoAPNSRegister:YES];
}

+(instancetype)instanceWithApplication:(UIApplication *)application
                         launchOptions:(NSDictionary *)launchOptions
                      autoAPNSRegister:(BOOL)autoRegister {
    
    return [self instanceWithApplication:application
                           launchOptions:launchOptions
                    notificationDelegate:nil
                        autoAPNSRegister:autoRegister];
    
}

+(instancetype)instanceWithApplication:(UIApplication *)application
                         launchOptions:(NSDictionary *)launchOptions
                  notificationDelegate:(id<WEGInAppNotificationProtocol>)notificationDelegate {
    
    return [self instanceWithApplication:application
                           launchOptions:launchOptions
                    notificationDelegate:notificationDelegate
                        autoAPNSRegister:YES];
    
}

+(instancetype) instanceWithApplication:(UIApplication*) application
                          launchOptions:(NSDictionary*) launchOptions
                   notificationDelegate:(id<WEGInAppNotificationProtocol>) notificationDelegate
                       autoAPNSRegister:(BOOL) autoRegister {
    WEGSegmentIntegrationFactory* factory = [self sharedInstance];
    factory.application = application;
    factory.launchOptions = launchOptions;
    factory.notificationDelegate = notificationDelegate;
    factory.autoAPNSRegister = autoRegister;
    
    return factory;
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics {
    BOOL __block isInited = NO;
    dispatch_sync(dispatch_get_main_queue(), ^{
        isInited = [[WebEngage sharedInstance] application:self.application
                             didFinishLaunchingWithOptions:@{@"WebEngage":settings?settings:@{},
                                                  @"launchOptions":self.launchOptions?self.launchOptions:@{}}
                           notificationDelegate:self.notificationDelegate
                                              autoRegister:self.autoAPNSRegister];
    });
    if(isInited){
        return [[WEGSegmentIntegration alloc] init];
    } else {
        SEGLog(@"Could Not Initialize WebEngage");
        return nil;
    }
}

- (NSString *)key {
    return @"WebEngage";
}

@end
