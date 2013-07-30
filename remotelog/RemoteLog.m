//
//  RemoteLog.m
//  remotelog
//
//  Created by Joe Scurab on 7/27/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

//TODO: push notifications support
//TODO: toast notification about update

#import "RemoteLog.h"
#import "Device.h"
#import "ServiceConnector.h"
#import "RLog.h"
#import "Settings.h"
#import "Update.h"
#import "LogSender.h"

#define kDeviceId @"DEVICE_ID"
#define kRemoteLog @"RemoteLog"
#define kRemoteLogC "RemoteLog"

#define kSettingsRLog @"RLog"
#define kSettingsUpdate @"Update"
#define kSettingsBlockStart @"BlockStart"

#define kDateTimeFormat @"yyyy-MM-dd HH:mm:ss.SSS"

#pragma mark static variables

/* Static instance variable */
static RemoteLog * _remoteLog;
static NSUserDefaults * _userDefaults;

static BOOL _isRunning;
static NSString *_owner;
static NSString *_userName;
static NSString *_password;

static int _deviceId;
static NSString *_appBuild;
static NSString *_appName;
static NSString *_appVersion;
static NSDateFormatter *_dateFormater;


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
    return _remoteLog;
}

/*
 Release anything related with RemoteLog
 */
+(void)release{
    [LogSender release];
    _remoteLog = nil;
    _userDefaults = nil;
    _owner = nil;
    _appBuild = nil;
    _appName = nil;
    _appVersion = nil;
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
    
    //init some default data for usage with RemoteLog
    NSDictionary *bundle = [[NSBundle mainBundle] infoDictionary];
    _dateFormater = [[NSDateFormatter alloc] init];
    [_dateFormater setDateFormat:kDateTimeFormat];
    
    _isRunning = YES;
    _userDefaults = [[NSUserDefaults alloc]initWithUser:kRemoteLog];

    _appName = appName;
    _appVersion = [bundle valueForKey:@"CFBundleShortVersionString"];
    _appBuild = [bundle valueForKey:@"CFBundleVersion"];
    
    ServiceConnector *connector = [[ServiceConnector alloc]initWithURL:serverLocation userName:nil andPassword:nil];

    //init logSender
    [[[LogSender alloc]initWithServiceConnector:connector] start];
    
    //run async registration process
    dispatch_async(dispatch_queue_create(kRemoteLogC, NULL), ^{
        @try {
            //send registration
            BOOL reged = [RemoteLog sendRegistrationWith:connector withAppName:appName withDelegate:delegate];
            //if fine, try download any settings from server
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
 @param connector
 @param appName
 @param delegate
 @return YES if registration was successful
 */
+(BOOL)sendRegistrationWith:(ServiceConnector*) conector
                withAppName:(NSString*) appName
               withDelegate:(id<RemoteLogRegistrationDelegate>)delegate{
    
    //try get deviceId, 0 if unknown
    _deviceId = [_userDefaults integerForKey:kDeviceId];
    
    Device *dev = [Device deviceWithRealValues];
    //fill rest of values for registration
    dev.Owner = _owner;
    dev.App = appName;
    dev.AppVersion = _appVersion;
    dev.DeviceID = _deviceId;
    
    //send device to server
    Response *r = [conector saveDevice:dev];
    
    //check responses
    if(!r){
        [RemoteLog notifyAboutError:[[NSException alloc]initWithName:kRemoteLog reason:kErrorUnableToSendRegistration userInfo:nil]
                       withDelegate:delegate];
        return NO;
    }

    //updated serverId, should be same
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

/* 
 Load custom settings
 
 @param appName
 @param connector
 @param delegate
 */
+(void) loadSettingsForApp:(NSString*)appName withServiceConnector:(ServiceConnector*) connector withDelegate:(id<RemoteLogRegistrationDelegate>)delegate{
    int devId = [_userDefaults integerForKey:kDeviceId];
    
    Response *resp = [connector loadSettings:devId forApp:appName];
    NSArray *settings = [Settings settingsFromJsonArray:resp.Context];
    
    if(settings && [settings count] > 0){
        //there can be multiple settings object (1st - global, 2nd - target for this particular device)
        for(Settings *s in settings){
            NSDictionary *dict = s.JsonValueDictionary;
            if(dict){
                id rlog = [dict objectForKey:kSettingsRLog];
                if(rlog){ //Different logging value
                    [RemoteLog didReceiveRLogSettings:rlog];
                }
                
                NSDictionary *update = [dict objectForKey:kSettingsUpdate];
                if(update){ //we have update notification
                    [RemoteLog didReceiveUpdateNofication:[Update updateFromJson:update]];
                }
                
                id blockStart = [dict objectForKey:kSettingsBlockStart];
                if(blockStart && [blockStart boolValue]) {//we have blockStart settings
                    [RemoteLog didReceiveBlockStart];
                }
            }
        }
        //notify delegate about downloaded settings
        if(delegate && [delegate respondsToSelector:@selector(didReceiveSettings:)]){
            [delegate didReceiveSettings:nil];
        }
    }
}

+(void)didReceiveRLogSettings:(id)rlog{
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

+(void)didReceiveBlockStart{
    //home button press programmatically
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
    //maybe won't by allowed by APPLE, exit(0) could help
}

+(void)didReceiveUpdateNofication:(Update*)value{
    NSString *newBuild = value.Build;
    if([newBuild floatValue] > [_appBuild floatValue]){//server says new version exists
        dispatch_async(dispatch_get_main_queue(), ^{
            if(value.Type == Dialog){//show dialog about that
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Update", @"Update")
                                           message:value.Message
                                          delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                 otherButtonTitles: nil] show];
                
            }else if(value.Type == Toast){
                //TODO: toast notification about update
            }
        });
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

+(LogItem*) logItemWithDefaultValues{    
    LogItem *item = [LogItem new];
    item.DeviceID = _deviceId;
    item.AppBuild = _appBuild;
    item.Application = _appName;
    item.AppVersion = _appVersion;
    item.Date = [_dateFormater stringFromDate:[NSDate date]];
    return item;
}

@end
