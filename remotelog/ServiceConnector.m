//
//  ServiceConnector.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ServiceConnector.h"

#define REGS_URL = @"/regs";
#define LOGS_URL = @"/logs";
#define SETTINGS_TEMPLATE_URL = @"/settings/%s/%s";

#define HTTP_GET = "GET";
#define HTTP_POST = "POST";
#define HTTP_PUT = "PUT";

@interface ServiceConnector()

@property (nonatomic, strong) NSString* baseUrl;
@property (nonatomic, strong) NSString* loginBase64;

@end

@implementation ServiceConnector

-(id) initWithURL:(NSString*) url userName:(NSString*) username andPassword:(NSString*)password{
    self = [self init];
    if(self) {
        self.baseUrl = url;
        
        if(username && password){
            self.loginBase64 = [NSString stringWithFormat:@"%@:%@", [self encodeToBase64:username], [self encodeToBase64:password]];
        }
    }
}

-(NSString*) encodeToBase64:(NSString*) value{
    //TODO
    return nil;
}

-(Response*) saveDevice:(Device*) device{
    return nil;
}

-(Response*) saveLogItem:(LogItem*) logItem{
    return nil;
}

-(Response*) saveLogItemBlob:(LogItemBlob*) logItemBlob{
    return nil;
}

-(Response*) loadSettings:(int) DeviceID forApp:(NSString*)appName{
    return nil;
}

-(void) updatePushToken:(NSString*) token{
    
}

@end
