//
//  sfinfoAppDelegate.m
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright Mike Krieger 2009. All rights reserved.
//
#include <SystemConfiguration/SCNetworkReachability.h>
#import "sfinfoAppDelegate.h"

@implementation sfinfoAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    


    // MxWeas' quick reachability sample
    
    SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(kCFAllocatorSystemDefault, "google.com"); // Attempt to ping google.com
    SCNetworkConnectionFlags flags;
    SCNetworkReachabilityGetFlags(reach, &flags); // Store reachability flags in the variable, flags.
    
    if(!(kSCNetworkReachabilityFlagsReachable & flags)) {
        UIAlertView * connectionAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"This app requires an Internet connection, but we couldn't detect one. Please turn off Airplane Mode or connect to a valid network."  delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [connectionAlert show];
        [connectionAlert release];
    }
    // the Navigation bar has previously been created in IB
    [window addSubview:[navigationController view]];
    [[navigationController navigationBar] setTintColor:[UIColor grayColor]];
    [navigationController setTitle:@"Crime Desk SF"];
    [window makeKeyAndVisible];

}

/* This lets us handle URLs from external applications.
    If there is a location in the query string and
    it resolves to San Francisco, we open up a 
    map view; else, we just return YES and the
    user will be on the home screen
*/
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // example url: crimedesksf://location?37.7&-122
    NSArray * params = [[url query] componentsSeparatedByString:@"&"];
    

    if ([params count] == 2){
        CLLocationCoordinate2D coord;
        coord.latitude = [(NSString*)[params objectAtIndex:0] floatValue];
        coord.longitude = [(NSString*)[params objectAtIndex:1] floatValue];
        
        ByCoordinateDataSource * dataSource = [[ByCoordinateDataSource alloc] init];
        InfoMapViewController * imVC = [[InfoMapViewController alloc] initWithNibName:@"InfoMapViewController" bundle:[NSBundle mainBundle] mapCenter:coord dataSource: dataSource];
        [dataSource release];
        if ([imVC isInSanFrancisco:coord]) {
            [[self navigationController] pushViewController:imVC animated:YES];
        }
        [imVC release];
        
    }
    return YES;
}


- (void)dealloc {
    [navigationController release];
    [window release];
    [super dealloc];
}


@end
