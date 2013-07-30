//
//  LogSender.m
//  remotelog
//
//  Created by Joe Scurab on 7/28/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "LogSender.h"
#import "LogItemBlobRequest.h"

#pragma mark DataContainer
/*
 Just help class to tide up logItem with blob 
 */
@interface DataContainer : NSObject
@property (nonatomic, strong) LogItem* logItem;
@property (nonatomic, strong) LogItemBlobRequest* blobRequest;
@end
@implementation DataContainer @end

#pragma mark LogSender
@interface LogSender()

@property (nonatomic, strong) ServiceConnector *connector;
@property (nonatomic, strong) NSMutableArray *queue;
@property (nonatomic) dispatch_semaphore_t semaphore;
@property (nonatomic) dispatch_queue_t workingQueue;
@property (nonatomic, readwrite) BOOL isRunning;

@end

@implementation LogSender

//static instance
static LogSender* _logSender;

+(LogSender*) instance{
    return _logSender;
}

+(void)release{
    if(!_logSender){
        return;
    }
    [_logSender stop];
    [_logSender.queue removeAllObjects];
    @synchronized(_logSender){
        if(_logSender.semaphore){
            dispatch_release(_logSender.semaphore);
        }
        _logSender.semaphore = NULL;
    }
    _logSender.connector = nil;
    _logSender.queue = nil;
    _logSender.semaphore = nil;
    _logSender.workingQueue = nil;
}

-(id)initWithServiceConnector:(ServiceConnector*)connector{
    self = [super init];
    if(self){
        self.connector = connector;
        self.queue = [NSMutableArray new];
    }
    _logSender = self;
    return self;
}

-(void) start{
    if(!self.isRunning){
        self.isRunning = YES;
        //create semaphor and workingQueue
        self.semaphore = dispatch_semaphore_create(0);
        self.workingQueue = dispatch_queue_create("com.scurab.ios.rlog.LogSender",NULL);        

        dispatch_async(self.workingQueue, ^{
            //start working thread async
            [_logSender workingThreadImpl];
            //clean when we stopped that
            @synchronized(_logSender){
                if(_logSender.semaphore){
                    dispatch_release(_logSender.semaphore);
                }
                _logSender.semaphore = NULL;
            }
            _logSender.isRunning = NO;
        });
    }
}


-(void) stop{
    self.isRunning = NO;
    @synchronized(_logSender){
        if(self.semaphore){
            dispatch_semaphore_signal(self.semaphore);
        }
    }
}

-(void) workingThreadImpl{
    while(self.isRunning){
        while([self.queue count] > 0){
            
            DataContainer *container = nil;
            
            @synchronized(self.queue){//get item
                container = [self.queue objectAtIndex:0];
                [self.queue removeObjectAtIndex:0];//all indexes will do -1
            }
            
            LogItem *logItem = container.logItem;
            LogItemBlobRequest *blobRequest = container.blobRequest;
            
            //save LogItem
            Response *response = [self.connector saveLogItem:logItem];
            if(response && !response.HasError){
                //fine send blob
                int logItemId = [[response.Context objectForKey:@"ID"] integerValue];
                if(logItemId > 0 && blobRequest){
                    blobRequest.LogItemID = logItemId;
                    //save BLOB
                    [self.connector saveLogItemBlob:blobRequest];
                }
            }
            container.logItem = nil;
            container.blobRequest = nil;
            container = nil;

        }
        //sleep
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    }
}

-(void)addLogItem:(LogItem*)item{
    [self addLogItem:item withBlob:nil];
}

-(void)addLogItem:(LogItem*)item withBlob:(LogItemBlobRequest*) request{
    if(self.isRunning){
        DataContainer *dc = [DataContainer new];
        dc.logItem = item;
        dc.blobRequest = request;
        
        @synchronized(self.queue){
            [self.queue addObject:dc];
        }
        @synchronized(_logSender){
            if(self.semaphore){
                dispatch_semaphore_signal(self.semaphore);
            }
        }
    }
}

@end
