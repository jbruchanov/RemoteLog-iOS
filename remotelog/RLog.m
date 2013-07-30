//
//  remotelog.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "RLog.h"
#import "LogItemBlobRequest.h"
#import "RemoteLog.h"
#import "LogSender.h"

#define SEPARATOR @"|"

@implementation RLog

static BOOL _local_mode = NO;
static int _mode = ALL;

+(void) n:(id) source Category:(NSString*) category Message:(NSString*)msg{
    [RLog send:source Category:category Message:msg];
}

+(void) i:(id) source Message:(NSString*)msg{
    [RLog v:source Category:@"Info" Message:msg];
}

+(void) i:(id) source Category:(NSString*) category Message:(NSString*)msg{
    if ((_mode & INFO) == INFO) {
        [RLog send:source Category:category Message:msg];
    }
}

+(void) d:(id) source Message:(NSString*)msg{
    [RLog v:source Category:@"Debug" Message:msg];
}

+(void) d:(id) source Category:(NSString*) category Message:(NSString*)msg{
    if ((_mode & DEBUG) == DEBUG) {
        [RLog send:source Category:category Message:msg];
    }
}

+(void) e:(id) source Message:(NSString*)msg{
    [RLog v:source Category:@"Error" Message:msg];
}

+(void) e:(id) source Category:(NSString*) category Message:(NSString*)msg{
    if ((_mode & ERROR) == ERROR) {
        [RLog send:source Category:category Message:msg];
    }
}

+(void) v:(id) source Message:(NSString*)msg{
    [RLog v:source Category:@"Verbose" Message:msg];
}

+(void) v:(id) source Category:(NSString*) category Message:(NSString*)msg{
    if ((_mode & VERBOSE) == VERBOSE) {
        [RLog send:source Category:category Message:msg];
    }
}

+(void) w:(id) source Message:(NSString*)msg{
    [RLog v:source Category:@"Warning" Message:msg];
}

+(void) w:(id) source Category:(NSString*) category Message:(NSString*)msg{
    if ((_mode & WARNING) == WARNING) {
        [RLog send:source Category:category Message:msg];
    }
}

+(void) wtf:(id) source Message:(NSString*)msg{
    [RLog v:source Category:@"WTF" Message:msg];
}

+(void) wtf:(id) source Category:(NSString*) category Message:(NSString*)msg{
    if ((_mode & WTF) == WTF) {
        [RLog send:source Category:category Message:msg];
    }
}

+(void)takeScreenshot:(id) source Message:(NSString*)msg View:(UIView*)view{
    if ((_mode & SCREENSHOT) == SCREENSHOT) {
        NSData *image = [RLog saveViewToJPEG:view];
        LogItemBlobRequest *blobReq = [LogItemBlobRequest requestForData:image ForType:MIME_IMAGE_JPEG];
        blobReq.FileName = @"screenshot.jpg";
        [RLog send:source Category:@"Screenshot" Message:msg LogItemBlob:blobReq];
    }
}


+(void) send:(id) source Category:(NSString*) category Message:(NSString*)msg{
    [RLog send:source Category:category Message:msg LogItemBlob:nil];
}


+(void) send:(id) source Category:(NSString*) category Message:(NSString*)msg LogItemBlob:(LogItemBlobRequest*)blobReq{
    NSLog(@"[%@] %@", category, msg);
    NSLog(@"%@",[NSThread callStackSymbols]);
    if(_local_mode || _mode == TURN_OFF){
        return;
    }
    
    LogItem *item = [RemoteLog logItemWithDefaultValues];
    if(!item){
        return;//not initialized yet
    }
    item.Category = category;
    item.Message = msg;
    if(source){
        item.Source = NSStringFromClass([source class]);
    }else{
        item.Source = @"Unknown";
    }
    
    LogSender *sender = [LogSender instance];
    if(sender){
        [sender addLogItem:item withBlob:blobReq];
    }
}

+(NSData*) saveViewToJPEG:(UIView*)theView {
    //The image where the view content is going to be saved.
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 2.0);
    [theView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData* imgData = UIImageJPEGRepresentation(image, 80);
    return imgData;
}

+(void) setMode:(int)mode{
    _mode = mode;
}

#pragma mark parsing

/*
  parse String into numeric value
  @param mode can be one or multiple values separeted by '|' (e.g. "ALL" or "WTF|INFO")
  @return value if it's valid, otherwise -1
 */
+(int) modeWithString:(NSString*)mode{
    int result = 0;
    BOOL found = NO;
    
    if(mode){
        NSCharacterSet *whiteSpaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        mode = [mode stringByTrimmingCharactersInSet:whiteSpaces];
        NSArray *values = [mode componentsSeparatedByString:SEPARATOR];
        for(NSString *value in values){
            NSString *v = [value stringByTrimmingCharactersInSet:whiteSpaces];
            int parsedValue = [RLog getModeValue:v];
            if(parsedValue >= TURN_OFF && parsedValue <= (ALL)){
                found = YES;
                result |= parsedValue;
            }
        }
    }
    return found ? result : -1;
}

/*
 parse string value into numeric one
 */
+(int) getModeValue:(NSString*) value {
    int result = -1;
    if ([@"TURN_OFF" isEqualToString:value]) {
        return TURN_OFF;
    } else if ([@"INFO" isEqualToString:value]) {
        return INFO;
    } else if ([@"VERBOSE" isEqualToString:value]) {
        return VERBOSE;
    } else if ([@"DEBUG" isEqualToString:value]) {
        return DEBUGG;
    } else if ([@"WARNING" isEqualToString:value]) {
        return TURN_OFF;
    } else if ([@"ERROR" isEqualToString:value]) {
        return ERROR;
    } else if ([@"EXCEPTION" isEqualToString:value]) {
        return EXCEPTION;
    } else if ([@"WTF" isEqualToString:value]) {
        return WTF;
    } else if ([@"SCREENSHOT" isEqualToString:value]) {
        return SCREENSHOT;
    } else if ([@"ALL" isEqualToString:value]) {
        return ALL;
    }
    return result;
}

@end
