//
//  InfoMapViewController.h
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright Mike Krieger 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import "InfoLocationDetailViewController.h"
#import "InfoLocation.h"
#import "InfoLocationAnnotationView.h"
#import "MapFilterViewController.h"
#import "FilterCallerDelegate.h"
#import "AugmentedRealityViewController.h"
#import "InfoLocationDataSource.h"
#import "InfoLocationDataSourceDelegate.h"
#import "ByCoordinateDataSource.h"
#import "UIViewController+SanFrancisco.h"

@interface InfoMapViewController : UIViewController <MKMapViewDelegate, FilterCallerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, InfoLocationDataSourceDelegate> {
    IBOutlet MKMapView * mainMapView;
    CLLocationCoordinate2D mapCenter;
    IBOutlet UIView * progressIndicator;
    IBOutlet UIToolbar * bottomBar;
    NSTimer * refreshRateLimiter;
    UIView * message;
    id <InfoLocationDataSource> dataSource;
}
@property (nonatomic, readwrite) CLLocationCoordinate2D mapCenter;
@property (retain) NSTimer * refreshRateLimiter;
@property (retain) UIToolbar * bottomBar;
@property (retain) id <InfoLocationDataSource> dataSource;
@property (retain) MKMapView * mainMapView;
@property (retain) UIView * message;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mapCenter:(CLLocationCoordinate2D)center dataSource:(id<InfoLocationDataSource>) dataSource;

- (IBAction) goHome;
- (IBAction) recenterResults;
- (IBAction) showFilterOptions;
- (IBAction) toggleMapType;
- (IBAction) showShareMenu;
- (void) didSetFilters:(NSDictionary *)filters;
- (void) refreshDisplay;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

