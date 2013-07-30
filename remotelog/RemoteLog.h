//
//  RemoteLog.h
//  remotelog
//
//  Created by Joe Scurab on 7/27/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogItem.h"

#define kErrorRegistrationAlreadyStarted @"RegistrationAlreadyStarted"
#define kErrorIncompleteCredentials @"IncompleteCredentials"
#define kErrorMissingAppName @"MissingAppName"
#define kErrorMissingServerLocation @"MissingServerLocation"
#define kErrorUnableToSendRegistration @"UnableToSendRegistration"
#define kErrorRegistrationError @"RgistrationError"

#define kResponse @"Response"

@class RemoteLog;

@protocol RemoteLogRegistrationDelegate <NSObject>

@required
-(void) didFinish;

@optional
-(void) didReceiveSettings:(NSDictionary*) settings;
-(void) didException:(NSException*) exception;

@end

@interface RemoteLog : NSObject

/*
 Initialize registration
 @param appName
 @param serverLocation
 @param delegate optional
 */
+(void)startWithAppName:(NSString*)appName
      forServerLocation:(NSString*)serverLocation
           withDelegate:(id<RemoteLogRegistrationDelegate>) delegate; /*optional*/

/*
 Get singleton instance of RemoteLog
 */
+(RemoteLog*) instance;

/*
 Release anything related with RemoteLog
 */
+(void)release;

/*
 Set custom owner for Device
 @param owner
 */
+(void)setOwner:(NSString*) owner;

/*
 Create template of LogItem object for RLog
 @return 
 */
+(LogItem*) logItemWithDefaultValues;

@end
