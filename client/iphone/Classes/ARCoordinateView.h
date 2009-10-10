//
//  ARCoordinateView.h
//  sfinfo
//
//  Created by Mike Krieger on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ARCoordinateView : UIView {
    IBOutlet UILabel * title;
    IBOutlet UILabel * distance;
}

@property (retain) UILabel * title;
@property (retain) UILabel * distance;

@end
