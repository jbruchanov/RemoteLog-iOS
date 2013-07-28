//
//  RemoteLog.m
//  remotelog
//
//  Created by Joe Scurab on 7/27/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "RemoteLog.h"
#import "Device.h"
#import "ServiceConnector.h"
#import "RLog.h"

#define kDeviceId @"DEVICE_ID"
#define kRemoteLog @"RemoteLog"
#define kRemoteLogC "RemoteLog"

#define kSettingsRLog @"RLog"

#pragma mark static variables
/* Singleton instance variable */
static RemoteLog * _instance;
static NSUserDefaults * _userDefaults;
static BOOL _isRunning;
static NSString *_owner;
static NSString *_userName;
static NSString *_password;


@implementation RemoteLog

+(void)setOwner:(NSString*) owner{
    _owner = owner;
}

#pragma mark -

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
    _owner = nil;
}

+(void)startWithAppName:(NSString*)appName
      forServerLocation:(NSString*)serverLocation
           withDelegate:(id<RemoteLogRegistrationDelegate>)delegate{
    
    NSError *err;
    
    //value precheck
    if(_isRunning){
        [RemoteLog notifyAboutError:[[NSError alloc]initWithDomain:kRemoteLog code:kErrorRegistrationAlreadyStarted userInfo:nil]
                       withDelegate:delegate];
        return;
    }
    
    if((_userName && !_password) || (_password && !_userName)){
        [RemoteLog notifyAboutError:[[NSError alloc]initWithDomain:kRemoteLog code:kErrorIncompleteCredentials userInfo:nil]
                       withDelegate:delegate];
        return;
    }
    
    if(!appName){
        [RemoteLog notifyAboutError:[[NSError alloc]initWithDomain:kRemoteLog code:kErrorMissingAppName userInfo:nil]
                       withDelegate:delegate];
        return;
    }
    
    if(!serverLocation){
        [RemoteLog notifyAboutError:[[NSError alloc]initWithDomain:kRemoteLog code:kErrorMissingServerLocation userInfo:nil]
                       withDelegate:delegate];
        return;
    }
    
    _isRunning = YES;
    _userDefaults = [[NSUserDefaults alloc]initWithUser:kRemoteLog];
    
    ServiceConnector *connector = [[ServiceConnector alloc]initWithURL:serverLocation userName:nil andPassword:nil];
    
    dispatch_async(dispatch_queue_create(kRemoteLogC, NULL), ^{
        BOOL reged = [RemoteLog sendRegistrationWith:connector withAppName:appName withDelegate:delegate];
        if(!reged){
            return;//notification already sent
        }
        
        [RemoteLog loadSettingsForApp:appName withServiceConnector:connector withDelegate:delegate];
        
        //TODO: push notification!
        dispatch_async(dispatch_get_main_queue(), ^{
            if(delegate){
                [delegate didFinish];
            }
            _isRunning = NO;
        });
    });
}

/*
 Send device registration to server and update defaults for devID
 */
+(BOOL)sendRegistrationWith:(ServiceConnector*) conector
                withAppName:(NSString*) appName
               withDelegate:(id<RemoteLogRegistrationDelegate>)delegate{
    
    NSDictionary *bundle = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [bundle valueForKey:@"CFBundleVersion"];
    //    NSString *appBuild = [bundle valueForKey:@"CFBundleShortVersionString"];
    NSInteger deviceId = [_userDefaults integerForKey:kDeviceId];
    
    Device *dev = [Device deviceWithRealValues];
    //fill rest of values for registration
    dev.Owner = _owner;
    dev.App = appName;
    dev.AppVersion = appVersion;
    dev.DeviceID = deviceId;
    
    Response *r = [conector saveDevice:dev];
    //check responses
    if(!r){
        [RemoteLog notifyAboutError:[[NSError alloc]initWithDomain:kRemoteLog code:kErrorUnableToSendRegistration userInfo:nil]
                       withDelegate:delegate];
        return NO;
    }
    
    int serverDeviceId = r.HasError ? 0 : [[r.Context objectForKey:@"DeviceID"] intValue];
    
    if(r.HasError || serverDeviceId == 0){
        [RemoteLog notifyAboutError:[[NSError alloc]initWithDomain:kRemoteLog code:kErrorRegistrationError userInfo:@{kResponse: r}]
                       withDelegate:delegate];
        return NO;
    }
    
    //update device ID
    [_userDefaults setInteger:(NSInteger)serverDeviceId forKey:kDeviceId];
    [_userDefaults synchronize];
    
    return YES;
}

+(void) loadSettingsForApp:(NSString*)appName withServiceConnector:(ServiceConnector*) connector withDelegate:(id<RemoteLogRegistrationDelegate>)delegate{
    int devId = [_userDefaults integerForKey:kDeviceId];
    
    Response *resp = [connector loadSettings:devId forApp:appName];
    NSDictionary *settings = resp.Context;
    if(settings){
        id rlog = [settings objectForKey:kSettingsRLog];
        if(rlog){
            int parsed = -1;
            if([rlog isKindOfClass:[NSString class]]){
                parsed = [RLog settingsValue:(NSString*)rlog];
            }else if([rlog isKindOfClass:[NSNumber class]]){
                parsed = [rlog intValue];
            }else{
                //something really weird came from server, ignore it...
            }
            if(parsed != -1){
                [RLog setMode:parsed];
            }
        }
        //notify delegate about downloaded settings
        [delegate didReceiveSettings:settings];
    }
}

/*
 Send notification about error in main thread
 */
+(void)notifyAboutError:(NSError*) err withDelegate:(id<RemoteLogRegistrationDelegate>)delegate{
    if(delegate){
        if([NSThread isMainThread]){
            if(delegate){
                [delegate didException: err];
            }
            _isRunning = NO;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(delegate){
                    [delegate didException: err];
                }
                _isRunning = NO;
            });
        }
    }else{
        _isRunning = NO;
    }
}

@end
