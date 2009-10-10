//
//  UIViewController+SanFrancisco.h
//  sfinfo
//
//  Created by Mike Krieger on 9/14/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface UIViewController (UIViewController_SanFrancisco) 

- (BOOL) isInSanFrancisco:(CLLocationCoordinate2D) coord;


@end
