//
//  Settings.h
//  remotelog
//
//  Created by Joe Scurab on 7/28/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (nonatomic) int SettingsID;
@property (nonatomic, strong) NSString* AppName;
@property (nonatomic) int DeviceID; //this can be 0 if settings is global
@property (nonatomic, strong) NSString* JsonValue;
@property (nonatomic, strong) NSDictionary *JsonValueDictionary;

+(NSArray*) settingsFromJsonArray:(NSArray*)array;
+(Settings*) settingsFromJson:(NSDictionary*)dictionary;

@end
