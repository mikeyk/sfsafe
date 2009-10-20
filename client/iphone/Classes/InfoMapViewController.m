//
//  InfoMapViewController.m
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright Mike Krieger 2009. All rights reserved.
//

#import "InfoMapViewController.h"

/* keep in sync with FindMeViewController */
/* TODO move into plist */
#define CITYCENTERLAT 37.77492905
#define CITYCENTERLON -122.41941833

#define DELTADIFFERENCETHRESHOLD 0.005
#define MAPMOVETHRESHOLD 0.0015
#define DEFAULTDELTA 0.005

@implementation InfoMapViewController

@synthesize mapCenter;
@synthesize bottomBar;
@synthesize refreshRateLimiter;
@synthesize mainMapView;
@synthesize dataSource;
@synthesize message;

- (void) showMessage:(NSString *) messageText {
    UIView * message_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [message_ setBackgroundColor:[UIColor colorWithWhite:0.250 alpha:1.000]];
    UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 310, 20)];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [message_ setAlpha:0.75];
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setAdjustsFontSizeToFitWidth:YES];
    [messageLabel setText:messageText];
    [message_ addSubview:messageLabel];
    [self setMessage:message_];
    [[self view] addSubview:message];
    [messageLabel release];
    [message_ release];
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                                                mapCenter:(CLLocationCoordinate2D)center 
                                                dataSource: (id<InfoLocationDataSource>) dataSource_ {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setMapCenter: center];
        [self setDataSource: dataSource_];
        [dataSource setDelegate:self];
        if(fabs(CITYCENTERLAT - center.latitude) < 0.00001 && fabs(CITYCENTERLON - center.longitude) < 0.0001) {
            [self showMessage:@"We placed you in the center of San Francisco"];
        } else if (![dataSource fetchesMoreResults]) {
            [self showMessage:@"Touch Back to see a different neighborhood"];
        }
    }
    return self;
}

- (void) presentTimedMessage {
    
}

-(void) hideMessage {

}


- (void) fetchAndDisplayResultsForCoordinates: (MKCoordinateRegion) region force:(BOOL)force {
    float mapMove = fabs(self.mapCenter.latitude-region.center.latitude);
    
    if ((mapMove > MAPMOVETHRESHOLD) || force) {

        if (![self isInSanFrancisco:region.center]) {
            // TODO handle non-SF
            return;
        }     
        
        [progressIndicator setHidden:NO];
        [dataSource updateResultsForRegion:region];
    }


}

/* makes the force param optional */ 
- (void) fetchAndDisplayResultsForCoordinates:(MKCoordinateRegion)region {
    [self fetchAndDisplayResultsForCoordinates:region force:NO];
}


- (void) resultsAvailable {
    [self refreshDisplay];
    
}

- (void) networkError {
    UIAlertView * connectionAlert =[[UIAlertView alloc] 
                                    initWithTitle:@"Connection Error" 
                                    message:@"We couldn't connect to SFSafe. Please try again later." 
                                    delegate:[self navigationController] 
                                    cancelButtonTitle:@"Dismiss" 
                                    otherButtonTitles:nil];
    [connectionAlert show];
    [connectionAlert release];
    [[self navigationController] popViewControllerAnimated:YES];  
    
}

/* on map move, if we have an active timer, reset it; otherwise,
    start a timer for 1 second from now */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    [message setHidden:YES];
    // don't trigger a refresh on an animated move,
    // because it means the user just tapped on an icon
    if (!animated) {
        if ([self refreshRateLimiter] == nil) {
            [self setRefreshRateLimiter:[NSTimer 
                                            scheduledTimerWithTimeInterval:1.00 
                                            target:self 
                                            selector:@selector(recenterResults) 
                                            userInfo:nil 
                                            repeats:NO]];
        } else {
            [[self refreshRateLimiter] invalidate];
            [self setRefreshRateLimiter:[NSTimer 
                                            scheduledTimerWithTimeInterval:1.00 
                                            target:self 
                                            selector:@selector(recenterResults) 
                                            userInfo:nil 
                                            repeats:NO]];
        }
        
    }

}


