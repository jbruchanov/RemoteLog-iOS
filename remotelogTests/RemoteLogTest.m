//
//  RemoteLogTest.m
//  remotelog
//
//  Created by Joe Scurab on 7/27/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "RemoteLogTest.h"
#import "RemoteLog.h"
#import <UIKit/UIKit.h>
@interface RemoteLogTest() <RemoteLogRegistrationDelegate>

@end

@implementation RemoteLogTest
static BOOL _finalResult = NO;
static BOOL _hasError = NO;
-(void) setUp{
    [super setUp];
    _finalResult = NO;
    _hasError = NO;
}

-(void) testBaseInit{
    [RemoteLog startWithAppName:@"RemoteLog-iOS" forServerLocation:self.serverUrl withDelegate:self];
    [self activeWait:&_finalResult];
    STAssertEquals(YES, _finalResult, @"Should be finished!");
    STAssertEquals(NO, _hasError, @"Shouldn't be any error!");
}

-(void)didFinish{
    _finalResult = YES;
}

-(void)didException:(NSError *)error{
    _hasError = YES;
}

-(void) activeWait:(BOOL*) stop{
    for(int i = 0;i<5 && *stop == NO;i++){//while(*stop == NO){
        [NSThread sleepForTimeInterval:.5];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}
@end
