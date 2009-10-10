//
//  NeighborhoodPickerViewControler.h
//  sfinfo
//
//  Created by Mike Krieger on 10/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoMapViewController.h"
#import "Neighborhood.h"
#import "ByNeighborhoodDataSource.h"

@interface NeighborhoodPickerViewControler : UITableViewController {
    NSMutableArray * neighborhoods;
    NSArray * letters;
}

@property (retain) NSMutableArray * neighborhoods;
@property (retain) NSArray * letters;

@end
