//
//  InfoLocationDataSource.h
//  sfinfo
//
//  Created by Mike Krieger on 10/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoLocationDataSourceDelegate.h"
#import "InfoLocationDataSource.h"
#import "NSObject+NetworkJSON.h"
#import "InfoLocation.h"
#import "BaseDataSource.h"

@interface ByCoordinateDataSource : BaseDataSource <InfoLocationDataSource> {

}


@end
