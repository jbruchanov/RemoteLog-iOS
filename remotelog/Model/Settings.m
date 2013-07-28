//
//  Settings.m
//  remotelog
//
//  Created by Joe Scurab on 7/28/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "Settings.h"

@implementation Settings

+(NSArray*) settingsFromJsonArray:(NSArray*)array{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[array count]];
    
    for (NSDictionary *dict in array){
        Settings *s = [Settings settingsFromJson:dict];
        [result addObject:s];
    }
    return result;
}

+(Settings*) settingsFromJson:(NSDictionary*)dictionary{
    Settings *s = [Settings new];
    id devId = [dictionary objectForKey:@"DeviceID"];
    if(devId){
        s.DeviceID = [devId intValue];
    }
    s.SettingsID = [[dictionary objectForKey:@"SettingsID"] intValue];
    s.AppName = [dictionary objectForKey:@"AppName"];
    s.JsonValue = [dictionary objectForKey:@"JsonValue"];
    
    if(s.JsonValue){
        s.JsonValueDictionary = [NSJSONSerialization JSONObjectWithData:[s.JsonValue dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    }
    return s;
}
@end
