//
//  UIViewController+SBJSON.m
//  sfinfo
//
//  Created by Mike Krieger on 9/12/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import "NSObject+NetworkJSON.h"

@implementation NSObject (NSObject_NetworkJSON)

- (NSString *)stringWithUrl:(NSURL *)url
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
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

- (id) objectWithUrl:(NSURL *)url
{
	SBJSON *jsonParser = [SBJSON new];
	NSString *jsonString = [self stringWithUrl:url];
    
    if (jsonString == @"connection error") {
        [jsonParser release];
        return nil;
    } else {
        // Parse the JSON into an Object
        NSObject * result = [jsonParser objectWithString:jsonString error:NULL];
        [jsonParser release];
        return result;
        
    }
}


@end
