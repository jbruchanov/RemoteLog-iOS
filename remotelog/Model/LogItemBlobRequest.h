//
//  LogItemBlobRequest.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogItemBlob.h"

#define MIME_TEXT_PLAIN "text/plain"
#define MIME_TEXT_JSON "text/json"
#define MIME_IMAGE_JPEG "image/jpeg"
#define MIME_IMAGE_PNG "image/png"

@interface LogItemBlobRequest : NSObject

@property (nonatomic) int LogItemID;
@property (nonatomic, strong) NSString *MimeType;
@property (nonatomic, readonly) int DataLength;
@property (nonatomic, strong) NSString *FileName;

+(LogItemBlobRequest*) requestWith:(LogItemBlob*) blob ForType:(NSString*) mimeType;

@end


