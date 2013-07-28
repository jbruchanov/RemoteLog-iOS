//
//  LogSender.h
//  remotelog
//
//  Created by Joe Scurab on 7/28/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceConnector.h"
#import "LogItem.h"
#import "LogItemBlobRequest.h"

@interface LogSender : NSObject

+(LogSender*) instance;

+(void)release;

-(id)initWithServiceConnector:(ServiceConnector*)connector;

-(void)addLogItem:(LogItem*)item;
-(void)addLogItem:(LogItem*)item withBlob:(LogItemBlobRequest*) request;

@end
