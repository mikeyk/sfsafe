//
//  LocationCallerDelegate.h
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FilterCallerDelegate
@optional
- (void)didSetFilters:(NSDictionary *) filters;
@end
