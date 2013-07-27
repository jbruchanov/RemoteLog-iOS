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

-(NSString*) toJsonString;

-(BOOL) isFieldSerializable:(NSString*) fieldName;

@end
