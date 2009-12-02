//
//  CreditsViewController.h
//  sfinfo
//
//  Created by Mike Krieger on 10/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CreditsViewController : UIViewController {
    IBOutlet UIScrollView * aScrollView;
    IBOutlet UIButton * backHomeButton;
}

-(IBAction) goMKrieger;
-(IBAction) goRPadbury;
-(IBAction) goTwitter;

@property (retain) UIButton * backHomeButton;
@end
