//
//  InfoLocationDetailViewController.h
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoLocation.h"
#import "InfoLocationAnnotationView.h"
#import <MapKit/MapKit.h>

@interface InfoLocationDetailViewController : UIViewController<MKMapViewDelegate> {
    UILabel * infoTitle;
    UILabel * infoTime;
    UITextView * infoDescription;    
    InfoLocation * infoLocation;
    MKMapView * detailMapView;
}

@property (nonatomic, retain) IBOutlet UILabel *infoTitle;
@property (nonatomic, retain) IBOutlet UILabel *infoTime;
@property (nonatomic, retain) IBOutlet UITextView  *infoDescription;
@property (nonatomic, retain) InfoLocation *infoLocation;
@property (nonatomic, retain) IBOutlet MKMapView * detailMapView;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil infoLocation:(InfoLocation*) infoLocation_;

@end
