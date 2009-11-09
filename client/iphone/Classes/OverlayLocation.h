//
//  OverlayLocation.h
//  sfinfo
//
//  Created by Mike Krieger on 10/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface OverlayLocation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end
