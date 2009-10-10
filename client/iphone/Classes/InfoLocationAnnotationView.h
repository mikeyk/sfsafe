//
//  InfoLocationAnnotationView.h
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "InfoLocation.h"

@interface InfoLocationAnnotationView : MKAnnotationView  {
    InfoLocation * infoLocation;
}

@property (nonatomic, retain) InfoLocation * infoLocation;



@end
