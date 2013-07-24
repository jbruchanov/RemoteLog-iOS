//
//  ServiceConnector.m
//  remotelog
//
//  Created by Joe Scurab on 7/20/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ServiceConnectorTest.h"
#import "ServiceConnector.h"
#import "Device.h"
#import "Response.h"

@implementation ServiceConnectorTest

-(void) testAttempt{
    Device *d = [Device deviceWithExampleValues];
    NSData *jsonData = [d toJson];
    
    ServiceConnector *sc = [[ServiceConnector alloc] initWithURL:self.serviceURL userName:nil andPassword:nil];
    
//    Response *r = [sc saveDevice:d];
//    STAssertNotNil(r, @"Response should not be nil!");
}
@end
