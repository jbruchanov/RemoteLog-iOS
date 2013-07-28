//
//  Update.h
//  remotelog
//
//  Created by Joe Scurab on 7/28/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Toast,
    Dialog
} NotificationType;

@interface Update : NSObject

@property (nonatomic, strong) NSString *Build;
@property (nonatomic) NotificationType Type;
@property (nonatomic, strong) NSString *Message;

+(Update*) updateFromJson:(NSDictionary*)dict;

@end
