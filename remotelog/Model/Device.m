//
//  Device.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "Device.h"

#import <UIKit/UIKit.h>

@implementation Device

+(Device*) deviceWithExampleValues;{
    Device *d = [[Device alloc ]init];
    
    d.Brand = @"Apple";
    d.Platform = @"iPhone";
    d.Version = @"6.0";
    d.Detail = nil;
    d.DevUUID = [[UIDevice currentDevice] uniqueIdentifier];
    d.Resolution = @"640x1136";
    d.Owner = @"xCode";
    d.OSDescription = nil;
    d.Description = nil;
    d.PushID = nil;
    d.Model = @"iPhone 5";
    d.App = @"RemoteLog-iOS";
    d.AppVersion = @"0.0.1";
    
    return d;
}

@end
