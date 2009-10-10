//
//  sfinfoAppDelegate.h
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright Mike Krieger 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InfoMapViewController.h"
#import "ByCoordinateDataSource.h"

@interface sfinfoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController * navigationController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

