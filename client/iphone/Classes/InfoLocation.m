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
    [self setShortName:[self shortNameForCategory:self.category]];
    [self setTimestamp:[NSDate dateWithTimeIntervalSince1970:[[info valueForKey:@"timestamp"] intValue]]];
	return self;
}

- (void) dealloc {
    [super dealloc];
    [category release];
    [shortName release];
    [timestamp release];
    [description release];
}

@end
