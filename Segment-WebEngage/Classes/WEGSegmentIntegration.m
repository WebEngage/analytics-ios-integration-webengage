//
//  WEGSegmentIntegration.m
//  WebEngage
//
//  Created by Arpit on 25/10/16.
//  Copyright © 2016 Saumitra R. Bhave. All rights reserved.
//

#import "WEGSegmentIntegration.h"


@implementation WEGSegmentIntegration

-(instancetype) init {
    
    return self;
}

- (void)identify:(SEGIdentifyPayload *)payload {
    
    WEGUser* user = [WebEngage sharedInstance].user;
    
    if (payload.userId != nil && [payload.userId length] != 0) {
        [user login:payload.userId];
        NSLog(@"[[WebEngage sharedInstance].user login:%@]", payload.userId);
    }
    
    NSMutableDictionary* traitsCopy = [payload.traits mutableCopy];
    
    NSDictionary* traits = payload.traits;
    
    if (traits) {
        if (traits[WEG_SEGMENT_FIRST_NAME_KEY] && [traits[WEG_SEGMENT_FIRST_NAME_KEY] isKindOfClass:[NSString class]]
            &&((NSString*)traits[WEG_SEGMENT_FIRST_NAME_KEY]).length > 0) {
            
            [user setFirstName:traits[WEG_SEGMENT_FIRST_NAME_KEY]];
        }
        
        if (traits[WEG_SEGMENT_LAST_NAME_KEY] && [traits[WEG_SEGMENT_LAST_NAME_KEY] isKindOfClass:[NSString class]]
            && ((NSString*)traits[WEG_SEGMENT_LAST_NAME_KEY]).length > 0) {
            [user setLastName:traits[WEG_SEGMENT_LAST_NAME_KEY]];
        }
        
        if (!(traits[WEG_SEGMENT_FIRST_NAME_KEY]
              && [traits[WEG_SEGMENT_FIRST_NAME_KEY] isKindOfClass:[NSString class]]
              && ((NSString*)traits[WEG_SEGMENT_FIRST_NAME_KEY]).length > 0)
            && !(traits[WEG_SEGMENT_LAST_NAME_KEY]
                 && [traits[WEG_SEGMENT_LAST_NAME_KEY] isKindOfClass:[NSString class]]
                 && ((NSString*)traits[WEG_SEGMENT_LAST_NAME_KEY]).length > 0)) {
            
            id name = traits[WEG_SEGMENT_NAME_KEY];
            if(name && [name isKindOfClass:[NSString class]] && [name length] > 0) {
                NSArray* nameComponents = [name componentsSeparatedByString:@" "];
                NSString* firstName = nil;
                NSString* lastName = nil;
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
            }
            
        }
        
        
        if (traits[WEG_SEGMENT_EMAIL_KEY] && [traits[WEG_SEGMENT_EMAIL_KEY] isKindOfClass:[NSString class]]
            && ((NSString*)traits[WEG_SEGMENT_EMAIL_KEY]).length > 0) {
            [user setEmail:traits[WEG_SEGMENT_EMAIL_KEY]];
        }
        
        if (traits[WEG_SEGMENT_GENDER_KEY] && [traits[WEG_SEGMENT_GENDER_KEY] isKindOfClass:[NSString class]]
            && ((NSString*)traits[WEG_SEGMENT_GENDER_KEY]).length > 0) {
            
            NSString* gender = traits[WEG_SEGMENT_GENDER_KEY];
            if([gender caseInsensitiveCompare:@"male"] == NSOrderedSame ||
               [gender caseInsensitiveCompare:@"m"] == NSOrderedSame) {
                [user setGender:@"male"];
            } else if([gender caseInsensitiveCompare:@"female"] == NSOrderedSame ||
                      [gender caseInsensitiveCompare:@"f"] == NSOrderedSame) {
                [user setGender:@"female"];
            } else if([gender caseInsensitiveCompare:@"other"] == NSOrderedSame ||
                      [gender caseInsensitiveCompare:@"others"] == NSOrderedSame) {
                [user setGender:@"other"];
            }
        }
        
        if (traits[WEG_SEGMENT_COMPANY_KEY] && [traits[WEG_SEGMENT_COMPANY_KEY] isKindOfClass:[NSString class]]
            &&((NSString*)traits[WEG_SEGMENT_COMPANY_KEY]).length > 0) {
            
            [user setCompany:traits[WEG_SEGMENT_COMPANY_KEY]];
        }
        
        if (traits[WEG_SEGMENT_PHONE_KEY] && [traits[WEG_SEGMENT_PHONE_KEY] isKindOfClass:[NSString class]]
            && ((NSString*)traits[WEG_SEGMENT_PHONE_KEY]).length > 0) {
            [user setPhone:traits[WEG_SEGMENT_PHONE_KEY]];
        }

        
        if (traits[WEG_SEGMENT_BIRTH_DATE_KEY]) {
            
            
            id birthDay = traits[WEG_SEGMENT_BIRTH_DATE_KEY];
            
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
        
        if (traits[WEG_HASHED_EMAIL_KEY] && [traits[WEG_HASHED_EMAIL_KEY] isKindOfClass:[NSString class]]
            && ((NSString*)traits[WEG_HASHED_EMAIL_KEY]).length > 0) {
            [user setHashedEmail:traits[WEG_HASHED_EMAIL_KEY]];
        }
        
        if (traits[WEG_HASHED_PHONE_KEY] && [traits[WEG_HASHED_PHONE_KEY] isKindOfClass:[NSString class]]
            && ((NSString*)traits[WEG_HASHED_PHONE_KEY]).length > 0) {
            [user setHashedPhone:traits[WEG_HASHED_PHONE_KEY]];
        }
        
        if (traits[WEG_PUSH_OPT_IN_KEY] && [traits[WEG_PUSH_OPT_IN_KEY] isKindOfClass:[NSNumber class]]) {
            [user setOptInStatusForChannel:WEGEngagementChannelPush status:[traits[WEG_PUSH_OPT_IN_KEY] boolValue]];
        }
        
        if (traits[WEG_SMS_OPT_IN_KEY] && [traits[WEG_SMS_OPT_IN_KEY] isKindOfClass:[NSNumber class]]) {
            [user setOptInStatusForChannel:WEGEngagementChannelSMS status:[traits[WEG_SMS_OPT_IN_KEY] boolValue]];
        }
        
        if (traits[WEG_EMAIL_OPT_IN_KEY] && [traits[WEG_EMAIL_OPT_IN_KEY] isKindOfClass:[NSNumber class]]) {
            [user setOptInStatusForChannel:WEGEngagementChannelEmail status:[traits[WEG_EMAIL_OPT_IN_KEY] boolValue]];
        }
        
        if (traits[WEG_SEGMENT_ADDRESS_KEY] && [traits[WEG_SEGMENT_ADDRESS_KEY] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary* address = traits[WEG_SEGMENT_ADDRESS_KEY];
            
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
    NSDictionary* data = [payload.properties copy];
    
    if (eventName && eventName.length > 0) {
        
        if (data) {
            [[WebEngage sharedInstance].analytics trackEventWithName:eventName andValue:data];
        } else {
            [[WebEngage sharedInstance].analytics trackEventWithName:eventName];
        }
    }

}


- (void)screen:(SEGScreenPayload *)payload {

    NSString* screenName = payload.name;
    NSString* category = payload.category;
    
    NSMutableDictionary* data = [payload.properties mutableCopy];
    
    BOOL hasData = YES;
    BOOL hasCategory = NO;
    if (!data) {
        data = [[NSMutableDictionary alloc] init];
        hasData = NO;
    }
    
    if (category && category.length > 0 ) {
        
        [data setObject:category forKey:@"category"];
        hasCategory = YES;
    }
    
    if (screenName && screenName.length > 0) {
        
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
    NSLog(@"[[WebEngage sharedInstance].user logout]");
}

- (void)group:(SEGGroupPayload *)payload {
    NSLog(@"WebEngage SDK does not support the `group` operation");
}


- (void)alias:(SEGAliasPayload *)payload {
    NSLog(@"WebEngage SDK does not support the `alias` operation");
}






@end
