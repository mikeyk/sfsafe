//
//  InfoLocationDataSource.m
//  sfinfo
//
//  Created by Mike Krieger on 10/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ByNeighborhoodDataSource.h"


@implementation ByNeighborhoodDataSource

@synthesize neighborhood;

- (id) init {
    [self setFilters:[[NSMutableDictionary alloc] initWithCapacity:20]];
    [self setLocations:[[NSMutableArray alloc] initWithCapacity:100]];
    [self setHasFailedConnection:[NSNumber numberWithInt:0]];
    return self;
}

- (void) updateResultsForRegion: (MKCoordinateRegion) region_ {
    
    [self setRegion:region_];
    
    if (lastResultList) {
        // we've gotten results once, don't bother to re-fetch,
        // we're only going to fetch for this neighborhood
        [delegate resultsAvailable];
        return;
    } else {
        NSString * appconfigPath = [[NSBundle mainBundle] pathForResource:@"appconfig" ofType:@"plist"];
        NSDictionary * appconfig = [NSDictionary dictionaryWithContentsOfFile:appconfigPath];
        NSString * appUrl = [appconfig objectForKey:@"prod-server"];
        NSString * path = [NSString stringWithFormat:@"/neighborhood?n=%@", 
                           [neighborhood name]];
        NSURL *theURL = [[NSURL alloc] initWithScheme:@"http" 
                                                 host:appUrl
                                                 path:path];
        [self fetchData:theURL];
        [theURL release];
    }
    
     
}
@end
