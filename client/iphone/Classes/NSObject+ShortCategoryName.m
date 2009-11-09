//
//  untitled.m
//  sfinfo
//
//  Created by Mike Krieger on 10/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSObject+ShortCategoryName.h"

@implementation NSObject (NSObject_ShortCategoryName) 


- (NSString *) shortNameForCategory:(NSString *) category {
    NSString * shortName;
    if ([category isEqualToString:@"Drug/narcotic"]) {
        shortName = @"drug";
    } else if ([category isEqualToString:@"Larceny/theft"]) {
        shortName = @"larceny";
    } else if ([category isEqualToString:@"Sex Offenses, Forcible"]) {
        shortName = @"sexoffenses";
    } else if ([category isEqualToString:@"Vehicle Theft"]) {
        shortName = @"vehicle-theft";
    } else {
        shortName = [category lowercaseString];
    }
    return shortName;
}

@end
