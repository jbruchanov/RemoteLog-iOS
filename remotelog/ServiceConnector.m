//
//  ServiceConnector.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ServiceConnector.h"
#import "Response.h"
#import "LogItemBlobRequest.h"
#import "NSString+URLEncoding.h"

#pragma mark -
#define REGS_URL @"/regs"
#define LOGS_URL @"/logs"
#define SETTINGS_TEMPLATE_URL @"/settings/%d/%@"

#pragma mark -
#define kContentLen @"Content-length"
#define kContentType @"Content-Type"
#define kContentTypeValue @"application/json"
#define kContentTypeValue @"application/json"
#define kAuthorization @"Authorization"

#pragma mark -
#define HTTP_GET @"GET"
#define HTTP_POST @"POST"
#define HTTP_PUT @"PUT"
#pragma mark -

static const double kDefaultTimeout = 2.0;

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
          self.loginBase64 = [NSString stringWithFormat:@"Basic %@:%@", [username base64Encoded], [password base64Encoded]];
        }
    }
    return self;
}

#pragma mark Public

/*
 Save Device
 */
-(Response*) saveDevice:(Device*) device{
    return [self sendJSONSerializable:device toUrl:[self.baseUrl stringByAppendingString:REGS_URL]];
}

/*
 Save logItem
 */
-(Response*) saveLogItem:(LogItem*) logItem{
    return [self sendJSONSerializable:logItem toUrl:[self.baseUrl stringByAppendingString:LOGS_URL]];
}

/*
 Save blob
 */
-(Response*) saveLogItemBlob:(LogItemBlobRequest*) request{
    NSString *req = [[request toJsonString] urlEncode];
    NSString *url = [NSString stringWithFormat:@"%@%@?%@", self.baseUrl,LOGS_URL,req];
#ifdef DEBUG
    NSLog(@"%@",url);
#endif
    Response *r = [self sendRequest:[self createUploadRequestForUrl:url withMethod:HTTP_PUT forContentType:request.MimeType withData:request.Data]];
    return r;
}

/*
 Load Settings
 */
-(Response*) loadSettings:(int) DeviceID forApp:(NSString*)appName{
    NSString *url = [self.baseUrl stringByAppendingFormat:SETTINGS_TEMPLATE_URL, DeviceID, appName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:kDefaultTimeout];
    [request setHTTPMethod:HTTP_GET];
    if(self.loginBase64){
        [request setValue:self.loginBase64 forHTTPHeaderField:kAuthorization];
    }
    Response *r = [self sendRequest:request];
    return r;
}

/*
 Update push token
 */
-(Response*) updatePushToken:(NSString*) token forDeviceID:(int)deviceId{
    NSString *url = [self.baseUrl stringByAppendingFormat:@"%@/%d", REGS_URL, deviceId];
    Response *r = [self sendRequest:[self createUploadRequestForUrl:url
                                                         withMethod:HTTP_PUT
                                                     forContentType:kContentTypeValue
                                                           withData:[token dataUsingEncoding:NSUTF8StringEncoding]]];
    return r;
}

#pragma mark private

/*
 Send object to url, Post method is used 
 @param object
 @param url
 @return
 */
-(Response*) sendJSONSerializable:(JSONSerializable*) object toUrl:(NSString*)url{
    NSData *data = [object toJson];
#ifdef DEBUG
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
#endif
    
    Response *r = [self sendRequest:[self createUploadRequestForUrl:url withMethod:HTTP_POST forContentType:kContentTypeValue withData:data]];
    return r;
}

/*
 Creates generic url request
 @param url
 @param method post/put
 @param type  mime type for data
 @param data
 @return 
*/
-(NSURLRequest*) createUploadRequestForUrl:(NSString*) url withMethod:(NSString*) method forContentType:(NSString*) type withData:(NSData*) data{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:kDefaultTimeout];
    [request setHTTPMethod:method];
    [request setValue:type forHTTPHeaderField: kContentType];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:kContentLen];
    [request setHTTPBody:data];
    if(self.loginBase64){
        [request setValue:self.loginBase64 forHTTPHeaderField:kAuthorization];
    }
    return request;
}

/*
 Send request to server and handle errors
 
 @param request
 @return nil if there is any kind of error
 
 */
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
