//
//  LogItemBlobRequest.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "LogItemBlobRequest.h"
@interface LogItemBlobRequest()

@property (nonatomic, strong) LogItemBlob *data;
@property (nonatomic, readwrite) int DataLength;

@end

@implementation LogItemBlobRequest


+(LogItemBlobRequest*) requestWith:(LogItemBlob*) data ForType:(NSString*) mimeType{
    LogItemBlobRequest *item;
    if(data){
        item = [[LogItemBlobRequest alloc] init];
        item.data = data;
        item.DataLength = [data.Data length];
    }
    return item;
}

@end