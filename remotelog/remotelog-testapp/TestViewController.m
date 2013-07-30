
//  TestViewController.m
//  remotelog
//
//  Created by Joe Scurab on 7/27/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "TestViewController.h"
//#import "ServiceConnector.h"
#import "RLog.h"

@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveScreenshot;
@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)screenshotDidClick:(id)sender {
        [RLog setMode:ALL];
    [RLog takeScreenshot:self Message:@"Test message with screenshot" View:self.view];
}
- (IBAction)buttonDidClick:(id)sender {
    [RLog setMode:ALL];
    [RLog v:self Message:@"TestMessage"];
}

- (void)viewDidUnload {
    [self setSaveScreenshot:nil];
    [super viewDidUnload];
}
@end
