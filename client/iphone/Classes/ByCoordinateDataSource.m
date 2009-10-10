//
//  InfoLocationDataSource.m
//  sfinfo
//
//  Created by Mike Krieger on 10/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ByCoordinateDataSource.h"


@implementation ByCoordinateDataSource

- (id) init {
    [super init];
    return self;
}

- (void) updateResultsForRegion: (MKCoordinateRegion) region_ {
    
    NSString * appconfigPath = [[NSBundle mainBundle] pathForResource:@"appconfig" ofType:@"plist"];
    NSDictionary * appconfig = [NSDictionary dictionaryWithContentsOfFile:appconfigPath];
    NSString * appUrl = [appconfig objectForKey:@"prod-server"];
    int daysToGet = 60;
    NSString * path = [NSString stringWithFormat:@"/nearby?lat=%f&lon=%f&boxheight=%f&boxwidth=%f&days=%d&apiv=1",
                       region_.center.latitude, 
                       region_.center.longitude, 
                       region_.span.latitudeDelta, 
                       region_.span.longitudeDelta, 
                       daysToGet];
    NSURL *theURL = [[NSURL alloc] initWithScheme:@"http" 
                                             host:appUrl
                                             path:path];
    [self fetchData:theURL];
    [theURL release];
    
}
@end
