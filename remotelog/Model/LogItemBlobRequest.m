//
//  LogItemBlobRequest.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "LogItemBlobRequest.h"
@interface LogItemBlobRequest()

@property (nonatomic, strong, readwrite) NSData *Data;
@property (nonatomic, readwrite) int DataLength;

@end

@implementation LogItemBlobRequest


+(LogItemBlobRequest*) requestForData:(NSData*) data ForType:(NSString*) mimeType{
    LogItemBlobRequest *item;
    if(data){
        item = [[LogItemBlobRequest alloc] init];
        item.Data = data;
        item.DataLength = [data length];
        item.MimeType = mimeType;
    }
    return item;
}

-(BOOL) isFieldSerializable:(NSString *)fieldName{
    return ![@"Data" isEqualToString:fieldName];
}

@end