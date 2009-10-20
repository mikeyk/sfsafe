//
//  MainMenuViewController.m
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import "MainMenuViewController.h"

@implementation MainMenuViewController

@synthesize cVC;


- (IBAction) showCredits
{
    [[[self navigationController] view] setBackgroundColor:[UIColor blackColor]];
     
    [self setCVC:[[CreditsViewController alloc] initWithNibName:@"CreditsViewController" bundle:[NSBundle mainBundle]]];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.superview cache:YES];
    
    UIView *parent = self.view.superview;
    //[self.view removeFromSuperview];
    
    [parent addSubview:[cVC view]];
    [[cVC backHomeButton] addTarget:self action:@selector(hideCredits) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView commitAnimations];
    
}

- (IBAction) hideCredits {

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[[self cVC] view] superview] cache:YES];
    
    UIView *parent = self.view.superview;
    [[cVC view] removeFromSuperview];
    [parent addSubview:[self view]];
    
    [UIView commitAnimations];
    
}



- (IBAction) goNeighborhoodPicker {
    NeighborhoodPickerViewControler * npVC = [[NeighborhoodPickerViewControler alloc] initWithStyle:UITableViewStylePlain];
    [[self navigationController] pushViewController:npVC animated:YES];
    [[self navigationController] setNavigationBarHidden:NO];    
    [npVC release];
}

- (IBAction) goCurrentLocationMap {
    FindMeViewController * fmVC = [[FindMeViewController alloc] initWithNibName:@"FindMeViewController" bundle:[NSBundle mainBundle]];
    [fmVC setDelegate:self];
    [fmVC setCallback:@selector(foundLocationForMap:)];
    [fmVC setOnError:@selector(couldNotFindLocation:)];
    [fmVC setShouldCorrectLocation:YES];
    [self presentModalViewController:fmVC animated:NO];
}

- (IBAction) goAugmented {
    FindMeViewController * fmVC = [[FindMeViewController alloc] initWithNibName:@"FindMeViewController" bundle:[NSBundle mainBundle]];
    [fmVC setDelegate:self];
    [fmVC setCallback:@selector(foundLocationForAR:)];
    [fmVC setOnError:@selector(couldNotFindLocation:)];
    [self presentModalViewController:fmVC animated:NO];
}

- (IBAction) goEnterAddress {
    EnterAddressViewController * eaVC = [[EnterAddressViewController alloc] initWithNibName:@"EnterAddressViewController" bundle:[NSBundle mainBundle]];
    [eaVC setDelegate:self];
    [self presentModalViewController:eaVC animated:NO];
}

-(void) foundLocationForMap:(CLLocation *) location {
    ByCoordinateDataSource * dataSource = [[ByCoordinateDataSource alloc] init];
    InfoMapViewController * sfVC = [[InfoMapViewController alloc] initWithNibName:@"InfoMapViewController" bundle:[NSBundle mainBundle] mapCenter:[location coordinate] dataSource:dataSource];
    [dataSource release];
    [self dismissModalViewControllerAnimated:NO];
    [[self navigationController] pushViewController:sfVC animated:NO];
    [sfVC release];
}

- (void) couldNotFindLocation: (NSString*) message {
    [self dismissModalViewControllerAnimated:NO];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Location Error" message:message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

-(void) foundLocationForAR:(CLLocation *) location {
    ByCoordinateDataSource * dataSource = [[ByCoordinateDataSource alloc] init];
    AugmentedRealityViewController * arVC = [[AugmentedRealityViewController alloc] initWithDataSource:dataSource center:location];
    [self dismissModalViewControllerAnimated:NO];
    [[self navigationController] pushViewController:arVC animated:YES];
    [arVC release];
    [dataSource release];
    
}

-(void) viewDidLoad {
	CLLocationManager * locationManager = [[CLLocationManager alloc] init];
	// check if the hardware has a compass
	if ([locationManager headingAvailable]) {
        [augmentedButtonOverlay removeFromSuperview];
        [goAugmentedButton setEnabled:YES];
    }
    [locationManager release];
}

-(void) viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES];

}

-(void) didCancel {
    [self dismissModalViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

- (void)dealloc {
    [super dealloc];
}


@end
