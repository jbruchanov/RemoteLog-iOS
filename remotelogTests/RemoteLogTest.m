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

@implementation RemoteLogTest

-(void) testBaseInit{
     __block BOOL finalResult = NO;
    
    [RemoteLog startWithAppName:@"RemoteLog-iOS" forServerLocation:self.serverUrl withFinishCallback:^(RemoteLog *rl, NSError *err) {
        finalResult = YES;
    }];
    
    [self activeWait:&finalResult];
    STAssertEquals(YES, finalResult, @"Should be finished!");
}

-(void) activeWait:(BOOL*) stop{
    for(int i = 0;i<5 && *stop == NO;i++){//while(*stop == NO){
        [NSThread sleepForTimeInterval:.5];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}
@end