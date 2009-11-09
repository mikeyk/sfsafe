//
//  BaseDataSource.h
//  sfinfo
//
//  Created by Mike Krieger on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoLocationDataSource.h"
#import "InfoLocationDataSourceDelegate.h"
#import "NSObject+StringFromURL.h"
#import "NSObject+YAJL.h"
#import "InfoLocation.h"


@interface BaseDataSource : NSObject<InfoLocationDataSource> {
    id <InfoLocationDataSourceDelegate> delegate;
    NSArray * lastResultList;
    NSMutableArray * locations;    
    NSNumber * hasFailedConnection;
    NSMutableDictionary * filters;
    NSOperationQueue * opQueue;
    MKCoordinateRegion region;    
}

@property (retain) id <InfoLocationDataSourceDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary * filters;
@property (retain) NSArray * lastResultList;
@property (retain) NSMutableArray * locations;
@property (retain) NSOperationQueue * opQueue;
@property (retain) NSNumber * hasFailedConnection;
@property (readwrite) MKCoordinateRegion region;

- (void) fetchData: (NSURL *) url;
- (void) release;

@end
