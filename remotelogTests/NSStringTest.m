//
//  NSStringTest.m
//  remotelog
//
//  Created by Joe Scurab on 7/30/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "NSStringTest.h"
#import "NSString+URLEncoding.h"

@implementation NSStringTest

-(void) testURLEncoding{
    NSString *value = @"{\"Hello\" : \"World\", \"Test\" : \"ěščřžýáíéťďň\"}";
    NSString *expected = @"%7B%22Hello%22%20%3A%20%22World%22%2C%20%22Test%22%20%3A%20%22%C4%9B%C5%A1%C4%8D%C5%99%C5%BE%C3%BD%C3%A1%C3%AD%C3%A9%C5%A5%C4%8F%C5%88%22%7D";
    NSString *v = [value urlEncode];
    STAssertTrue([v isEqualToString: expected], @"Incorrect URL encoding!");
}

-(void) testBase64Encoding{
    NSString *value = @"FerdaMravenec";
    NSString *expected = @"RmVyZGFNcmF2ZW5lYw==";
    NSString *v = [value base64Encoded];
    STAssertTrue([v isEqualToString:expected], @"Incorrect Base64 encoding!");
}

@end
