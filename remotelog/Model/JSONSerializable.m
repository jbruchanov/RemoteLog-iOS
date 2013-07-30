//
//  JSONSerializable.m
//  remotelog
//
//  Created by Joe Scurab on 7/25/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "JSONSerializable.h"
#import <objc/runtime.h>

@implementation JSONSerializable

-(NSData*) toJson{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        
        if(![self isFieldSerializable:name]){
            continue;
        }
        id value = [((id)self) valueForKey:name];
        
#ifdef DEBUG
        NSLog(@"%@:%@", name, value);
#endif
        if(value){
            [dict setObject:value forKey:name];
        }
    }
    free(propertyArray);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
#ifdef DEBUG
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
#endif
    return jsonData;
}

-(NSString*) toJsonString{
    return [[NSString alloc]initWithData:[self toJson] encoding:NSUTF8StringEncoding];
}

-(BOOL) isFieldSerializable:(NSString*) fieldName{
    return YES;
}

@end
