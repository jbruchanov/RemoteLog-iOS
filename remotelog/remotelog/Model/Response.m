//
//  Response.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "Response.h"

@interface Response()

@property (nonatomic, readwrite) int Count;
@property (nonatomic, readwrite) BOOL HasError;
@property (nonatomic, strong, readwrite) NSString* Type;
@property (nonatomic, strong, readwrite) NSString* Message;
@property (nonatomic, strong, readwrite) id Context;

@end

@implementation Response

+(Response*) responseFromJson:(NSDictionary*) jsonDict{
    Response *r = [[Response alloc]init];

    r.Type = [jsonDict objectForKey:@"Type"];
    r.HasError = [[jsonDict objectForKey:@"HasError"] boolValue];
    r.Message = [jsonDict objectForKey:@"Message"];
    r.Context = [jsonDict objectForKey:@"Context"];
    r.Count = [[jsonDict objectForKey:@"Count"] intValue];
    return r;

}
@end
