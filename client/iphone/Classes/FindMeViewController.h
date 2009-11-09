//
//  FindMeViewController.h
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "InfoMapViewController.h"
#import "LocationCallerDelegate.h"
#import "MainMenuViewController.h"
#import "UIViewController+SanFrancisco.h"

@interface FindMeViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    id delegate;
    SEL callback;
    SEL onError;
    BOOL shouldCorrectLocation;
    int locationAttempts;
    BOOL receivedOneGoodLocation;
    IBOutlet UIActivityIndicatorView * progressSpinner;
}

@property (readwrite) BOOL receivedOneGoodLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id <LocationCallerDelegate> delegate;
@property (nonatomic, assign) SEL callback;
@property (nonatomic, assign) SEL onError;
@property (nonatomic, retain)  UIActivityIndicatorView *  progressSpinner;
@property (readwrite) int locationAttempts;
@property (readwrite) BOOL shouldCorrectLocation;


@end
