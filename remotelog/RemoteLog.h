//
//  RemoteLog.h
//  remotelog
//
//  Created by Joe Scurab on 7/27/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kErrorRegistrationAlreadyStarted 1

@interface RemoteLog : NSObject

/*
  Initialize registration
 */
+(void)startWithAppName:(NSString*)appName
   forServerLocation:(NSString*)serverLocation
  withFinishCallback:(void (^)(RemoteLog*, NSError*))callback; /*optional*/
    
/*
 Get singleton instance of RemoteLog
 */
+(RemoteLog*) instance;

/*
 Release anything related with RemoteLog
 */
+(void)release;

@end
