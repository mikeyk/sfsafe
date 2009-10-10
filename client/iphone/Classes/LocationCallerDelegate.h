//
//  LocationCallerDelegate.h
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationCallerDelegate
@optional
- (void) didFindLocation:(CLLocationCoordinate2D)coord;
- (void) didCancel;

@end
