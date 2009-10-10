//
//  InfoLocation.h
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface InfoLocation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString * description;
    NSString * category;
    NSDate * timestamp;
    NSString * shortName;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * shortName;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate info:(NSDictionary *) info;

- (NSString *)subtitle;
- (NSString *)title;

@end
