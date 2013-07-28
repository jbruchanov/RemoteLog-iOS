//
//  Update.m
//  remotelog
//
//  Created by Joe Scurab on 7/28/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "Update.h"

@implementation Update

+(Update*) updateFromJson:(NSDictionary*)dict{
    Update *u = [Update new];
    u.Build = [dict objectForKey:@"Build"];
    NSString* type = [dict objectForKey:@"Type"];
    if([@"TOAST" isEqualToString:type]){
        u.Type = Toast;
    }else{
        u.Type = Dialog;
    }
    u.Message = [dict objectForKey:@"Message"];
    return u;
}

@end
