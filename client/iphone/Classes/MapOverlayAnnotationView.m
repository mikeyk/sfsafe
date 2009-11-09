//
//  MapOverlayAnnotationView.m
//  sfinfo
//
//  Created by Mike Krieger on 10/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapOverlayAnnotationView.h"


@implementation MapOverlayAnnotationView

- (void)setAnnotation:(id <MKAnnotation>)annotation {
    super.annotation = annotation;
    
    [self setImage:[UIImage imageNamed:@"map-overlay.png"]];
    
}

@end
