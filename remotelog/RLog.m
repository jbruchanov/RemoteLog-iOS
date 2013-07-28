//
//  remotelog.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "RLog.h"
#import "LogItemBlobRequest.h"

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
    }
}


+(void) send:(id) source Category:(NSString*) category Message:(NSString*)msg{
    [RLog send:source Category:category Message:msg Data:nil];
}


+(void) send:(id) source Category:(NSString*) category Message:(NSString*)msg LogItemBlob:(LogItemBlobRequest*)blobReq{
    NSLog(@"[%@] %@", category, msg);
    NSLog(@"%@",[NSThread callStackSymbols]);
    if(_local_mode || _mode == TURN_OFF){
        return;
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

+(int) settingsValue:(NSString*) value{
    return -1;
}

@end
