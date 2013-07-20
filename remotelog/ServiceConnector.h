//
//  ServiceConnector.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
#import "Device.h"
#import "LogItem.h"
#import "LogItemBlob.h"

@interface ServiceConnector : NSObject

-(id) initWithURL:(NSString*) url userName:(NSString*) username andPassword:(NSString*)password;

-(Response*) saveDevice:(Device*) device;

-(Response*) saveLogItem:(LogItem*) logItem;

-(Response*) saveLogItemBlob:(LogItemBlob*) logItemBlob;

-(Response*) loadSettings:(int) DeviceID forApp:(NSString*)appName;

-(void) updatePushToken:(NSString*) token;

@end