- (void) refreshDisplay {
    
    
    MKCoordinateRegion region = [mainMapView region];
    if ([dataSource region].span.latitudeDelta > 0 && 
        [dataSource region].span.longitudeDelta >0) {
        if ([dataSource region].span.latitudeDelta < region.span.latitudeDelta || 
            [dataSource region].span.longitudeDelta < region.span.longitudeDelta){
            
            NSLog(@"delta deltas: %f %f", region.span.latitudeDelta-[[self dataSource] region].span.latitudeDelta, region.span.longitudeDelta-[[self dataSource] region].span.longitudeDelta);
            
            // are we way too zoomed out ?
            if ((region.span.latitudeDelta-[dataSource region].span.latitudeDelta) > DELTADIFFERENCETHRESHOLD ||
                (region.span.longitudeDelta-[dataSource region].span.longitudeDelta) > DELTADIFFERENCETHRESHOLD){
                region.span.latitudeDelta = [dataSource region].span.latitudeDelta;
                region.span.longitudeDelta = [dataSource region].span.longitudeDelta;
                
                [mainMapView setRegion:region animated:YES];  
                
            } 
        }        
    }
    
    [mainMapView removeAnnotations:[mainMapView annotations]];
    NSMutableDictionary * hashedLocations = [NSMutableDictionary dictionaryWithCapacity:100];
    NSArray * lastResultList = [dataSource locations];
    for (InfoLocation * infoloc in lastResultList) {
        InfoLocation * infoLocCopy = [[InfoLocation alloc] initWithInfoLocation:infoloc];
        CLLocationCoordinate2D coord = [infoloc coordinate];
        NSString * hash = [NSString stringWithFormat:@"%.5f-%.5f", coord.latitude, coord.longitude];
        if (![hashedLocations objectForKey:hash]) {
            [hashedLocations setValue:[NSNumber numberWithInt:1] forKey:hash];    
        } else {
            // offset a bit so we don't have a bunch of clustered ones
            int interval = [[infoLocCopy timestamp] timeIntervalSince1970];
            float latoffset = ((interval % 128) / 64.0) - 1;
            float lonoffset = ((interval % 142) / 71.0) - 1;
            coord.latitude += latoffset / 1300.0;
            coord.longitude += lonoffset / 1300.0;
            [infoLocCopy setCoordinate:coord];            
        }
        [mainMapView addAnnotation:infoLocCopy];
        [infoLocCopy release];
        
    }

    [progressIndicator setHidden:YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [mainMapView setMapType:MKMapTypeStandard];
    [mainMapView setShowsUserLocation:YES];
    MKCoordinateRegion region;
    region.center = mapCenter;
    MKCoordinateSpan span;
    
    span.latitudeDelta = DEFAULTDELTA;
    span.longitudeDelta = DEFAULTDELTA;
    region.span = span;
    
    [mainMapView setRegion:region];
    
    [mainMapView setDelegate:self];
    [self fetchAndDisplayResultsForCoordinates:region force:YES];
        
}

- (IBAction) goHome {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction) toggleMapType {
    MKMapType curType = [mainMapView mapType];
    if (curType == MKMapTypeHybrid) {
        [mainMapView setMapType:MKMapTypeStandard];
    } else if (curType == MKMapTypeStandard) {
        [mainMapView setMapType:MKMapTypeHybrid];
    } 
}


- (IBAction) recenterResults {
    [self fetchAndDisplayResultsForCoordinates:[mainMapView region]];
}

- (IBAction) showFilterOptions {
    MapFilterViewController * mfVC = [[MapFilterViewController alloc] 
                                        initWithNibName:@"MapFilterViewController" 
                                        bundle:[NSBundle mainBundle]];
    [mfVC setFilters:[dataSource filters]];
    [mfVC setDelegate:self];
    [self presentModalViewController:mfVC animated:YES];
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    InfoLocationDetailViewController * newView = [[InfoLocationDetailViewController alloc] 
                                                    initWithNibName:@"InfoLocationDetailViewController" 
                                                    bundle:[NSBundle mainBundle] 
                                                    infoLocation:[view annotation]];
    
    [[self navigationController] pushViewController:newView animated:YES];
    [newView release];
}

-(void) didSetFilters:(NSMutableDictionary *)receivedFilters {
    [dataSource filtersReceived:receivedFilters];
    [self dismissModalViewControllerAnimated:YES];
}


// Create the annotations view for use when it appears on the screen
// from http://www.iphonedevsdk.com/forum/iphone-sdk-development/2991-understanding-delegates.html
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    InfoLocationAnnotationView * rv = nil;
    
    if ([annotation isMemberOfClass:[InfoLocation class]]) {
        rv = (InfoLocationAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"InfoLocation"];
        if (rv == nil) {
            rv = [[[InfoLocationAnnotationView alloc] init] autorelease];
        }
        [rv setAnnotation:annotation];
    }
    return rv;
    
}

- (void) shareSFSafeLink {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        [picker setMailComposeDelegate:self];
        [picker setSubject:@"Check out this SF map"];
        NSString * shortUrl = [NSString stringWithFormat:@"sfsafe://location?%f&%f", [[self mainMapView] centerCoordinate].latitude, [[self mainMapView] centerCoordinate].longitude];
        NSString * gmapsLink = [NSString stringWithFormat:@"http://maps.google.com/maps?f=qhl=en&q=%f,%f", [[self mainMapView] centerCoordinate].latitude, [[self mainMapView] centerCoordinate].longitude]; 
        NSString * messageBody = [NSString stringWithFormat:@"Hey,\nI was looking at the safety information for this location in the SFSafe iPhone app and thought you might want to see it.<br/><br/><a href='%@'>Click to see it in SFSafe</a>, or <a href='%@'>get SFSafe free on the App Store</a>. <br/>You can also see just the location in <a href='%@'>Google Maps</a><br/><br/>-Your name", shortUrl, @"http://appstorelink.com", gmapsLink];
        NSLog(@"%@", messageBody);
        [picker setMessageBody:messageBody isHTML:YES];
        [self presentModalViewController:picker animated:YES];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self shareSFSafeLink];         
            break;
        default:
            break;
    }
}




- (IBAction) showShareMenu {
    UIActionSheet * shareMenu = [[UIActionSheet alloc] 
                                    initWithTitle:@"Share this Safety Information" 
                                    delegate:self 
                                    cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil 
                                    otherButtonTitles:@"E-mail SFSafe Link", 
                                    nil];
    [shareMenu showInView:self.view];
    [shareMenu release];
}



- (void)dealloc {

    [dataSource release];
    [mainMapView release];
    [bottomBar release];
    [refreshRateLimiter release];
    [super dealloc];
}

@end
