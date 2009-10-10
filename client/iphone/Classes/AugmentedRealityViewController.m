//
//  cameraprototypeViewController.m
//  cameraprototype
//
//  Created by Mike Krieger on 8/31/09.
//  Copyright Mike Krieger 2009. All rights reserved.
//

#import "AugmentedRealityViewController.h"
#import "ARGeoCoordinate.h"
#import "math.h"
#include <stdlib.h>

@implementation AugmentedRealityViewController
@synthesize dataSource;
@synthesize coordinates;


- (id)initWithDataSource:(id<InfoLocationDataSource>) dataSource_ center: (CLLocation *) center {    
    if (self = [super init]) {
        [self setDelegate:self];
        [self setCenterLocation:center];
        
        MKCoordinateRegion region;
        region.center = [center coordinate];
        region.span.latitudeDelta = (0.1 / 69);
        region.span.longitudeDelta = (0.1 / 69);
        [self setDataSource:dataSource_];
        [dataSource setDelegate:self];
        [dataSource updateResultsForRegion:region];
        [self setStatus:@"Loading..."];
        NSMutableArray * newArr = [[NSMutableArray alloc] initWithCapacity:25];
        [self setCoordinates:newArr];
        [newArr release];
    }
    return self;
    
}

#define MAX_DISTANCE 100
- (void) resultsAvailable {
    if ([[self.dataSource locations] count] == 0) {
       [self setStatus:@"No results in your area."];
    }
    else{
        [[self statusIndicator] setHidden:YES];
        for(NSObject * obj in [self.dataSource locations] ){
            InfoLocation * infoloc = (InfoLocation *) obj;
            
            CLLocation *tempLocation;
            ARGeoCoordinate *tempCoordinate;
            
            
            tempLocation = [[CLLocation alloc] initWithCoordinate:infoloc.coordinate altitude:0 horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:[NSDate date]];
            
            CLLocationDistance distance = [centerLocation getDistanceFrom:tempLocation];
            if (distance < MAX_DISTANCE) {
                tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation fromOrigin:centerLocation ];
                tempCoordinate.title = [infoloc description];
                
                [coordinates addObject:tempCoordinate];           
            }
            [tempLocation release]; 
        }
        
        [self addCoordinates:coordinates]; 
    }  
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self startListening];    
}



- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}


#define BOX_WIDTH 200
#define BOX_HEIGHT BOX_WIDTH / 4


- (UIView *)viewForCoordinate:(ARCoordinate *)coordinate {
        
    NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"ARCoordinateView" owner:self options:nil];
    ARCoordinateView * myView = [ nibViews objectAtIndex: 0];
    [[myView title] setText:[coordinate title]];
    [[myView distance] setText:[NSString stringWithFormat:@"%.2f meters away", [coordinate radialDistance]]];
    
    [myView sizeToFit];
    return myView;

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
*/

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
