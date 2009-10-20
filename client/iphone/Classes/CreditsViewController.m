//
//  CreditsViewController.m
//  sfinfo
//
//  Created by Mike Krieger on 10/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CreditsViewController.h"


@implementation CreditsViewController

@synthesize backHomeButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    [aScrollView setContentSize:CGSizeMake(280, 400)];
}

- (IBAction) goMKrieger {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mkrieger.org"]];
}

- (IBAction) goRPadbury {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://padbury.net"]];
}


@end
