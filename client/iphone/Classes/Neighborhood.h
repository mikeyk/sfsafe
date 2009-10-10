//
//  Neighborhood.h
//  sfinfo
//
//  Created by Mike Krieger on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Neighborhood : NSObject {
    NSString * name;
    CLLocationCoordinate2D coord;
}

@property (retain) NSString * name;
@property (readwrite) CLLocationCoordinate2D coord;

@end
