//
//  WEGSegmentIntegration.m
//  WebEngage
//
//  Created by Arpit on 25/10/16.
//  Copyright © 2016 Saumitra R. Bhave. All rights reserved.
//

#import "WEGSegmentIntegration.h"

#if defined(__has_include) && __has_include(<Analytics/SEGIntegration.h>)
#import <Analytics/SEGAnalyticsUtils.h>
#else
#import <Segment/SEGAnalyticsUtils.h>
#endif

@implementation WEGSegmentIntegration

- (instancetype)init {

  return self;
}

- (void)identify:(SEGIdentifyPayload *)payload {

  WEGUser *user = [WebEngage sharedInstance].user;

  if (payload.userId) {
    [user login:payload.userId];
    SEGLog(@"[[WebEngage sharedInstance].user login:%@]", payload.userId);
  }

  NSDictionary *traits = payload.traits;
  if (!traits) {
    SEGLog(@"WebEngage Received No Traits, Returning without doing anything");
    return;
  }
  NSMutableDictionary *traitsCopy = [payload.traits mutableCopy];

  NSString *firstName =
      [self getStringValue:traits[WEG_SEGMENT_FIRST_NAME_KEY]];
  if (firstName) {
    SEGLog(@"[[WebEngage sharedInstance].user setFirstName:%@]", firstName);
    [user setFirstName:firstName];
  }

  NSString *lastName = [self getStringValue:traits[WEG_SEGMENT_LAST_NAME_KEY]];
  if (lastName) {
    SEGLog(@"[[WebEngage sharedInstance].user setLastName:%@]", lastName);
    [user setLastName:lastName];
  }

  if (!firstName && !lastName) {

    NSString *name = [self getStringValue:traits[WEG_SEGMENT_NAME_KEY]];
    if (name) {
        NSArray *nameComponents = [name componentsSeparatedByString:@" "];
        if (nameComponents && nameComponents.count > 0) {
          firstName = nameComponents[0];
          [traitsCopy removeObjectForKey:WEG_SEGMENT_NAME_KEY];
        }

        if (nameComponents && nameComponents.count > 1) {
          lastName = nameComponents[nameComponents.count - 1];
        }

        if (firstName && firstName.length > 0) {
          SEGLog(@"[[WebEngage sharedInstance].user setFirstName:%@]", firstName);
          [user setFirstName:firstName];
        }

        if (lastName && lastName.length > 0) {
          SEGLog(@"[[WebEngage sharedInstance].user setLastName:%@]", firstName);
          [user setLastName:lastName];
        }
    }
  }
    
  NSString *email = [self getStringValue:traits[WEG_SEGMENT_EMAIL_KEY]];
  if (email) {
    SEGLog(@"[[WebEngage sharedInstance].user setEmail:%@]", email);
    [user setEmail:email];
  }

  NSString *gender = [self getStringValue:traits[WEG_SEGMENT_GENDER_KEY]];
  if (gender) {
    if ([gender caseInsensitiveCompare:@"male"] == NSOrderedSame ||
        [gender caseInsensitiveCompare:@"m"] == NSOrderedSame) {
      SEGLog(@"[[WebEngage sharedInstance].user setGender: @\"male\"]");
      [user setGender:@"male"];
    } else if ([gender caseInsensitiveCompare:@"female"] == NSOrderedSame ||
               [gender caseInsensitiveCompare:@"f"] == NSOrderedSame) {
      SEGLog(@"[[WebEngage sharedInstance].user setGender:@\"female\"]");
      [user setGender:@"female"];
    } else if ([gender caseInsensitiveCompare:@"other"] == NSOrderedSame ||
               [gender caseInsensitiveCompare:@"others"] == NSOrderedSame) {
      SEGLog(@"[[WebEngage sharedInstance].user setGender:@\"other\"]");
      [user setGender:@"other"];
    }
  }

  NSString *company = [self getStringValue:traits[WEG_SEGMENT_COMPANY_KEY]];
  if (company) {
    SEGLog(@"[[WebEngage sharedInstance].user setCompany:%@]", company);
    [user setCompany:company];
  }

  NSString *phone = [self getStringValue:traits[WEG_SEGMENT_PHONE_KEY]];
  if (phone) {
    SEGLog(@"[[WebEngage sharedInstance].user setPhone:%@]", phone);
    [user setPhone:phone];
  }

  id birthDay = traits[WEG_SEGMENT_BIRTH_DATE_KEY];
  if (birthDay) {
    NSDate *date = nil;
    if ([birthDay isKindOfClass:[NSNumber class]]) {
      // assumption is Unix Timestamp
      date = [NSDate
          dateWithTimeIntervalSince1970:((NSNumber *)birthDay).longValue /
                                        1000];
    } else if ([birthDay isKindOfClass:[NSString class]]) {
      // assumption is ISO Date format
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
        date = [dateFormatter dateFromString:birthDay];
    } else if ([birthDay isKindOfClass:[NSDate class]]) {
      date = birthDay;
    }

    if (date) {
      NSDateFormatter *birthDateFormatter = [[NSDateFormatter alloc] init];
      [birthDateFormatter setDateFormat:@"yyyy-MM-dd"];
      [birthDateFormatter
          setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
      [birthDateFormatter
          setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"gb"]];
      NSString *dateString = [birthDateFormatter stringFromDate:date];
      SEGLog(@"[[WebEngage sharedInstance].user setBirthDateString:%@]",
             dateString);
      [user setBirthDateString:dateString];
    }
  }

  NSDictionary *integration = [payload.integrations valueForKey:@"WebEngage"];
  NSString *wegHashEmail =
      [self getStringValue:integration[WEG_HASHED_EMAIL_KEY]];
  if (wegHashEmail) {
    SEGLog(@"[[WebEngage sharedInstance].user setHashedEmail:%@]",
           wegHashEmail);
    [user setHashedEmail:wegHashEmail];
  }

  NSString *wegHashedPhoneKey =
      [self getStringValue:integration[WEG_HASHED_PHONE_KEY]];
  if (wegHashedPhoneKey) {
    SEGLog(@"[[WebEngage sharedInstance].user setHashedPhone:%@]",
           wegHashedPhoneKey);
    [user setHashedPhone:wegHashedPhoneKey];
  }

  id wegPushOptInKey = integration[WEG_PUSH_OPT_IN_KEY];
  if (wegPushOptInKey) {
    SEGLog(@"[[WebEngage sharedInstance].user setOptInStatusForChannel:PUSH "
           @"status:%@]",
           [wegPushOptInKey boolValue]);
    [user setOptInStatusForChannel:WEGEngagementChannelPush
                            status:[wegPushOptInKey boolValue]];
  }

  id wegSmsOptInKey = integration[WEG_SMS_OPT_IN_KEY];
  if (wegSmsOptInKey) {
    SEGLog(@"[[WebEngage sharedInstance].user setOptInStatusForChannel:SMS "
           @"status:%@]",
           [wegSmsOptInKey boolValue]);
    [user setOptInStatusForChannel:WEGEngagementChannelSMS
                            status:[wegSmsOptInKey boolValue]];
  }

  id wegEmailOptInKey = integration[WEG_EMAIL_OPT_IN_KEY];
  if (wegEmailOptInKey) {
    SEGLog(@"[[WebEngage sharedInstance].user setOptInStatusForChannel:EMAIL "
           @"status:%@]",
           [wegEmailOptInKey boolValue]);
    [user setOptInStatusForChannel:WEGEngagementChannelEmail
                            status:[wegEmailOptInKey boolValue]];
  }

  // As per https://segment.com/docs/spec/identify/#traits, address is should be
  // read from traits as a known field
  NSDictionary *address = traits[WEG_SEGMENT_ADDRESS_KEY];
  if (address) {
    [address
        enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
          if ([obj isKindOfClass:[NSNumber class]]) {
            [user setAttribute:key withValue:obj];
          } else if ([obj isKindOfClass:[NSDate class]]) {
            [user setAttribute:key withDateValue:obj];
          } else if ([obj isKindOfClass:[NSString class]]) {
            [user setAttribute:key withStringValue:obj];
          } else if ([obj isKindOfClass:[NSArray class]]) {
            [user setAttribute:key withArrayValue:obj];
          } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [user setAttribute:key withDictionaryValue:obj];
          }

        }];
  }

  [traitsCopy removeObjectForKey:WEG_SEGMENT_LAST_NAME_KEY];
  [traitsCopy removeObjectForKey:WEG_SEGMENT_FIRST_NAME_KEY];
  [traitsCopy removeObjectForKey:WEG_SEGMENT_NAME_KEY];
  [traitsCopy removeObjectForKey:WEG_SEGMENT_EMAIL_KEY];
  [traitsCopy removeObjectForKey:WEG_SEGMENT_GENDER_KEY];
  [traitsCopy removeObjectForKey:WEG_SEGMENT_BIRTH_DATE_KEY];
  [traitsCopy removeObjectForKey:WEG_SEGMENT_COMPANY_KEY];
  [traitsCopy removeObjectForKey:WEG_SEGMENT_PHONE_KEY];
  [traitsCopy removeObjectForKey:WEG_HASHED_EMAIL_KEY];
  [traitsCopy removeObjectForKey:WEG_HASHED_PHONE_KEY];
  [traitsCopy removeObjectForKey:WEG_PUSH_OPT_IN_KEY];
  [traitsCopy removeObjectForKey:WEG_EMAIL_OPT_IN_KEY];
  [traitsCopy removeObjectForKey:WEG_SMS_OPT_IN_KEY];
  [traitsCopy removeObjectForKey:WEG_SEGMENT_ADDRESS_KEY];

  SEGLog(@"WebEngage, Remaining traits to be reported as custom attributes %@",
         traitsCopy);

  [traitsCopy enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj,
                                                  BOOL *stop) {
    if ([obj isKindOfClass:[NSNumber class]]) {
      SEGLog(@"[[WebEngage sharedInstance].user setAttribute:%@ withValue:%@]",
             key, obj);
      [user setAttribute:key withValue:obj];
    } else if ([obj isKindOfClass:[NSDate class]]) {
      SEGLog(
          @"[[WebEngage sharedInstance].user setAttribute:%@ withDateValue:%@]",
          key, obj);
      [user setAttribute:key withDateValue:obj];
    } else if ([obj isKindOfClass:[NSString class]]) {
      SEGLog(@"[[WebEngage sharedInstance].user setAttribute:%@ "
             @"withStringValue:%@]",
             key, obj);
      [user setAttribute:key withStringValue:obj];
    } else if ([obj isKindOfClass:[NSArray class]]) {
      SEGLog(@"[[WebEngage sharedInstance].user setAttribute:%@ "
             @"withArrayValue:%@]",
             key, obj);
      [user setAttribute:key withArrayValue:obj];
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
      SEGLog(@"[[WebEngage sharedInstance].user setAttribute:%@ "
             @"withDictionaryValue:%@]",
             key, obj);
      [user setAttribute:key withDictionaryValue:obj];
    }

  }];
}

