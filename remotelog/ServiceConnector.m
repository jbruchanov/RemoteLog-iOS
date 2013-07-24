//
//  ServiceConnector.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ServiceConnector.h"
#import "Response.h"

#pragma mark -
#define REGS_URL @"/regs"
#define LOGS_URL @"/logs"
#define SETTINGS_TEMPLATE_URL @"/settings/%s/%s"

#pragma mark -
#define kContentLen @"Content-length"
#define kContentType @"Content-Type"
#define kContentTypeValue @"application/json"

#pragma mark -
#define HTTP_GET @"GET"
#define HTTP_POST @"POST"
#define HTTP_PUT @"PUT"
#pragma mark -

const double kDefaultTimeout = 2.0;

@interface ServiceConnector()

@property (nonatomic, strong) NSString* baseUrl;
@property (nonatomic, strong) NSString* loginBase64;

@end

@implementation ServiceConnector

#pragma mark Init
-(id) initWithURL:(NSString*) url userName:(NSString*) username andPassword:(NSString*)password{
    self = [self init];
    if(self) {
        self.baseUrl = url;
        
        if(username && password){
            self.loginBase64 = [NSString stringWithFormat:@"%@:%@", [self encodeToBase64:username], [self encodeToBase64:password]];
        }
    }
    return self;
}

-(NSString*) encodeToBase64:(NSString*) value{
    //TODO
    return nil;
}

#pragma mark Public

-(Response*) saveDevice:(Device*) device{
    NSData *data = [device toJson];
#ifdef DEBUG
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
#endif
    
    Response *r = [self sendRequest:[self createRequest:[self.baseUrl stringByAppendingString:REGS_URL] withMethod:HTTP_POST withData:data]];
    return r;
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

#pragma mark private

-(NSURLRequest*) createRequest:(NSString*) url withMethod:(NSString*) method withData:(NSData*) data{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:kDefaultTimeout];
    [request setHTTPMethod:method];
    [request setValue:kContentTypeValue forHTTPHeaderField: kContentType];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:kContentLen];
    [request setHTTPBody:data];
    return request;
}

-(Response*) sendRequest:(NSURLRequest*)request{
    NSURLResponse* urlResponse;
    NSError* error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request  returningResponse:&urlResponse error:&error];
    
#ifdef DEBUG
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
#endif
    
    Response *response;
    
    if(error){//global url Error
        NSLog(@"%@", [error description]);
    }else{
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if(error){
            //parsing error
            NSLog(@"%@", [error description]);
        }else{
            response = [Response responseFromJson:json];
            //server error
            if(response.HasError){
                NSLog(@"%@", response.Message);
            }
        }
    }
    
    return response;
}

@end
