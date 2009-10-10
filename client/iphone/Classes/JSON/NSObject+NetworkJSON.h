
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSON.h"

@interface NSObject (NSObject_NetworkJSON)


- (NSString *)stringWithUrl:(NSURL *)url;
- (NSString *)objectWithUrl:(NSURL *)url;

@end
