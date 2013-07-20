//
//  Device.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

@property (nonatomic) int DeviceID;
@property (nonatomic, strong) NSString* DeviceUUID;
@property (nonatomic, strong) NSString* Brand;
@property (nonatomic, strong) NSString* Platform;
@property (nonatomic, strong) NSString* Version;
@property (nonatomic, strong) NSString* Detail;
@property (nonatomic, strong) NSString* Resolution;
@property (nonatomic, strong) NSString* Owner;
@property (nonatomic, strong) NSString* OSDescription;
@property (nonatomic, strong) NSString* Description;
@property (nonatomic, strong) NSString* PushID;
@property (nonatomic, strong) NSString* Model;
@property (nonatomic, strong) NSString* App;
@property (nonatomic, strong) NSString* AppVersion;

@end
