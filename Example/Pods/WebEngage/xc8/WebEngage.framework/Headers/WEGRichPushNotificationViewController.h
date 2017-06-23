//
//  WEGRichPushNotificationViewController.h
//  WebEngage
//
//  Created by Arpit Agrawal on 09/11/16.
//  Copyright © 2016 Saumitra R. Bhave. All rights reserved.
//


#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#endif
/**
 *  This class is an encapsulation for managing handling of custom content
 *  push notifications and the interaction over them. This class has to be extended by
 *  the NotificationViewController class for the Notification Content Extension to
 *  add support for WebEngages's rich push notification service. One should never try
 *  to instantiate this class.
 */
@interface WEGRichPushNotificationViewController
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
: UIViewController<UNNotificationContentExtension>
#else
: NSObject
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
-(NSMutableDictionary*) getActivityDictionaryForCurrentNotification;
-(void) updateActivityWithObject: (id) object forKey: (NSString*) key;
-(void) setActivityForCurrentNotification: (NSDictionary*) activity;

-(void) addEventWithName: (NSString*) eventName
              systemData: (NSDictionary*) systemData
         applicationData: (NSDictionary*) applicationData;

-(void) addSystemEventWithName: (NSString*) eventName
                    systemData: (NSDictionary*) systemData
               applicationData: (NSDictionary*) applicationData;

-(void) setCTAWithId: (NSString*) ctaId andLink: (NSString*) actionLink;
#endif

@end

