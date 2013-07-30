//
//  remotelog.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LogItemBlobRequest.h"

#define V(msg) {[RLog v:self Message:msg];}
#define D(msg) {[RLog d:self Message:msg];}
#define N(msg) {[RLog n:self Category:@"Notification" Message:msg];}
#define I(msg) {[RLog i:self Message:msg];}
#define W(msg) {[RLog i:self Message:msg];}
#define WTF(msg) {[RLog wtf:self Message:msg];}
#define SCR(msg, view) {[RLog takeScreenshot:self Message:msg View:view];}

static const uint TURN_OFF = 0;
static const uint INFO = 1 << 0;
static const uint VERBOSE = 1 << 1;
static const uint DEBUGG = 1 << 2;
static const uint WARNING = 1 << 3;
static const uint ERROR = 1 << 4;
static const uint EXCEPTION = 1 << 5;
static const uint WTF = 1 << 6;
static const uint SCREENSHOT = 1 << 7;
static const uint ALL = (INFO | VERBOSE | DEBUGG | WARNING | ERROR | EXCEPTION | WTF | SCREENSHOT);


@interface RLog : NSObject

+(void) n:(id) source Category:(NSString*) category Message:(NSString*)msg;

+(void) v:(id) source Message:(NSString*)msg;
+(void) v:(id) source Category:(NSString*) category Message:(NSString*)msg;

+(void) d:(id) source Message:(NSString*)msg;
+(void) d:(id) source Category:(NSString*) category Message:(NSString*)msg;

+(void) i:(id) source Message:(NSString*)msg;
+(void) i:(id) source Category:(NSString*) category Message:(NSString*)msg;

+(void) w:(id) source Message:(NSString*)msg;
+(void) w:(id) source Category:(NSString*) category Message:(NSString*)msg;

+(void) wtf:(id) source Message:(NSString*)msg;
+(void) wtf:(id) source Category:(NSString*) category Message:(NSString*)msg;

+(void) send:(id) source Category:(NSString*) category Message:(NSString*)msg;
+(void) send:(id) source Category:(NSString*) category Message:(NSString*)msg LogItemBlob:(LogItemBlobRequest*)blobReq;

+(void)takeScreenshot:(id) source Message:(NSString*)msg View:(UIView*)view;

+(void) setMode:(int)mode;

+(int) modeWithString:(NSString*)mode;

@end