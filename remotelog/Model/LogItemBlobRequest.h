//
//  LogItemBlobRequest.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

#define MIME_TEXT_PLAIN @"text/plain"
#define MIME_TEXT_JSON @"text/json"
#define MIME_IMAGE_JPEG @"image/jpeg"
#define MIME_IMAGE_PNG @"image/png"
#pragma mark -

@interface LogItemBlobRequest : JSONSerializable

@property (nonatomic) int LogItemID;
@property (nonatomic, strong) NSString *MimeType;
@property (nonatomic, readonly) int DataLength;
@property (nonatomic, strong) NSString *FileName;
@property (nonatomic, strong, readonly) NSData *Data;

+(LogItemBlobRequest*) requestForData:(NSData*) data ForType:(NSString*) mimeType;

@end


