//
//  LogItem.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "LogItem.h"

#define kDateTimeFormat @"yyyy-MM-dd HH:mm:ss.SSS"

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
@end
