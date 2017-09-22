//
//  WEGSegmentIntegration.h
//  WebEngage
//
//  Created by Arpit on 25/10/16.
//  Copyright © 2016 Saumitra R. Bhave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegration.h>
#import <WebEngage/WebEngage.h>

#define WEG_SEGMENT_FIRST_NAME_KEY @"first_name"
#define WEG_SEGMENT_LAST_NAME_KEY @"last_name"
#define WEG_SEGMENT_NAME_KEY @"name"
#define WEG_SEGMENT_EMAIL_KEY @"email"
#define WEG_SEGMENT_PHONE_KEY @"phone"
#define WEG_SEGMENT_BIRTH_DATE_KEY @"birthday"
#define WEG_SEGMENT_GENDER_KEY @"gender"
#define WEG_SEGMENT_COMPANY_KEY @"company"
#define WEG_HASHED_EMAIL_KEY @"we_hashed_email"
#define WEG_HASHED_PHONE_KEY @"we_hashed_phone"
#define WEG_PUSH_OPT_IN_KEY @"we_push_opt_in"
#define WEG_SMS_OPT_IN_KEY @"we_sms_opt_in"
#define WEG_EMAIL_OPT_IN_KEY @"we_email_opt_in"
#define WEG_SEGMENT_ADDRESS_KEY @"address"




@interface WEGSegmentIntegration : NSObject<SEGIntegration>

-(instancetype) init;

@end
