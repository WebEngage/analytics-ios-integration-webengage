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
#import <SEGTrackPayload.h>

@import XCTest;

@interface Tests : XCTestCase{
    SEGAnalyticsConfiguration *configuration;
    __block id wegClassMock;
    __block WEGUser* wegUserMock;
    __block id<WEGAnalytics> wegAnalyticsMock;
}

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:@"D56SbZAWtEIDvBbxuHchMGEx5WkvzP2U"];
    configuration.trackApplicationLifecycleEvents = YES;
    configuration.recordScreenViews = YES;
    [SEGAnalytics setupWithConfiguration:configuration];
    
    wegClassMock=OCMClassMock([WebEngage class]);
    OCMStub([wegClassMock sharedInstance]).andReturn(wegClassMock);
    wegAnalyticsMock = OCMProtocolMock(@protocol(WEGAnalytics));
    OCMStub([wegClassMock user]).andReturn(wegUserMock);
    OCMStub([wegClassMock analytics]).andReturn(wegAnalyticsMock);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialization
{
    
}

-(void)testTackEvent
{
    NSDictionary *properties=@{@"price":@"100",@"product name":@"test product1"};
    [[SEGAnalytics sharedAnalytics] track:@"test event" properties:properties];
    WEGSegmentIntegration* instance = [[WEGSegmentIntegration alloc] init];
    SEGTrackPayload *payload=[[SEGTrackPayload alloc] initWithEvent:@"test event" properties:properties context:nil integrations:nil];
    [instance track:payload];
    OCMVerify(
              [wegAnalyticsMock trackEventWithName:[OCMArg isEqual:@"test event"] andValue:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSLog(@"Verify %@ has correct values",obj);
        return YES;
    }]]);
}


-(void)testIdentify
{
    NSDictionary* traits=@{@"first_name":@"test",@"email":@"test@test.com",@"gender":@"female",@"phone":@"0918273645"};
    [[SEGAnalytics sharedAnalytics] identify:@"test123" traits:traits];
    WEGSegmentIntegration* instance = [[WEGSegmentIntegration alloc] init];
    SEGIdentifyPayload* payload=[[SEGIdentifyPayload alloc] initWithUserId:@"test123" anonymousId:nil traits:traits context:nil integrations:nil];
    [instance identify:payload];
    OCMVerify([wegUserMock setFirstName:[OCMArg isEqual:@"test"]]);
    OCMVerify([wegUserMock setEmail:[OCMArg isEqual:@"test@test.com"]]);
    OCMVerify([wegUserMock setPhone:[OCMArg isEqual:@"0918273645"]]);
    OCMVerify([wegUserMock setGender:[OCMArg isEqual:@"female"]]);
}
@end

