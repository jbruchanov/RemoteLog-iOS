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
    LogItemBlob *lib = [LogItemBlob new];
    
    lib.Data = [@"TestData\nblablabla" dataUsingEncoding:NSUTF8StringEncoding];
    
    LogItemBlobRequest *req = [LogItemBlobRequest requestWith:lib ForType:@"text/plain"];
    req.LogItemID = 7007;
    req.FileName = @"test.txt";
    
    NSData *json = [req toJson];
    
    NSString *jsonText = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
    
    STAssertNotNil(json, @"Shouldn't be nil!");
    
}

-(void) testSaveLogItemBlob{
    return;
    ServiceConnector *sc = [[ServiceConnector alloc]initWithURL:self.serverUrl userName:nil andPassword:nil];
    LogItem *li = [LogItem logItemWithSampleData:7007];
    li.BlobMime = @"text/plain";
    Response *r = [sc saveLogItem:li];
    if(r.HasError){
        NSLog(@"%@", r.Message);
    }
    
    STAssertEquals(NO, r.HasError, @"Shouldn't have error!");
    
    LogItemBlob *lib = [LogItemBlob new];
    
    lib.Data = [@"TestData\nblablabla" dataUsingEncoding:NSUTF8StringEncoding];
    
    LogItemBlobRequest *req = [LogItemBlobRequest requestWith:lib ForType:li.BlobMime];
    req.FileName = @"test.txt";
    
    r = [sc saveLogItemBlob:lib];
    
    if(r.HasError){
        NSLog(@"%@", r.Message);
    }
    STAssertEquals(NO, r.HasError, @"Shouldn't have error!");
}
@end
