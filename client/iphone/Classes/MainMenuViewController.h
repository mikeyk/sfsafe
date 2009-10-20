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
#import "CreditsViewController.h"

@interface MainMenuViewController : UIViewController <LocationCallerDelegate> {
    IBOutlet UIImageView * augmentedButtonOverlay;
    IBOutlet UIButton * goAugmentedButton;
    CreditsViewController * cVC;
}

@property (retain) CreditsViewController * cVC;

- (IBAction) showCredits;
- (IBAction) goCurrentLocationMap;
- (IBAction) goEnterAddress;
- (IBAction) goAugmented;
- (IBAction) goNeighborhoodPicker;
-(void) foundLocationForMap:(CLLocation *) location;
@end


