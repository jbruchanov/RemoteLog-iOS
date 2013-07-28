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

+(Device*) deviceWithRealValues{
    Device *d = [[Device alloc ]init];
    UIDevice *udev = [UIDevice currentDevice];
    UIScreen *screen = [UIScreen mainScreen];
    CGRect bounds = screen.bounds;
    int h = (int)(MAX(bounds.size.height, bounds.size.width) * screen.scale);
    int w = (int)(MIN(bounds.size.height, bounds.size.width) * screen.scale);

    d.Brand = @"Apple";
    d.Platform = udev.systemName;
    d.DevUUID = [udev uniqueIdentifier];
    d.OSDescription = udev.name;
    d.Model = udev.model;
    d.Resolution = [NSString stringWithFormat:@"%dx%d", w, h];
    d.Version = udev.systemVersion;
    
    //add details
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[Device translate:udev.userInterfaceIdiom] forKey:@"InterfaceIdiom"];
    d.Detail = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil] encoding:NSUTF8StringEncoding];
        
    return d;
}

+(NSString*) translate:(UIUserInterfaceIdiom)idiom{
    switch (idiom) {
        case UIUserInterfaceIdiomPad:
            return @"UIUserInterfaceIdiomPad";
        case UIUserInterfaceIdiomPhone:
            return @"UIUserInterfaceIdiomPhone";
        default:
            return [NSString stringWithFormat:@"Unknown: %d", idiom];
    }
}

@end
