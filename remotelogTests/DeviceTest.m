//
//  DeviceTest.m
//  remotelog
//
//  Created by Joe Scurab on 7/28/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "DeviceTest.h"
#import "Device.h"

@implementation DeviceTest


-(void) testGetData{
    Device *d = [Device deviceWithRealValues];
    NSLog(@"%@", [d toJsonString]);
    STAssertNotNil(d, @"Device shouldn't be nil");
}
@end
