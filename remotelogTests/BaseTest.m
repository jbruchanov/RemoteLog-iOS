//
//  BaseTest.m
//  remotelog
//
//  Created by Jiří Bruchanov on 26/07/2013.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "BaseTest.h"

@interface BaseTest()

@property (strong, nonatomic, readwrite) NSString* serverUrl;

@end

@implementation BaseTest

-(void) setUp{
    NSBundle *bundle =  [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"PrivateSettings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    if(!dict){
        STFail(@"Unable to load PrivateSettings.plist!");
    }
    self.serverUrl = [dict objectForKey:@"ServerURL"];
    if(!self.serverUrl){
        STFail(@"ServerURL is missing!");
    }
}

@end
