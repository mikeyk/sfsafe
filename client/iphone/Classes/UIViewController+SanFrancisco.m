//
//  UIViewController+SanFrancisco.m
//  sfinfo
//
//  Created by Mike Krieger on 9/14/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import "UIViewController+SanFrancisco.h"

#define LEFTBOUND 37.644549
#define RIGHTBOUND 37.826057
#define TOPBOUND -122.336712
#define BOTTOMBOUND -122.574635

@implementation UIViewController (UIViewController_SanFrancisco) 

- (BOOL) isInSanFrancisco:(CLLocationCoordinate2D) coord {
    
    if (coord.latitude < LEFTBOUND || coord.latitude >  RIGHTBOUND ||
        coord.longitude > TOPBOUND || coord.longitude < BOTTOMBOUND){
        return NO;
    } else {
        return YES;
    }

}

@end
