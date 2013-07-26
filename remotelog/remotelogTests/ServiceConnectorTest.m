//
//  ServiceConnectorTest.m
//  remotelog
//
//  Created by Jiří Bruchanov on 26/07/2013.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ServiceConnectorTest.h"
#import "ServiceConnector.h"

@implementation ServiceConnectorTest


-(void) testSaveDevice{
    ServiceConnector *sc = [[ServiceConnector alloc]initWithURL:self.serverUrl userName:nil andPassword:nil];
    Device *d = [Device deviceWithExampleValues];
    //works fine, id 7007, 7063
//    [sc saveDevice:d];
}

-(void) testSaveLogItem{
    
}
@end
