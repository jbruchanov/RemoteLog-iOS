//
//  Response.h
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface Response : JSONSerializable

@property (nonatomic, strong, readonly) NSString* Type;
@property (nonatomic, strong, readonly) NSString* Message;
@property (nonatomic, strong, readonly) id Context;
@property (nonatomic, readonly) int Count;
@property (nonatomic, readonly) BOOL HasError;

+(Response*) responseFromJson:(NSDictionary*) jsonDict;
@end
