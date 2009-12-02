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
    IBOutlet UILabel * usesCameraLabel;
    IBOutlet UIButton * goAugmentedButton;
    CreditsViewController * cVC;
    IBOutlet UIImageView * backgroundImage;
}

@property (retain) CreditsViewController * cVC;
@property (retain)  UIImageView * backgroundImage;
- (IBAction) showCredits;
- (IBAction) goCurrentLocationMap;
- (IBAction) goEnterAddress;
- (IBAction) goAugmented;
- (IBAction) goNeighborhoodPicker;
-(void) foundLocationForMap:(CLLocation *) location;
@end


