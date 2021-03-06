//
//  ServiceConnectorTest.m
//  remotelog
//
//  Created by Jiří Bruchanov on 26/07/2013.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ServiceConnectorTest.h"
#import "ServiceConnector.h"
#import "LogItem.h"
#import "LogItemBlobRequest.h"

@implementation ServiceConnectorTest


-(void) testSaveDevice{
    ServiceConnector *sc = [[ServiceConnector alloc]initWithURL:self.serverUrl userName:nil andPassword:nil];
    Device *d = [Device deviceWithExampleValues];
    //works fine, id 7007, 7063
    return;
    [sc saveDevice:d];
}

-(void) testSaveLogItem{
    return;
    ServiceConnector *sc = [[ServiceConnector alloc]initWithURL:self.serverUrl userName:nil andPassword:nil];
    LogItem *li = [LogItem logItemWithSampleData:7007];
   
    Response *r = [sc saveLogItem:li];
    if(r.HasError){
        NSLog(@"%@", r.Message);
    }
    STAssertEquals(NO, r.HasError, @"Shouldn't have error!");
}

-(void)testLogItemBlobRequestToJson{
    return;

    
    NSData *data = [@"TestData\nblablabla" dataUsingEncoding:NSUTF8StringEncoding];
    
    LogItemBlobRequest *req = [LogItemBlobRequest requestForData:data ForType:@"text/plain"];
    req.LogItemID = 7007;
    req.FileName = @"test.txt";
    
    NSData *json = [req toJson];
    
    NSString *jsonText = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
    
    STAssertNotNil(json, @"Shouldn't be nil!");
    
}

-(void) testSaveLogItemBlobText{
    return;
    ServiceConnector *sc = [[ServiceConnector alloc]initWithURL:self.serverUrl userName:nil andPassword:nil];
    LogItem *li = [LogItem logItemWithSampleData:7007];
    Response *r = [sc saveLogItem:li];
    if(r.HasError){
        NSLog(@"%@", r.Message);
    }
    
    STAssertEquals(NO, r.HasError, @"Shouldn't have error!");
        
    NSData *data = [@"TestData\nblablabla\nNejžluťoučký koníček\něščřžýáíéťďňůú" dataUsingEncoding:NSUTF8StringEncoding];
    
    LogItemBlobRequest *req = [LogItemBlobRequest requestForData:data ForType:@"text/plain"];
    req.FileName = @"test.txt";
    req.LogItemID = [[r.Context objectForKey:@"ID"] integerValue];
    
    r = [sc saveLogItemBlob:req];
    
    if(r.HasError){
        NSLog(@"%@", r.Message);
    }
    STAssertEquals(NO, r.HasError, @"Shouldn't have error!");
}

-(void) testSaveLogItemBlobImage{
    return;
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ios-logo" ofType:@"jpg"];
    if(!filePath){
        STFail(@"image not found");
    }
    NSData *jpegData = [NSData dataWithContentsOfFile:filePath];
    
    ServiceConnector *sc = [[ServiceConnector alloc]initWithURL:self.serverUrl userName:nil andPassword:nil];
    LogItem *li = [LogItem logItemWithSampleData:7007];
    Response *r = [sc saveLogItem:li];
    if(r.HasError){
        NSLog(@"%@", r.Message);
    }
    
    STAssertEquals(NO, r.HasError, @"Shouldn't have error!");
   

    //create sample image
    NSData *data = jpegData;
    
    LogItemBlobRequest *req = [LogItemBlobRequest requestForData:data ForType:@"image/jpeg"];
    req.FileName = @"test.png";
    req.LogItemID = [[r.Context objectForKey:@"ID"] integerValue];
    
    r = [sc saveLogItemBlob:req];
    
    if(r.HasError){
        NSLog(@"%@", r.Message);
    }
    STAssertEquals(NO, r.HasError, @"Shouldn't have error!");
}

-(void)testLoadSettings{
    return;
    ServiceConnector *sc = [[ServiceConnector alloc]initWithURL:self.serverUrl userName:nil andPassword:nil];
    Response *r = [sc loadSettings:7007 forApp:@"RemoteLog-iOS"];
    
    STAssertNotNil(r, @"Shouldn't be nil");
    STAssertNotNil(r.Context, @"Context shouldn't be nil");
    if(r.HasError){
        NSLog(@"%@", r.Message);
    }
    STAssertEquals(NO, r.HasError, @"Shouldn't have error!");
}

-(void) testUpdatePushToken{
    return;
    ServiceConnector *sc = [[ServiceConnector alloc]initWithURL:self.serverUrl userName:nil andPassword:nil];
    Response *r = [sc updatePushToken:@"PushTokenTestBlaBla" forDeviceID:7007];
    STAssertNotNil(r, @"Shouldn't be nil");
    if(r.HasError){
        NSLog(@"%@", r.Message);
    }
    STAssertEquals(NO, r.HasError, @"Shouldn't have error!");
}
@end