- (void)track:(SEGTrackPayload *)payload {

  NSString *eventName = payload.event;

  if (eventName) {
    if (payload.properties) {
      SEGLog(@"[[WebEngage sharedInstance].analytics trackEventWithName:%@ "
             @"andValue:%@]",
             eventName, payload.properties);
      [[WebEngage sharedInstance].analytics
          trackEventWithName:eventName
                    andValue:payload.properties];
    } else {
      SEGLog(@"[[WebEngage sharedInstance].analytics trackEventWithName:%@]",
             eventName);
      [[WebEngage sharedInstance].analytics trackEventWithName:eventName];
    }
  }
}

- (void)screen:(SEGScreenPayload *)payload {

  NSMutableDictionary *data = [payload.properties mutableCopy];

  BOOL hasData = YES;
  BOOL hasCategory = NO;
  if (!data) {
    data = [[NSMutableDictionary alloc] init];
    hasData = NO;
  }

  NSString *category = payload.category;
  if (category) {
    [data setObject:category forKey:@"category"];
    hasCategory = YES;
  }

  NSString *screenName = payload.name;
  if (screenName) {
    if (hasData || hasCategory) {
      SEGLog(@"[[WebEngage sharedInstance].analytics "
             @"navigatingToScreenWithName:%@ andValue:%@]",
             screenName, data);
      [[WebEngage sharedInstance].analytics
          navigatingToScreenWithName:screenName
                             andData:data];
    } else {
      SEGLog(@"[[WebEngage sharedInstance].analytics "
             @"navigatingToScreenWithName:%@]",
             screenName);
      [[WebEngage sharedInstance].analytics
          navigatingToScreenWithName:screenName];
    }
  } else {
    if (hasData || hasCategory) {
      SEGLog(
          @"[[WebEngage sharedInstance].analytics updateCurrentScreenData:%@]",
          data);
      [[WebEngage sharedInstance].analytics updateCurrentScreenData:data];
    }
  }
}

