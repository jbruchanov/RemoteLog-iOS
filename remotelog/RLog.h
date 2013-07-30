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

#define TURN_OFF 0
#define INFO 1 << 0
#define VERBOSE 1 << 1
#define DEBUGG 1 << 2
#define WARNING 1 << 3
#define ERROR 1 << 4
#define EXCEPTION 1 << 5
#define WTF 1 << 6
#define SCREENSHOT 1 << 7
#define ALL INFO | VERBOSE | DEBUGG | WARNING | ERROR | EXCEPTION | WTF | SCREENSHOT

@interface RLog : NSObject

+(void) v:(id) source Message:(NSString*)msg;
+(void) v:(id) source Category:(NSString*) category Message:(NSString*)msg;
+(void) send:(id) source Category:(NSString*) category Message:(NSString*)msg;
//+(void) send:(id) source Category:(NSString*) category Message:(NSString*)msg Data:(NSData*)data;

+(void)takeScreenshot:(id) source Message:(NSString*)msg View:(UIView*)view;

+(void) setMode:(int)mode;

+(int) modeWithString:(NSString*)mode;

@end