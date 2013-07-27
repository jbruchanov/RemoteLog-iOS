//
//  RemoteLog.m
//  remotelog
//
//  Created by Joe Scurab on 7/27/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "RemoteLog.h"

#define kDeviceId @"DEVICE_ID"
#define kRemoteLog @"RemoteLog"
#define kRemoteLogC "RemoteLog"

#pragma mark static variables
/* Singleton instance variable */
static RemoteLog * _instance;
static NSUserDefaults * _userDefaults;
static BOOL _isRunning;


@implementation RemoteLog

/* Don't allow init object */
- (id)init
{
    return nil;
}

/*
 Get singleton instance of RemoteLog
 */
+(RemoteLog*) instance{
    return _instance;
}

/*
 Release anything related with RemoteLog
 */
+(void)release{
    _instance = nil;
    _userDefaults = nil;
}

+(void)startWithAppName:(NSString*)appName
   forServerLocation:(NSString*)serverLocation
  withFinishCallback:(void (^)(RemoteLog*, NSError*))callback{
    
    NSError *err;
    
    if(_isRunning){
        if(callback){
            err = [[NSError alloc]initWithDomain:kRemoteLog code:kErrorRegistrationAlreadyStarted userInfo:nil];
            callback(nil, err);
        }
    }
    
    if(appName && serverLocation){
        _isRunning = YES;
        _userDefaults = [[NSUserDefaults alloc]initWithUser:kRemoteLog];
        
        NSDictionary *bundle = [[NSBundle mainBundle] infoDictionary];
       
        NSString *appVersion = [bundle valueForKey:@"CFBundleVersion"];
        NSString *appBuild = [bundle valueForKey:@"CFBundleShortVersionString"];
        
        NSInteger deviceId = [_userDefaults integerForKey:kDeviceId];
        
        dispatch_async(dispatch_queue_create(kRemoteLogC, NULL), ^{
            [RemoteLog sendRegistration];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(callback){
                    callback(_instance, err);
                }
                _isRunning = NO;
            });
        });
    }    
}

+(void)sendRegistration{
    
}

@end
