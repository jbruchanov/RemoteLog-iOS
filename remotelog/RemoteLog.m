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
#import "Settings.h"
#import "Update.h"

#define kDeviceId @"DEVICE_ID"
#define kRemoteLog @"RemoteLog"
#define kRemoteLogC "RemoteLog"

#define kSettingsRLog @"RLog"
#define kSettingsUpdate @"Update"

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
    
    //value precheck
    if(_isRunning){
        [RemoteLog notifyAboutError:[[NSException alloc]initWithName:kRemoteLog reason:kErrorRegistrationAlreadyStarted userInfo:nil]
                       withDelegate:delegate];
        return;
    }
    
    if((_userName && !_password) || (_password && !_userName)){
        [RemoteLog notifyAboutError:[[NSException alloc]initWithName:kRemoteLog reason:kErrorIncompleteCredentials userInfo:nil]
                       withDelegate:delegate];
        return;
    }
    
    if(!appName){
        [RemoteLog notifyAboutError:[[NSException alloc]initWithName:kRemoteLog reason:kErrorMissingAppName userInfo:nil]
                       withDelegate:delegate];
        return;
    }
    
    if(!serverLocation){
        [RemoteLog notifyAboutError:[[NSException alloc]initWithName:kRemoteLog reason:kErrorMissingServerLocation userInfo:nil]
                       withDelegate:delegate];
        return;
    }
    
    _isRunning = YES;
    _userDefaults = [[NSUserDefaults alloc]initWithUser:kRemoteLog];
    
    ServiceConnector *connector = [[ServiceConnector alloc]initWithURL:serverLocation userName:nil andPassword:nil];
    
    dispatch_async(dispatch_queue_create(kRemoteLogC, NULL), ^{
        @try {
            BOOL reged = [RemoteLog sendRegistrationWith:connector withAppName:appName withDelegate:delegate];
            if(reged){
                [RemoteLog loadSettingsForApp:appName withServiceConnector:connector withDelegate:delegate];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
            [delegate didException:exception];
        }
        @finally {
            //do nothing here
        }
        
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
    NSString *appVersion = [bundle valueForKey:@"CFBundleShortVersionString"];
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
        [RemoteLog notifyAboutError:[[NSException alloc]initWithName:kRemoteLog reason:kErrorUnableToSendRegistration userInfo:nil]
                       withDelegate:delegate];
        return NO;
    }
    
    int serverDeviceId = r.HasError ? 0 : [[r.Context objectForKey:@"DeviceID"] intValue];
    
    if(r.HasError || serverDeviceId == 0){
        [RemoteLog notifyAboutError:[[NSException alloc]initWithName:kRemoteLog reason:kErrorRegistrationError userInfo:@{kResponse: r}]
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
    NSArray *settings = [Settings settingsFromJsonArray:resp.Context];
    if(settings && [settings count] > 0){
        for(Settings *s in settings){
            NSDictionary *dict = s.JsonValueDictionary;
            if(dict){
                id rlog = [dict objectForKey:kSettingsRLog];
                if(rlog){
                    int parsed = -1;
                    if([rlog isKindOfClass:[NSString class]]){
                        parsed = [RLog modeWithString:(NSString*)rlog];
                    }else if([rlog isKindOfClass:[NSNumber class]]){
                        parsed = [rlog intValue];
                    }else{
                        //something really weird came from server, ignore it...
                    }
                    if(parsed != -1){
                        [RLog setMode:parsed];
                    }
                }
                
            }
            
        }
        //notify delegate about downloaded settings
        if(delegate && [delegate respondsToSelector:@selector(didReceiveSettings:)]){
            [delegate didReceiveSettings:nil];
        }
    }
}

/*
 Send notification about error in main thread
 */
+(void)notifyAboutError:(NSException*) err withDelegate:(id<RemoteLogRegistrationDelegate>)delegate{
    if(delegate){
        if([NSThread isMainThread]){
            if(delegate && [delegate respondsToSelector:@selector(didException:)]){
                [delegate didException: err];
            }
            [delegate didFinish];
            _isRunning = NO;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(delegate && [delegate respondsToSelector:@selector(didException:)]){
                    [delegate didException: err];
                }
                [delegate didFinish];
                _isRunning = NO;
            });
        }
    }else{
        _isRunning = NO;
    }
}

@end
