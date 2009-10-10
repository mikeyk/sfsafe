//
//  InfoLocationAnnotationView.m
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import "InfoLocationAnnotationView.h"


@implementation InfoLocationAnnotationView
@synthesize infoLocation;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation 
         reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithAnnotation:annotation 
                        reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];        
        [self setCanShowCallout:YES];
    }
    return self;
}


- (void)setAnnotation:(id <MKAnnotation>)annotation {
    super.annotation = annotation;
    if([annotation isMemberOfClass:[InfoLocation class]]) {
        
        InfoLocation * infoLoc = (InfoLocation *)annotation;
        [self setInfoLocation:infoLoc];
        NSString * imageFileName = [NSString stringWithFormat:@"%@.png", [infoLoc shortName]];
        UIImage * imageForCategory = [UIImage imageNamed:imageFileName];
        if (imageForCategory) {
            [self setImage:imageForCategory];
        } else {
            NSLog(@"MISSING IMAGE: %@", imageFileName);
        }
        
        UIButton *myDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        myDetailButton.frame = CGRectMake(0, 0, 23, 23);
        myDetailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        myDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        // Set the image for the button
        //[myDetailButton setImage:[UIImage imageNamed:@"Camera.png"] forState:UIControlStateNormal];
        
        // Set the button as the callout view
        self.rightCalloutAccessoryView = myDetailButton;
        [self setCanShowCallout:YES];
        
        [self setAlpha:1.0];
        
        /*[self setBackgroundColor:[UIColor clearColor]];
        self.frame = CGRectMake(0, 0, 40, 40);*/
    } else {
        self.frame = CGRectMake(0,0,0,0);
    }
    
}
/*
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.1);
    CGContextFillEllipseInRect(context, rect);
}
*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        [self setAlpha:1.0];
        [[self superview] bringSubviewToFront:self];

    } else {
        [self setAlpha:1.0];
    }
    
}

/*
static NSString *defaultPinID = @"InfoLocation";
MKPinAnnotationView *retval = nil;

// Make sure we only create Pins for the Cameras. Ignore the current location annotation 
// so it returns the 'blue dot'
if ([annotation isMemberOfClass:[InfoLocation class]]) {
    // See if we can reduce, reuse, recycle
    retval = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    
    // If we have to, create a new view
    if (retval == nil) {
        retval = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        
        // Set up the Left callout
        UIButton *myDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        myDetailButton.frame = CGRectMake(0, 0, 23, 23);
        myDetailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        myDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        // Set the image for the button
        //[myDetailButton setImage:[UIImage imageNamed:@"Camera.png"] forState:UIControlStateNormal];
        
        // Set the button as the callout view
        retval.leftCalloutAccessoryView = myDetailButton;
    }
    
    // Set a bunch of other stuff
    if (retval) {
        //[retval setPinColor:MKPinAnnotationColorGreen];
        retval.canShowCallout = YES;
    }
}

return retval;
*/



- (void)dealloc {
    [super dealloc];
}


@end
