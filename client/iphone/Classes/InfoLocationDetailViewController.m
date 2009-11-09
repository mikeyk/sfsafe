//
//  InfoLocationDetailViewController.m
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import "InfoLocationDetailViewController.h"

#define DEFAULTSPAN 0.0001

@implementation InfoLocationDetailViewController

@synthesize infoTitle;
@synthesize infoTime;
@synthesize infoLocation;
@synthesize infoDescription;
@synthesize detailMapView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil infoLocation:(InfoLocation*) infoLocation_{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setInfoLocation:infoLocation_];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [[self navigationController] setNavigationBarHidden:NO];

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = DEFAULTSPAN;
    span.longitudeDelta = DEFAULTSPAN;
    region.span = span;
    region.center = infoLocation.coordinate;
    [detailMapView setRegion:region];
    [detailMapView regionThatFits:region];
    [detailMapView setMapType:MKMapTypeHybrid];
    
    [detailMapView addAnnotation:infoLocation];
    [detailMapView setUserInteractionEnabled:NO];
    [detailMapView setDelegate:self];
     
    [[self infoTitle] setText: infoLocation.category];
    [[self infoDescription] setText: infoLocation.description];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSString * time = [dateFormatter stringFromDate:infoLocation.timestamp];
    [dateFormatter release];
    
    [[self infoTime] setText:time ];
    
}

// Create the annotations view for use when it appears on the screen
// from http://www.iphonedevsdk.com/forum/iphone-sdk-development/2991-understanding-delegates.html
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView * rv = nil;
    
    if ([annotation isMemberOfClass:[InfoLocation class]]) {
        rv = (InfoLocationAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"InfoLocation"];
        if (rv == nil) {
            rv = [[[InfoLocationAnnotationView alloc] init] autorelease];
        }
        [rv setAnnotation:annotation];
    }
    return rv;
    
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
