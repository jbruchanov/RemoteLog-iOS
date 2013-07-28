//
//  RemoteLog.h
//  remotelog
//
//  Created by Joe Scurab on 7/27/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kErrorRegistrationAlreadyStarted 1
#define kErrorIncompleteCredentials 2
#define kErrorMissingAppName 3
#define kErrorMissingServerLocation 4
#define kErrorUnableToSendRegistration 4
#define kErrorRegistrationError 5

#define kResponse @"Response"

@class RemoteLog;

@protocol RemoteLogRegistrationDelegate <NSObject>

@required
//-(void) didFinish:(RemoteLog*) remoteLog;
-(void) didFinish;

@optional
-(void) didReceiveSettings:(NSDictionary*) settings;
-(void) didException:(NSError*) error;

@end

@interface RemoteLog : NSObject

/*
 Initialize registration
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
 */
+(void)setOwner:(NSString*) owner;

@end
