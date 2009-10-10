//
//  MainMenuViewController.h
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindMeViewController.h"
#import "NeighborhoodPickerViewControler.h"
#import "ByCoordinateDataSource.h"
#import "ByNeighborhoodDataSource.h"
#import "EnterAddressViewController.h"

@interface MainMenuViewController : UIViewController <LocationCallerDelegate> {
    IBOutlet UIBarButtonItem * augmentedButton;
}

- (IBAction) goCurrentLocationMap;
- (IBAction) goEnterAddress;
- (IBAction) goNeighborhoodPicker;
-(void) foundLocationForMap:(CLLocation *) location;
@end


