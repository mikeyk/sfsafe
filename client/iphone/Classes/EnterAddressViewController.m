//
//  EnterAddressViewController.m
//  sfinfo
//
//  Created by Mike Krieger on 9/12/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import "EnterAddressViewController.h"


@implementation EnterAddressViewController

@synthesize addressField;
@synthesize delegate;
@synthesize queue;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setQueue:[[NSOperationQueue alloc] init]];
    }
    return self;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.25];
    CGRect rect = [self.view frame];
    rect.origin.y -= 100;
    [self.view setFrame:rect];
    [UIView commitAnimations];
}

- (CLLocation *) tryToFindSFAddress: (NSDictionary *) response {
    if ([response objectForKey:@"Placemark"]) {
        // get the first placemark
        NSArray * placemarks = [response objectForKey:@"Placemark"];
        if ([placemarks count] > 0) {
            for (int i = 0; i < [placemarks count]; i++) {
                NSDictionary * curPlacemark = [placemarks objectAtIndex:i];
                if ([curPlacemark objectForKey:@"Point"]) {
                    NSDictionary * point = [curPlacemark objectForKey:@"Point"];
                    if ([point objectForKey:@"coordinates"]){
                        NSArray * coordinates = [point objectForKey:@"coordinates"];
                        
                        CLLocationCoordinate2D coord;
                        coord.latitude = [[coordinates objectAtIndex:1] floatValue];
                        coord.longitude = [[coordinates objectAtIndex:0] floatValue];
                        
                        if (![self isInSanFrancisco:coord]) {
                            /*
                             NSString * notInSFError = @"It doesn't look like that location is in San Francisco. Please try a different location.";
                             UIAlertView * notInSF = [[UIAlertView alloc] 
                             initWithTitle:@"Location Error" 
                             message:notInSFError  
                             delegate:self
                             cancelButtonTitle:@"Dismiss" 
                             otherButtonTitles:nil ];
                             [notInSF show];
                             [notInSF release];
                             */
                            
                        } else {
                            CLLocation * loc = [[CLLocation alloc] initWithCoordinate:coord altitude:0.0 horizontalAccuracy:0.1 verticalAccuracy:0.1 timestamp:[NSDate date]];
                            return loc;
                        }
                    }
                }
            }
        }        
    }
    return nil;
}

- (NSDictionary *) lookUpWithAddress: (NSString*) address {

    NSString * appconfigPath = [[NSBundle mainBundle] pathForResource:@"appconfig" ofType:@"plist"];
    NSDictionary * appconfig = [NSDictionary dictionaryWithContentsOfFile:appconfigPath];
    
    NSString * mapsAPIKey = [appconfig objectForKey:@"maps-apikey"];
    
    NSString * biasOptions = @"ll=37.7756,-122.418594&spn=0.352778,0.622101";
    
    NSString * urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps/geo?q=%@&key=%@&%@", address,
                            mapsAPIKey, biasOptions];
    
    [biasOptions release];
    
    
    NSURL * localhost = [[NSURL alloc] initWithString:urlString];
    [urlString release];
    
    NSDictionary * response = (NSDictionary*)[self objectWithUrl:localhost];
    [response retain];
    return response;
    
}

- (void) geoLocateAddress:(id) textValueObj {
    NSString * address = (NSString*) textValueObj;
    
    [progressIndicator setHidden:YES];
    NSString * escapedAddress = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * response = [self lookUpWithAddress:escapedAddress];
    if (response == nil) {
        UIAlertView * connectionAlert = [[UIAlertView alloc] 
                                            initWithTitle:@"Location Error" 
                                            message:@"SFSafe could not connect to the location service. Please try again later."  
                                            delegate:self 
                                            cancelButtonTitle:@"Dismiss" 
                                            otherButtonTitles:nil ];
        [connectionAlert show];
        [connectionAlert release];
    }
    else {
        CLLocation * loc = [self tryToFindSFAddress:response];
        if (loc) {
            [self performSelectorOnMainThread:@selector(notifyDelegateOfCoordinates:) 
                                   withObject:loc
                                waitUntilDone:YES];
            [loc release];
            
        } else {
            NSString * addressWithSanFranciscoAppended = [address stringByAppendingString:@" San Francisco"];
            escapedAddress = [addressWithSanFranciscoAppended stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            response = [self lookUpWithAddress:escapedAddress];
            if (response) {
                loc = [self tryToFindSFAddress:response];
                if (loc != nil) {
                    [self performSelectorOnMainThread:@selector(notifyDelegateOfCoordinates:) 
                                           withObject:loc
                                        waitUntilDone:YES];
                    [loc release];                    
                    
                } else {
                    UIAlertView * connectionAlert = [[UIAlertView alloc] 
                                                     initWithTitle:@"Location Error" 
                                                     message:@"SFSafe could not find this location. Please try a different location."  
                                                     delegate:self 
                                                     cancelButtonTitle:@"Dismiss" 
                                                     otherButtonTitles:nil ];
                    [connectionAlert show];
                    [connectionAlert release]; 
                }
            }
            
        }
        
    }
    
    [response release];
    
    
}

- (IBAction) goHome {
    [self.delegate didCancel];
}

- (void) notifyDelegateOfCoordinates:(CLLocation*) location {
    [self.delegate foundLocationForMap:location];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInvocationOperation *operation = 	[[NSInvocationOperation alloc] initWithTarget:self 
                                                                             selector:@selector(geoLocateAddress:) 
                                                                               object:[textField text]]; 
	
    [progressIndicator setHidden:NO];

	[queue addOperation:operation]; 
    [operation release];
    return NO;
/*    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.25];
    CGRect rect = [self.view frame];
    rect.origin.y += 100;
    [self.view setFrame:rect];
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    return YES;
 */
}

- (void)dealloc {
    [super dealloc];
    [addressField release];
}


@end
