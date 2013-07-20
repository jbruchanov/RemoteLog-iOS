//
//  remotelogTests.m
//  remotelogTests
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "remotelogTests.h"
#import "RLog.h"

@implementation remotelogTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    [RLog v:self Message:@"Message"];
}

@end
