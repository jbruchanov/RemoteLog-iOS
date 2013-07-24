//
//  BaseTest.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface BaseTest : SenTestCase

@property (strong, nonatomic, readonly) NSString *serviceURL;

@end