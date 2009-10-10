//
//  InfoLocation.m
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import "InfoLocation.h"


@implementation InfoLocation
@synthesize coordinate;
@synthesize description;
@synthesize category;
@synthesize timestamp;
@synthesize shortName;

- (NSString *)subtitle{
	return self.description;
}
- (NSString *)title{
	return self.category;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c info:(NSDictionary*) info{
    /* Image credits
     
        assault: http://www.flickr.com/photos/szuppo/
        robbery: http://www.flickr.com/photos/nirmalthacker/
        larceny: http://www.flickr.com/photos/amagill/
        vehicle-theft: Wikipedia
        vandalism: http://www.flickr.com/photos/lifeontheedge/
        burglary: 
        
     
     
     */
	coordinate=c;
    [self setDescription:[info valueForKey:@"description"]];
    [self setCategory: [info valueForKey:@"category"]];
    if ([self.category isEqualToString:@"Drug/narcotic"]) {
        [self setShortName:@"drug"];
    } else if ([self.category isEqualToString:@"Larceny/theft"]) {
        [self setShortName:@"larceny"];
    } else if ([self.category isEqualToString:@"Sex Offenses, Forcible"]) {
        [self setShortName:@"sexoffenses"];
    } else if ([self.category isEqualToString:@"Vehicle Theft"]) {
        [self setShortName:@"vehicle-theft"];
    } else {
        [self setShortName:[self.category lowercaseString]];
    }
    [self setTimestamp:[NSDate dateWithTimeIntervalSince1970:[[info valueForKey:@"timestamp"] intValue]]];
	return self;
}

@end
