//
//  WEGSegmentIntegrationFactory.m
//  WebEngage
//
//  Created by Arpit on 25/10/16.
//  Copyright © 2016 Saumitra R. Bhave. All rights reserved.
//

#import "WEGSegmentIntegrationFactory.h"


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
    
    
    
    [[WebEngage sharedInstance] application:application
              didFinishLaunchingWithOptions:launchOptions
                       notificationDelegate:notificationDelegate
                               autoRegister:autoRegister];
    
    return [self sharedInstance];
}

- (id)init {
    
    self = [super init];
    return self;
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics {
    return [[WEGSegmentIntegration alloc] init];
}

- (NSString *)key {
    
    return @"WebEngage";
}

@end
