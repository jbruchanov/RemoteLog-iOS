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

@property (nonatomic, readonly) BOOL isRunning;

+(LogSender*) instance;

/*
 Release all resources used by LogSender 
 */
+(void)release;

-(id)initWithServiceConnector:(ServiceConnector*)connector;

/*
 Add LogItem into queue
 @param item 
 */
-(void)addLogItem:(LogItem*)item;

/*
 Add LogItem including blobl into queue
 @param item
 @param request
 */
-(void)addLogItem:(LogItem*)item withBlob:(LogItemBlobRequest*) request;

/*
 Start log sender
 */
-(void) start;

/*
 Check if LogSender is running
 @return BOOL
 */
-(BOOL) isRunning;

/*
 Stop LogSender
 */
-(void) stop;


@end
