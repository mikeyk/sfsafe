//
//  NSObject+StringFromURL.m
//  sfinfo
//
//  Created by Mike Krieger on 10/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSObject+StringFromURL.h"


@implementation NSObject (NSObject_StringFromURL)

- (NSString *)stringFromURL:(NSURL *)url
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
    
	// Make synchronous request
    
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    if (error) {
        return @"connection error";
    } else {
        // Construct a String around the Data from the response
        return [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
    }
    
    
}


@end
