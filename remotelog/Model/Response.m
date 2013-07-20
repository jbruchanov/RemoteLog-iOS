//
//  Response.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "Response.h"

@interface Response()

@property (nonatomic, strong, readwrite) NSString* Type;
@property (nonatomic, strong, readwrite) NSString* Message;
@property (nonatomic, strong, readwrite) id Context;
@property (nonatomic, readwrite) int Count;

@end

@implementation Response

@end
