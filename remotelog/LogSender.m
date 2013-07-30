//
//  LogSender.m
//  remotelog
//
//  Created by Joe Scurab on 7/28/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "LogSender.h"
#import "LogItemBlobRequest.h"

@interface DataContainer : NSObject
@property (nonatomic, strong) LogItem* logItem;
@property (nonatomic, strong) LogItemBlobRequest* blobRequest;
@end

@implementation DataContainer
@end


@interface LogSender()

@property (nonatomic, strong) ServiceConnector *connector;
@property (nonatomic, strong) NSMutableArray *queue;
@property (nonatomic) dispatch_semaphore_t semaphore;
@property (nonatomic) dispatch_queue_t workingQueue;
@property (nonatomic, readwrite) BOOL isRunning;

@end

@implementation LogSender

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
    if(_logSender.semaphore){
        dispatch_release(_logSender.semaphore);
    }
    _logSender.semaphore = NULL;
    _logSender = nil;
    _logSender = nil;
    _logSender = nil;
    _logSender = nil;
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
        self.semaphore = dispatch_semaphore_create(0);
        self.workingQueue = dispatch_queue_create("com.scurab.ios.rlog.LogSender",NULL);
        dispatch_async(self.workingQueue, ^{
            [_logSender workingThreadImpl];
            if(_logSender.semaphore){
                dispatch_release(_logSender.semaphore);
            }
            _logSender.semaphore = NULL;
            self.isRunning = NO;
        });
    }
}


-(void) stop{
    self.isRunning = NO;
    //TODO:notify
}

-(void) workingThreadImpl{
    while(self.isRunning){
        while([self.queue count] > 0){
            
            DataContainer *container = nil;
            
            @synchronized(self.queue){//get item
                container = [self.queue lastObject];//LIFO, not FIFO!
                [self.queue removeLastObject];
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
    if(_isRunning){
        DataContainer *dc = [DataContainer new];
        dc.logItem = item;
        dc.blobRequest = request;
        [self.queue addObject:dc];
        dispatch_semaphore_signal(self.semaphore);
    }
}

@end
