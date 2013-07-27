//
//  LogItemBlob.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogItemBlob : NSObject

@property (nonatomic, strong) NSData* Data;
@property (nonatomic) int BlobID;

@end
