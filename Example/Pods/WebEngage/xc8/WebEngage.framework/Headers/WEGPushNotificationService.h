//
//  WEGPushNotificationService.h
//  WebEngage
//
//  Created by Arpit Agrawal on 11/11/16.
//  Copyright © 2016 Saumitra R. Bhave. All rights reserved.
//


#import <Foundation/Foundation.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif


/**
 *  This class is an encapsulation for managing handling prerequisites for
 *  custom content rich push notifications sent using WebEngage. This class
 *  should only be used by extending NotificationService class created as part
 *  of the Notification Service Extension and should not be instantiated as such.
 */
@interface WEGPushNotificationService
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
: UNNotificationServiceExtension
#else
: NSObject
#endif
@end

