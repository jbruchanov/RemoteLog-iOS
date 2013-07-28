//
//  LogSender.m
//  remotelog
//
//  Created by Joe Scurab on 7/28/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "LogSender.h"
@interface LogSender()

@property (nonatomic, strong) ServiceConnector *connector;
@property (nonatomic, strong) NSMutableArray *blockingQueue;
@property (nonatomic, strong) NSMutableDictionary *blobs;

@end

@implementation LogSender

static LogSender* _instance;

+(LogSender*) instance{
    return _instance;
}

+(void)release{
    [_instance.blockingQueue removeAllObjects];
    [_instance.blobs removeAllObjects];
    
    _instance.connector = nil;
    _instance.blockingQueue = nil;
    _instance.blobs = nil;
    _instance = nil;
}

-(id)initWithServiceConnector:(ServiceConnector*)connector{
    self = [super init];
    if(self){
        self.connector = connector;
    }
    return self;
}

-(void)addLogItem:(LogItem*)item{
    [self addLogItem:item withBlob:nil];
}

-(void)addLogItem:(LogItem*)item withBlob:(LogItemBlobRequest*) request{
    if(request){
        [self.blobs setObject:request forKey:item];
    }
    [self.blockingQueue addObject:item];
    //notify mutex about new data
}

@end
