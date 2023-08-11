//
//  WEGSegmentIntegrationFactory.h
//  WebEngage
//
//  Copyright (c) 2022 Webklipper Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#if defined(__has_include) && __has_include(<Analytics/SEGIntegration.h>)
#import <Analytics/SEGIntegrationFactory.h>
#else
#import <Segment/SEGIntegrationFactory.h>
#endif
#import "WEGSegmentIntegration.h"

@interface WEGSegmentIntegrationFactory : NSObject<SEGIntegrationFactory>

+(instancetype) instanceWithApplication:(UIApplication*) application
                          launchOptions:(NSDictionary*) launchOptions;

+(instancetype) instanceWithApplication:(UIApplication*) application
                          launchOptions:(NSDictionary*) launchOptions
                       autoAPNSRegister:(BOOL) autoRegister;

+(instancetype) instanceWithApplication:(UIApplication*) application
                          launchOptions:(NSDictionary*) launchOptions
                   notificationDelegate:(id<WEGInAppNotificationProtocol>) notificationDelegate;

+(instancetype) instanceWithApplication:(UIApplication*) application
                          launchOptions:(NSDictionary*) launchOptions
                   notificationDelegate:(id<WEGInAppNotificationProtocol>) notificationDelegate
                       autoAPNSRegister:(BOOL) autoRegister;

- (void)setVersionOfSegmentation;

@end
