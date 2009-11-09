//
//  MapFilterViewController.m
//  sfinfo
//
//  Created by Mike Krieger on 8/30/09.
//  Copyright 2009 Mike Krieger. All rights reserved.
//

#import "MapFilterViewController.h"


@implementation MapFilterViewController

@synthesize filters;
@synthesize categoryNames;
@synthesize filterTable;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

        categoryNames = [[NSArray alloc] initWithObjects:@"Assault", @"Burglary", @"Drug/narcotic",  @"Larceny/theft", @"Robbery", @"Sex Offenses, Forcible", @"Vandalism", @"Vehicle Theft", nil];
        filters = [[NSMutableDictionary alloc] init];
        for (NSString * name in categoryNames) {
            [filters setObject:[NSNumber numberWithBool:YES] forKey:name];
            
        }
    }
    return self;
}

-(IBAction) doneEditing {
    [delegate didSetFilters:filters];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn"t have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren"t in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryNames count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    CGRect switchFrame = CGRectMake(220, 7, 200, 20); 
    NSString * category = [categoryNames objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:category];
    
    
    UISwitch * thisSwitch = [[UISwitch alloc] initWithFrame:switchFrame];
    
    NSNumber * thisFilterValue = [filters objectForKey:category];
    if (thisFilterValue != nil) {
        [thisSwitch setOn:[thisFilterValue boolValue]];
    } else {
        [thisSwitch setOn:YES];
    }
    [thisSwitch setTag:[indexPath row]];
    [thisSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    
    [[cell imageView] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [self shortNameForCategory:category]]]];
    
    [[cell textLabel] setFont:[UIFont fontWithName:@"American Typewriter" size:15.0]];


    [cell.contentView addSubview:thisSwitch];
    [thisSwitch release];
    [category release];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
    return cell;
}

- (void)switchAction:(id)sender
{
    NSLog(@"Received switch action");
    BOOL isEnabled;
    if ([sender isOn])
    {
        isEnabled = YES;
    }
    else {
        isEnabled = NO;
    }
    [filters setValue:[NSNumber numberWithBool:isEnabled] forKey:[categoryNames objectAtIndex:[sender tag]]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}



- (void)dealloc {
    [super dealloc];
}


@end

