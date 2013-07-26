//
//  BaseTest.h
//  remotelog
//
//  Created by Jiří Bruchanov on 26/07/2013.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface BaseTest : SenTestCase

@property (strong, nonatomic, readonly) NSString* serverUrl;

@end
