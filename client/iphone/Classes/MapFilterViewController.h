//
//  MapFilterViewController.h
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCallerDelegate.h"
#import "NSObject+ShortCategoryName.h"

@interface MapFilterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView * filterTable; 
    NSMutableDictionary * filters;
    NSArray * categoryNames;
    id delegate;
}

@property (nonatomic, retain) NSMutableDictionary * filters;
@property (nonatomic, retain) NSArray * categoryNames;
@property (nonatomic, retain) UITableView * filterTable;
@property (nonatomic, assign) id <FilterCallerDelegate> delegate;

-(IBAction) doneEditing;

@end
