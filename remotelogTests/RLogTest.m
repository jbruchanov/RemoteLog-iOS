//
//  RLogTest.m
//  remotelog
//
//  Created by Joe Scurab on 7/28/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "RLogTest.h"
#import "RLog.h"

@implementation RLogTest

-(void) testParsingStringValue{
    NSString *value = @" INFO | DEBUG|WTF |";
    
    int expected = INFO | DEBUGG | WTF;
    int v = [RLog modeWithString:value];
    STAssertEquals(expected, v, @"Values should be same");
}

-(void) testParsingEmptyStringValue{
    NSString *value = @"";
    
    int expected = -1;
    int v = [RLog modeWithString:value];
    STAssertEquals(expected, v, @"Values should be same");
}

-(void) testParsingNilStringValue{
    NSString *value = nil;
    
    int expected = -1;
    int v = [RLog modeWithString:value];
    STAssertEquals(expected, v, @"Values should be same");
}

@end
