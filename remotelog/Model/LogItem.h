//
//  LogItem.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface LogItem : JSONSerializable

@property (nonatomic) int LogItemID;
@property (nonatomic, strong) NSString* Application;
@property (nonatomic, strong) NSString* AppVersion;
@property (nonatomic, strong) NSString* AppBuild;
@property (nonatomic, strong) NSString* Date;
@property (nonatomic, strong) NSString* Category;
@property (nonatomic, strong) NSString* Source;
@property (nonatomic, strong) NSString* Message;
@property (nonatomic, strong, readonly) NSString* BlobMime;
@property (nonatomic) int DeviceID;


+(LogItem*) logItemWithSampleData:(int)DeviceID;

@end
