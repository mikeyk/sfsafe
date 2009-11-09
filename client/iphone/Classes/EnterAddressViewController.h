//
//  EnterAddressViewController.h
//  sfinfo
//
//  Created by Mike Krieger on 9/12/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationCallerDelegate.h"
#import "NSObject+YAJL.h"
#import "NSObject+StringFromURL.h"
#import "UIViewController+SanFrancisco.h"

@interface EnterAddressViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField * addressField;
    IBOutlet UIView * progressIndicator;
    id delegate;
	NSOperationQueue * queue;
}  

- (IBAction) goHome;

- (void) textFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void) geoLocateAddress:(id) textValue;

@property (retain) NSOperationQueue * queue;

@property (retain) UITextField * addressField;
@property (nonatomic, assign) id <LocationCallerDelegate> delegate;

@end
