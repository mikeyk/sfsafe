//
//  cameraprototypeViewController.h
//  cameraprototype
//
//  Created by Mike Krieger on 8/31/09.
//  Copyright Mike Krieger 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ARGeoViewController.h"
#import "ARCoordinateView.h"
#import "InfoLocation.h"
#import "InfoLocationDataSource.h"
#import "InfoLocationDataSourceDelegate.h"

@interface AugmentedRealityViewController : ARGeoViewController <InfoLocationDataSourceDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ARViewDelegate> {
    NSMutableArray * coordinates;
    id<InfoLocationDataSource> dataSource;
}

@property (retain) id<InfoLocationDataSource> dataSource;
@property (retain) NSMutableArray * coordinates;

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
- (id)initWithDataSource:(id<InfoLocationDataSource>) dataSource_ center: (CLLocation *) center;
- (void)startRealityView;

@end

