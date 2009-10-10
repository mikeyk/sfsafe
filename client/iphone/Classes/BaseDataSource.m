//
//  BaseDataSource.m
//  sfinfo
//
//  Created by Mike Krieger on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseDataSource.h"


@implementation BaseDataSource

@synthesize filters;
@synthesize lastResultList;
@synthesize delegate;
@synthesize region;
@synthesize locations;
@synthesize hasFailedConnection;

- (id) init {
    [self setFilters:[[NSMutableDictionary alloc] initWithCapacity:20]];
    [self setLocations:[[NSMutableArray alloc] initWithCapacity:100]];
    [self setHasFailedConnection:[NSNumber numberWithInt:0]];
    return self;
}

- (void) doRequest: (NSURL *) url {
    NSDictionary * response = (NSDictionary*)[self objectWithUrl:url];
    
    if (response == nil) {
        if (![self.hasFailedConnection boolValue]){
            [self setHasFailedConnection:[NSNumber numberWithInt:1]];
            [delegate networkError];
        }
    } else {
        if([response valueForKey:@"num_results"] == 0){
            // TODO handle no results
        }
        else if([response valueForKey:@"latitude_delta"] && [response valueForKey:@"longitude_delta"] 
                && [response objectForKey:@"result_set"]) {
            lastResultList = [[NSArray alloc] initWithArray:[response objectForKey:@"result_set"]];
            MKCoordinateRegion region_ = region;
            region_.span.latitudeDelta = [[response valueForKey:@"latitude_delta"] floatValue];
            region_.span.longitudeDelta = [[response valueForKey:@"longitude_delta"] floatValue];
            [self setRegion:region_];
            [self performSelectorOnMainThread:@selector(receivedResults) withObject:nil waitUntilDone:NO];
            
        } else {
            if ([self.hasFailedConnection boolValue] == NO){
                [delegate networkError];
            }
        }
        
    }    
}

- (void) fetchData: (NSURL *) url {
    
    NSInvocationOperation * io = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doRequest:) object:url];
    NSOperationQueue * opQueue = [[NSOperationQueue alloc] init];
    [opQueue setMaxConcurrentOperationCount:1];
    [opQueue addOperation:io];
    [io release];
    [opQueue release];
}

- (void) receivedResults {
    [locations removeAllObjects];
    for (NSDictionary * cur in lastResultList) {
        NSString * category =  [cur valueForKey:@"category"];
        BOOL meetsFilter = YES;
        if ([filters objectForKey:category]!=nil) {
            meetsFilter = [[filters objectForKey:category] boolValue];
        }
        if (meetsFilter) {
            float lat = [[cur valueForKey:@"lat"] floatValue];            
            float lon = [[cur valueForKey:@"lon"] floatValue];
            CLLocationCoordinate2D coord;
            coord.latitude = lat;
            coord.longitude = lon;
            InfoLocation * newInfoLoc = [[InfoLocation alloc] initWithCoordinate:coord info:cur];
            [locations addObject:newInfoLoc];
            [newInfoLoc release];
        }
    }
    [delegate resultsAvailable];
}


- (void) filtersReceived: (NSMutableDictionary *)receivedFilters {
    [self setFilters:receivedFilters];
    [self receivedResults];
}

/* 
    BaseDataSource implements a stub function,
    subclasses should override to do custom URL
    construction for passing into fetchData
*/
    
- (void) updateResultsForRegion: (MKCoordinateRegion) region_ {
    
}

- (void) release {
    [super release];
}


@end
