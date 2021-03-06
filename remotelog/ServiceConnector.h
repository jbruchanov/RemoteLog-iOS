//
//  ServiceConnector.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

//TODO HTTPS usage
//TODO Test with Basic credentials

#import <Foundation/Foundation.h>
#import "Response.h"
#import "Device.h"
#import "LogItem.h"
#import "LogItemBlobRequest.h"

@interface ServiceConnector : NSObject

-(id) initWithURL:(NSString*) url userName:(NSString*) username andPassword:(NSString*)password;

/* Send device information to server */
-(Response*) saveDevice:(Device*) device;

/* Send one created log item to server */
-(Response*) saveLogItem:(LogItem*) logItem;

/* Send blob item related to logitem */
-(Response*) saveLogItemBlob:(LogItemBlobRequest*) request;

/* Load set of settings for device */
-(Response*) loadSettings:(int) DeviceID forApp:(NSString*)appName;

/* Update token for push notifications */
-(Response*) updatePushToken:(NSString*) token forDeviceID:(int)deviceId;

@end
