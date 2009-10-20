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

-(id) initWithInfoLocation:(InfoLocation *) original {
    coordinate = [original coordinate];
    [self setDescription:[original description]];
    [self setCategory:[original category]];
    [self setShortName:[original shortName]];
    [self setTimestamp:[original timestamp]];
    return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c info:(NSDictionary*) info{

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
