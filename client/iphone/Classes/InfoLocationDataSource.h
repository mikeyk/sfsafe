//
//  InfoLocationDataSourceProtocol
//  sfinfo
//
//  Created by Mike Krieger on 10/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@protocol InfoLocationDataSource

- (NSArray *) locations;
- (void) updateResultsForRegion: (MKCoordinateRegion) region;
- (MKCoordinateRegion) region;
- (void) filtersReceived: (NSMutableDictionary *) filters;
- (NSMutableDictionary *) filters;
- (void) setDelegate: (id) delegate;
- (void) release;
- (BOOL) fetchesMoreResults;

@end
