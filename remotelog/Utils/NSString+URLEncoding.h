//
//  NSString+URLEncoding.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/6/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (URLEncoding)

/*
 Encode NSString to get valid URL string
 */
-(NSString *)urlEncode;

-(NSString *) base64Encoded;
@end