- (void)reset {
  [[WebEngage sharedInstance].user logout];
  SEGLog(@"[[WebEngage sharedInstance].user logout]");
}

- (void)registeredForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  SEGLog(@"didRegisterForRemoteNotificationsWithDeviceToken Callback from "
         @"Segment");
  NSString *dToken = [self hexRepresentationForData:deviceToken];
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  BOOL tokenRefreshRequired = NO;
  if ([preferences objectForKey:@"gcm_registered_token"] == nil) {
    SEGLog(@"No cached APNS token found");
    tokenRefreshRequired = YES;
  } else {
    NSString *cachedToken = [preferences stringForKey:@"gcm_registered_token"];
    if (![cachedToken isEqualToString:dToken]) {
      tokenRefreshRequired = YES;
      SEGLog(@"Cached APNS token different from current token");
    } else {
      SEGLog(@"Cached APNS token same as current token");
    }
  }
  if (tokenRefreshRequired) {
    SEGLog(@"[[WebEngage sharedInstance].analytics "
           @"trackEventWithName:@\"we_gcm_registered\" "
           @"andValue:@{@\"event_data_overrides\" : @{@\"gcm_regId\" : %@}}]",
           dToken);
    [[WebEngage sharedInstance].analytics
        trackEventWithName:@"we_gcm_registered"
                  andValue:@{
                    @"event_data_overrides" : @{@"gcm_regId" : dToken}
                  }];
    [preferences setObject:dToken forKey:@"gcm_registered_token"];
    [preferences synchronize];
  }
}

- (void)group:(SEGGroupPayload *)payload {
  SEGLog(@"WebEngage SDK does not support the `group` operation");
}

- (void)alias:(SEGAliasPayload *)payload {
  SEGLog(@"WebEngage SDK does not support the `alias` operation");
}

- (NSString *)getStringValue:(id)input {
  if ([input isKindOfClass:[NSString class]]) {
    return input;
  } else {
    return [input stringValue];
  }
}

- (NSString *)hexRepresentationForData:(NSData *)data {
  const unsigned char *bytes = (const unsigned char *)[data bytes];
  NSUInteger nbBytes = [data length];
  NSUInteger strLen = 2 * nbBytes;

  NSMutableString *hex = [[NSMutableString alloc] initWithCapacity:strLen];
  for (NSUInteger i = 0; i < nbBytes;) {
    [hex appendFormat:@"%02X", bytes[i]];
    ++i;
  }
  return hex;
}
@end
