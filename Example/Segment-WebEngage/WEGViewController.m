//
//  WEGViewController.m
//  Segment-WebEngage
//
//  Created by weg-arpit on 06/23/2017.
//  Copyright (c) 2017 weg-arpit. All rights reserved.
//

#import "WEGViewController.h"

@interface WEGViewController () <UITextFieldDelegate>
@end

@implementation WEGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set initial state
    self.logInButtonAction.enabled = NO;
    self.logOutButtonAction.enabled = NO;
    self.textFieldForCUID.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInButtonTapped:(id)sender {
    self.textFieldForCUID.enabled = NO;
    self.logInButtonAction.enabled = NO;
    self.logOutButtonAction.enabled = YES;
    [self login];
}

- (IBAction)logOutButtonTapped:(id)sender {
    self.textFieldForCUID.text = @"";
    self.logInButtonAction.enabled = NO;
    self.logOutButtonAction.enabled = NO;
    self.textFieldForCUID.enabled = YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    // Remove leading and trailing whitespace
    NSString *trimmedText = [updatedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self.logInButtonAction.enabled = trimmedText.length > 0;
    return YES;
}


- (void)login {
    // Your login code
    SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:@"YOUR_WRITE_KEY"];
    [SEGAnalytics setupWithConfiguration:configuration];
    
    NSString *cuid = self.textFieldForCUID.text;
    
    NSDictionary *integrations = @{
        @"integrations": @{
            @"WebEngage": @{
                @"we_email_opt_in": @YES,
                @"we_whatsapp_opt_in": @YES,
                @"we_inapp_opt_in": @YES
            }
        }
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SEGAnalytics sharedAnalytics] identify:cuid traits:@{@"first_name":@"Bla Bla",@"birthday":[NSDate date],@"address":@{@"city":@"Mumbai",@"country":@"India"}} options:integrations];
        [[SEGAnalytics sharedAnalytics] track:@"From Segment" properties:@{@"prop1":@"val1",@"prop2":@"val2"}];
    });
}


    - (void) logOut {
        [ [SEGAnalytics sharedAnalytics] reset];
    }

@end


