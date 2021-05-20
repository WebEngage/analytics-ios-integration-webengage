//
//  WEGAppDelegate.m
//  Segment-WebEngage
//
//  Created by weg-arpit on 06/23/2017.
//  Copyright (c) 2017 weg-arpit. All rights reserved.
//

#import "WEGAppDelegate.h"

@implementation WEGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:@"ZC2XY5cuS0pEmjYHAvJHs91NyymJR1hL"];
    
    //Additional Segment Configuration
    configuration.trackApplicationLifecycleEvents = NO; // Enable this to record certain application events automatically!
    configuration.recordScreenViews = NO; // Enable this to record screen views automatically!
    //Register WebEngage Integration With Segment
    [SEGAnalytics debug:YES];
    [configuration use:[WEGSegmentIntegrationFactory instanceWithApplication:application launchOptions:launchOptions]];
    
    // Or use the full blown version
    //[configuration use:[WEGSegmentIntegrationFactory instanceWithApplication:application launchOptions:launchOptions notificationDelegate:self autoAPNSRegister:@NO]];
    [SEGAnalytics setupWithConfiguration:configuration];
    [[SEGAnalytics sharedAnalytics] identify:@"user1" traits:@{@"first_name":@"Bla Bla",@"birthday":[NSDate date],@"address":@{@"city":@"Mumbai",@"country":@"India"}}];
    [[SEGAnalytics sharedAnalytics] track:@"From Segment" properties:@{@"prop1":@"val1",@"prop2":@"val2"}];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
