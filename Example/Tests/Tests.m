


//
//  Segment-WebEngageTests.m
//  Segment-WebEngageTests
//
//  Created by Uzma Sayyed on 10/9/2017.
//  Copyright (c) 2017 weg-arpit. All rights reserved.
//

#import <WEGSegmentIntegration.h>
#import <SEGAnalytics.h>
#import <OCMock.h>
#import <SEGPayload.h>

@import XCTest;

@interface Tests : XCTestCase {
  __block id wegClassMock;
  __block WEGUser *wegUserMock;
  __block id<WEGAnalytics> wegAnalyticsMock;
}

@end

@implementation Tests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each
  // test method in the class.
  wegClassMock = OCMClassMock([WebEngage class]);
  OCMStub([wegClassMock sharedInstance]).andReturn(wegClassMock);
  wegAnalyticsMock = OCMProtocolMock(@protocol(WEGAnalytics));
  wegUserMock = OCMClassMock([WEGUser class]);
  OCMStub([wegClassMock user]).andReturn(wegUserMock);
  OCMStub([wegClassMock analytics]).andReturn(wegAnalyticsMock);
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each
  // test method in the class.
  [super tearDown];
}

- (void)testTackEvent {
  WEGSegmentIntegration *instance = [[WEGSegmentIntegration alloc] init];
  SEGTrackPayload *payload =
      [[SEGTrackPayload alloc] initWithEvent:@"App Opened"
                                  properties:nil
                                     context:@{}
                                integrations:@{}];
  [instance track:payload];
  OCMVerify(
      [wegAnalyticsMock trackEventWithName:[OCMArg isEqual:@"App Opened"]]);
  payload = [[SEGTrackPayload alloc] initWithEvent:@"App Opened"
      properties:@{}
      context:@{}
      integrations:@{}];
  [instance track:payload];
  OCMVerify([wegAnalyticsMock trackEventWithName:[OCMArg isEqual:@"App Opened"]
                                        andValue:[OCMArg isEqual:@{}]]);
}

- (void)testTackEventWithProperties {
  WEGSegmentIntegration *instance = [[WEGSegmentIntegration alloc] init];
  NSDate *date = [NSDate date];
  SEGTrackPayload *payload =
      [[SEGTrackPayload alloc] initWithEvent:@"App Opened"
          properties:@{
            @"prop1" : @"val1",
            @"prop2" : @2,
            @"prop3" : @YES,
            @"prop4" : date
          }
          context:@{}
          integrations:@{}];
  [instance track:payload];
  OCMVerify([wegAnalyticsMock
      trackEventWithName:[OCMArg isEqual:@"App Opened"]
                andValue:[OCMArg checkWithBlock:^BOOL(id obj) {
                  NSDictionary *props = obj;
                  return [props[@"prop1"] isEqual:@"val1"] &&
                         [props[@"prop2"] isEqual:@2] &&
                         [props[@"prop3"] isEqual:@YES] &&
                         [props[@"prop4"] isEqual:date] && [props count] == 4;
                }]]);
}

- (void)testScreen {
  WEGSegmentIntegration *instance = [[WEGSegmentIntegration alloc] init];
  SEGScreenPayload *payload =
      [[SEGScreenPayload alloc] initWithName:@"DetailPage"
                                  properties:nil
                                     context:@{}
                                integrations:@{}];
  [instance screen:payload];
  OCMVerify([wegAnalyticsMock navigatingToScreenWithName:@"DetailPage"]);
  payload = [[SEGScreenPayload alloc] initWithName:@"DetailPage"
      properties:@{}
      context:@{}
      integrations:@{}];
  [instance screen:payload];
  OCMVerify([wegAnalyticsMock navigatingToScreenWithName:@"DetailPage"
                                                 andData:[OCMArg isEqual:@{}]]);
}

- (void)testScreenWithProperties {
  WEGSegmentIntegration *instance = [[WEGSegmentIntegration alloc] init];
  NSDate *date = [NSDate date];
  SEGScreenPayload *payload =
      [[SEGScreenPayload alloc] initWithName:@"DetailPage"
          properties:@{
            @"prop1" : @"val1",
            @"prop2" : @2,
            @"prop3" : @YES,
            @"prop4" : date
          }
          context:@{}
          integrations:@{}];
  [instance screen:payload];
  OCMVerify([wegAnalyticsMock
      navigatingToScreenWithName:[OCMArg isEqual:@"DetailPage"]
                         andData:[OCMArg checkWithBlock:^BOOL(id obj) {
                           NSDictionary *props = obj;
                           return [props[@"prop1"] isEqual:@"val1"] &&
                                  [props[@"prop2"] isEqual:@2] &&
                                  [props[@"prop3"] isEqual:@YES] &&
                                  [props[@"prop4"] isEqual:date] &&
                                  [props count] == 4;
                         }]]);
}

- (void)testIdentify {
  WEGSegmentIntegration *instance = [[WEGSegmentIntegration alloc] init];
  SEGIdentifyPayload *payload =
      [[SEGIdentifyPayload alloc] initWithUserId:@"user1"
          anonymousId:@""
          traits:@{}
          context:@{}
          integrations:@{}];
  [instance identify:payload];
  OCMVerify([wegUserMock login:[OCMArg isEqual:@"user1"]]);
}

- (void)testIdentifyWithProperties {
  WEGSegmentIntegration *instance = [[WEGSegmentIntegration alloc] init];
  SEGIdentifyPayload *payload =
      [[SEGIdentifyPayload alloc] initWithUserId:@"user1"
          anonymousId:@""
          traits:@{
            @"first_name" : @"user3",
            @"last_name" : @"lastName",
            @"email" : @"user1@domain.com",
            @"name" : @"user2 lastName",
            @"phone" : @"11111",
            @"age" : @24
          }
          context:@{}
          integrations:@{
            @"WebEngage" : @{
              @"we_hashed_email" : @"abcd",
              @"we_hashed_phone" : @"1234",
              @"we_sms_opt_in" : @NO
            }
          }];

  [instance identify:payload];
  OCMVerify([wegUserMock login:[OCMArg isEqual:@"user1"]]);
  OCMVerify([wegUserMock setFirstName:[OCMArg isEqual:@"user3"]]);
  OCMVerify([wegUserMock setLastName:[OCMArg isEqual:@"lastName"]]);
  OCMVerify([wegUserMock setEmail:[OCMArg isEqual:@"user1@domain.com"]]);
  OCMVerify([wegUserMock setPhone:[OCMArg isEqual:@"11111"]]);
  OCMVerify([wegUserMock setHashedEmail:[OCMArg isEqual:@"abcd"]]);
  OCMVerify([wegUserMock setHashedPhone:[OCMArg isEqual:@"1234"]]);
  OCMVerify([wegUserMock setOptInStatusForChannel:WEGEngagementChannelSMS status:NO]);
  OCMVerify([wegUserMock setAttribute:[OCMArg isEqual:@"age"]
                            withValue:[OCMArg isEqual:@24]]);
}

@end
