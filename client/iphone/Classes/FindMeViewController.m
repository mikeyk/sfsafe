//
//  FindMeViewController.m
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import "FindMeViewController.h"

#define CITYCENTERLAT 37.77492905
#define CITYCENTERLON -122.41941833


@implementation FindMeViewController

@synthesize locationManager;
@synthesize delegate;
@synthesize callback;
@synthesize onError;
@synthesize receivedOneGoodLocation;
@synthesize progressSpinner;
@synthesize locationAttempts;
@synthesize shouldCorrectLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setLocationAttempts:[[NSNumber numberWithInt:0] intValue]];
        [self setShouldCorrectLocation:NO];
        [self setReceivedOneGoodLocation:NO];
    }
    return self;
}



- (CLLocationManager *)locationManager {
    
    if (locationManager != nil) {
        return locationManager;
    }
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.delegate = self;
    
    return locationManager;
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        [[self locationManager] stopUpdatingLocation];        
        if (![self receivedOneGoodLocation]) {
            [self setReceivedOneGoodLocation:YES];            
            if (![self shouldCorrectLocation]) {
                [delegate performSelector:onError withObject:@"Please restart the application and allow CrimeDeskSF to see your location to use the augmented reality view."];               
            } else {
                [self setReceivedOneGoodLocation:YES];
                CLLocation * loc = [[CLLocation alloc] initWithLatitude:CITYCENTERLAT longitude:CITYCENTERLON];
                [delegate performSelector:callback withObject:loc];
            }
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    self.locationAttempts++;

    if (self.locationAttempts >= 3 || [newLocation horizontalAccuracy] <= 3000) {
        
        CLLocationCoordinate2D coord = [newLocation coordinate];
        
#if TARGET_IPHONE_SIMULATOR
        coord.latitude = 50.757556;
        coord.longitude = -122.394334;
#endif
        [[self locationManager] stopUpdatingLocation];
        
        if (![self isInSanFrancisco:coord]){
            if ([self shouldCorrectLocation]) {
                coord.latitude = CITYCENTERLAT;
                coord.longitude = CITYCENTERLON;
            } else{
                if (!receivedOneGoodLocation) {                
                    [delegate performSelector:onError withObject:@"It doesn't look like you're in SF, and this feature requires an SF location to work."];
                    [self setReceivedOneGoodLocation:YES];
                    return;
                }
            }
        }
        CLLocation * correctedLocation = [[CLLocation alloc] initWithCoordinate:coord altitude:[newLocation altitude] horizontalAccuracy:[newLocation horizontalAccuracy] verticalAccuracy:[newLocation verticalAccuracy] timestamp:[newLocation timestamp]];
        if (!receivedOneGoodLocation) {
            [delegate performSelector:callback withObject:correctedLocation];
            [correctedLocation release];
            [[self progressSpinner] stopAnimating];
            [self setReceivedOneGoodLocation:YES];            
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self locationManager] startUpdatingLocation];
    [[self progressSpinner] startAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}


@end
