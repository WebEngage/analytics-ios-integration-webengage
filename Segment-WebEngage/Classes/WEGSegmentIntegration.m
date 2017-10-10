//
//  WEGSegmentIntegration.m
//  WebEngage
//
//  Created by Arpit on 25/10/16.
//  Copyright © 2016 Saumitra R. Bhave. All rights reserved.
//

#import "WEGSegmentIntegration.h"
#import <Analytics/SEGAnalyticsUtils.h>

@implementation WEGSegmentIntegration

-(instancetype) init {
    
    return self;
}

- (void)identify:(SEGIdentifyPayload *)payload {
    
    WEGUser* user = [WebEngage sharedInstance].user;
    
    if (payload.userId) {
        [user login:payload.userId];
        SEGLog(@"[[WebEngage sharedInstance].user login:%@]", payload.userId); // example Segment Log - please add to the integration
    }
    
    NSDictionary* traits = payload.traits;
    if (!traits) {
        return;
    }
    NSMutableDictionary* traitsCopy = [payload.traits mutableCopy];
    
    // While I don't believe this is necessary, we can ensure the value is of type NSString with stringValue
    NSString* firstName = [self getStringValue:traits[WEG_SEGMENT_FIRST_NAME_KEY]];
    if (firstName) {
        [user setFirstName:firstName];
    }
    
    NSString* lastName = [self getStringValue:traits[WEG_SEGMENT_LAST_NAME_KEY]];
    if (lastName) {
        [user setLastName:lastName];
    }
    
    // I wasn't sure of what you were trying to accomplish here, but my understanding was - if
    // there is no firstName or lastName, retrieve name. Split name into firstName and lastName
    // then set it
    if (!firstName && !lastName) {
        
        NSString* name = [self getStringValue:traits[WEG_SEGMENT_NAME_KEY]];
        if (!name) {
            return;
        }
        NSArray* nameComponents = [name componentsSeparatedByString:@" "];
        if(nameComponents &&  nameComponents.count > 0) {
            firstName = nameComponents[0];
            [traitsCopy removeObjectForKey:WEG_SEGMENT_NAME_KEY];
        }
        
        if (nameComponents && nameComponents.count > 1) {
            lastName = nameComponents[nameComponents.count-1];
        }
        
        if (firstName && firstName.length > 0) {
            [user setFirstName:firstName];
        }
        
        if (lastName && lastName.length > 0) {
            [user setLastName:lastName];
        }
        
        NSString* email = [self getStringValue:traits[WEG_SEGMENT_EMAIL_KEY]];
        if (email) {
            [user setEmail:email];
        }
        
        NSString* gender = [self getStringValue:traits[WEG_SEGMENT_GENDER_KEY]];
        if (gender) {
            if([gender caseInsensitiveCompare:@"male"] == NSOrderedSame || [gender caseInsensitiveCompare:@"m"] == NSOrderedSame) {
                [user setGender:@"male"];
            } else if([gender caseInsensitiveCompare:@"female"] == NSOrderedSame || [gender caseInsensitiveCompare:@"f"] == NSOrderedSame) {
                [user setGender:@"female"];
            } else if([gender caseInsensitiveCompare:@"other"] == NSOrderedSame || [gender caseInsensitiveCompare:@"others"] == NSOrderedSame) {
                [user setGender:@"other"];
            }
        }
        
        NSString* company = [self getStringValue:traits[WEG_SEGMENT_COMPANY_KEY]];
        if (company) {
            [user setCompany:company];
        }
        
        NSString* phone = [self getStringValue:traits[WEG_SEGMENT_PHONE_KEY]];
        if (phone) {
            [user setPhone:traits[WEG_SEGMENT_PHONE_KEY]];
        }

        id birthDay = traits[WEG_SEGMENT_BIRTH_DATE_KEY];
        if (birthDay) {
            NSDate* date = nil;
            if ([birthDay isKindOfClass:[NSNumber class]] ) {
                //assumption is Unix Timestamp
                date = [NSDate dateWithTimeIntervalSince1970:((NSNumber*)birthDay).longValue/1000];
            } else if([birthDay isKindOfClass:[NSString class]]) {
                //assumption is ISO Date format
                NSISO8601DateFormatter *dateFormat = [[NSISO8601DateFormatter alloc] init];
                date = [dateFormat dateFromString:birthDay];
            } else if ([birthDay isKindOfClass:[NSDate class]]) {
                date = birthDay;
            }
            
            if (date) {
                NSDateFormatter* birthDateFormatter = [[NSDateFormatter alloc] init];
                [birthDateFormatter setDateFormat:@"yyyy-MM-dd"];
                [birthDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                [birthDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"gb"]];
                [user setBirthDateString:[birthDateFormatter stringFromDate:date]];
            }
            
        }
        
        
        NSDictionary* integration = [payload.integrations valueForKey:@"WebEngage"];
        NSString* wegHashEmail = [self getStringValue:integration[WEG_HASHED_EMAIL_KEY]];
        if (wegHashEmail) {
            [user setHashedEmail:wegHashEmail];
        }
        
        NSString* wegHashedPhoneKey = [self getStringValue:integration[WEG_HASHED_PHONE_KEY]];
        if (wegHashedPhoneKey) {
            [user setHashedPhone:wegHashedPhoneKey];
        }
        
        id wegPushOptInKey = integration[WEG_PUSH_OPT_IN_KEY];
        if (wegPushOptInKey) {
            [user setOptInStatusForChannel:WEGEngagementChannelPush status:[wegPushOptInKey boolValue]];
        }
        
        id wegSmsOptInKey = integration[WEG_SMS_OPT_IN_KEY];
        if (wegSmsOptInKey) {
            [user setOptInStatusForChannel:WEGEngagementChannelSMS status:[wegSmsOptInKey boolValue]];
        }
        
        id wegEmailOptInKey = integration[WEG_EMAIL_OPT_IN_KEY];
        if (wegEmailOptInKey) {
            [user setOptInStatusForChannel:WEGEngagementChannelEmail status:[wegEmailOptInKey boolValue]];
        }
        
        NSDictionary* address = integration[WEG_SEGMENT_ADDRESS_KEY];
        if (address) {
            [address enumerateKeysAndObjectsUsingBlock:^(NSString* key, id obj, BOOL*  stop) {
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

        // Do we not want to remove WEG_SEGMENT_FIRST_NAME_KEY as well?
        [traitsCopy removeObjectForKey:WEG_SEGMENT_LAST_NAME_KEY];
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
        
        
        [traitsCopy enumerateKeysAndObjectsUsingBlock:^(NSString* key, id obj, BOOL*  stop) {
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
}

- (void)track:(SEGTrackPayload *)payload {
    
    NSString* eventName = payload.event;
    
    if (eventName) {
        if (payload.properties) {
            [[WebEngage sharedInstance].analytics trackEventWithName:eventName andValue:payload.properties];
        } else {
            [[WebEngage sharedInstance].analytics trackEventWithName:eventName];
        }
    }

}

- (void)screen:(SEGScreenPayload *)payload {
    
    NSMutableDictionary* data = [payload.properties mutableCopy];
    
    BOOL hasData = YES;
    BOOL hasCategory = NO;
    if (!data) {
        data = [[NSMutableDictionary alloc] init];
        hasData = NO;
    }
    
    NSString* category = payload.category;
    if (category ) {
        [data setObject:category forKey:@"category"];
        hasCategory = YES;
    }
    
    NSString* screenName = payload.name;
    if (screenName) {
        if (hasData || hasCategory) {
            [[WebEngage sharedInstance].analytics navigatingToScreenWithName:screenName andData:data];
        } else {
            [[WebEngage sharedInstance].analytics navigatingToScreenWithName:screenName];
        }
    } else {
        if (hasData || hasCategory) {
            [[WebEngage sharedInstance].analytics updateCurrentScreenData:data];
        }
    }
}

-(void)reset {
    [[WebEngage sharedInstance].user logout];
    SEGLog(@"[[WebEngage sharedInstance].user logout]");
}

- (void)group:(SEGGroupPayload *)payload {
    SEGLog(@"WebEngage SDK does not support the `group` operation");
}

- (void)alias:(SEGAliasPayload *)payload {
    SEGLog(@"WebEngage SDK does not support the `alias` operation");
}

-(NSString *)getStringValue:(id) input{
    if ([input isKindOfClass:[NSString class]]) {
        return input;
    }
    else{
        return [input stringValue];
    }
}
@end
