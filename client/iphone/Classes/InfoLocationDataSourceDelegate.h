//
//  InfoLocationDataSourceDelegate.h
//  sfinfo
//
//  Created by Mike Krieger on 10/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InfoLocationDataSourceDelegate

- (void) resultsAvailable;

@optional
- (void) networkError;
@end

