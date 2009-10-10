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
@synthesize progressSpinner;
@synthesize locationAttempts;
@synthesize shouldCorrectLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setLocationAttempts:[[NSNumber numberWithInt:0] intValue]];
        [self setShouldCorrectLocation:NO];
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

        if (![self isInSanFrancisco:coord]){
            if ([self shouldCorrectLocation]) {
                coord.latitude = CITYCENTERLAT;
                coord.longitude = CITYCENTERLON;
            } else{
                [delegate performSelector:onError withObject:@"It doesn't look like you're in SF, and this features requires an SF location to work."];
                return;
            }
        } 
        CLLocation * correctedLocation = [[CLLocation alloc] initWithCoordinate:coord altitude:[newLocation altitude] horizontalAccuracy:[newLocation horizontalAccuracy] verticalAccuracy:[newLocation verticalAccuracy] timestamp:[newLocation timestamp]];
        
        [[self locationManager] stopUpdatingLocation];
        [delegate performSelector:callback withObject:correctedLocation];
        [correctedLocation release];
        [[self progressSpinner] stopAnimating];
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
