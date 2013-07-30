//
//  JSONSerializable.h
//  remotelog
//
//  Created by Joe Scurab on 7/25/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONSerializable : NSObject

/* Convert object into json dictionary string then into NSData */
-(NSData*) toJson;

/* Covnert object into json NSString value */
-(NSString*) toJsonString;

/* Override this method if you want to skip some field for JSON serialization */
-(BOOL) isFieldSerializable:(NSString*) fieldName;

@end
