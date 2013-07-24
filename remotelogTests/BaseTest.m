//
//  BaseTest.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "BaseTest.h"
@interface BaseTest()
@property (strong, nonatomic, readwrite) NSString *serviceURL;
@end

@implementation BaseTest

- (void)setUp
{
    [super setUp];
    [self initProperties];
}

-(void) initProperties{
    NSBundle* bundle = [NSBundle mainBundle];
	NSString* plistPath = [bundle pathForResource:@"PrivateList" ofType:@"plist"];
    
	NSDictionary* props = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.serviceURL = [props objectForKey:@"ServerURL"];
}


@end
