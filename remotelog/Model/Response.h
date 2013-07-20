//
//  Response.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property (nonatomic, strong, readonly) NSString* Type;
@property (nonatomic, strong, readonly) NSString* Message;
@property (nonatomic, strong, readonly) id Context;
@property (nonatomic, readonly) int Count;
@end
