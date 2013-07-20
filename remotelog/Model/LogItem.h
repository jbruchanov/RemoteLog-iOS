//
//  LogItem.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogItem : NSObject

@property (nonatomic) int LogItemID;
@property (nonatomic, strong) NSString* Application;
@property (nonatomic, strong) NSString* AppVersion;
@property (nonatomic, strong) NSString* AppBuild;
@property (nonatomic, strong) NSDate* Date;
@property (nonatomic, strong) NSString* Category;
@property (nonatomic, strong) NSString* Source;
@property (nonatomic, strong) NSString* Message;
@property (nonatomic, strong) NSString* BlobMime;
@property (nonatomic) int DeviceID;

@end
