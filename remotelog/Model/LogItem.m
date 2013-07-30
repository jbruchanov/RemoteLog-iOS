//
//  LogItem.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "LogItem.h"

#define kDateTimeFormat @"yyyy-MM-dd HH:mm:ss.SSS"

@interface LogItem()
@property (nonatomic, strong, readwrite) NSString* BlobMime;
@end

@implementation LogItem


+(LogItem*) logItemWithSampleData:(int)DeviceID{
    LogItem *item = [LogItem new];
    item.Application = @"RemoteLog-iOS";
    item.AppVersion = @"0.0.1";
    item.AppBuild = @"1";
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:kDateTimeFormat];
    item.Date = [format stringFromDate:[NSDate date]];
    item.Category = @"TestCategory";
    item.Source = @"ServiceConnectorTest";
    item.Message = @"TestMessage";
    item.DeviceID = DeviceID;
    
    return item;
}

- (id)copyWithZone:(NSZone *)zone{
    LogItem *li = [[self class] allocWithZone:zone];
    li.LogItemID = self.LogItemID;
    if(self.Application) li.Application = [NSString stringWithString:self.Application];
    if(self.AppVersion) li.AppVersion = [NSString stringWithString:self.AppVersion];
    if(self.AppBuild) li.AppBuild = [NSString stringWithString:self.AppBuild];
    if(self.Date) li.Date = [NSString stringWithString:self.Date];
    if(self.Category) li.Category = [NSString stringWithString:self.Category];
    if(self.Source) li.Source = [NSString stringWithString:self.Source];
    if(self.Message) li.Message = [NSString stringWithString:self.Message];
    if(self.BlobMime) li.BlobMime = [NSString stringWithString:self.BlobMime];
    li.DeviceID = self.DeviceID;
    return li;
}
@end
