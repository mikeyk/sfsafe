//
//  NeighborhoodPickerViewControler.m
//  sfinfo
//
//  Created by Mike Krieger on 10/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NeighborhoodPickerViewControler.h"


@implementation NeighborhoodPickerViewControler

@synthesize neighborhoods;
@synthesize letters;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
        

    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation
                                                 currentCollation]; 
    [self setNeighborhoods:[NSMutableArray arrayWithCapacity:1]];
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"neighborhoods" ofType:@"plist"];
    
    NSArray *tempArray; 
    NSMutableArray *neighborhoodsTemp;
    
    if (thePath && (tempArray = [NSArray arrayWithContentsOfFile:thePath]) ) {
        neighborhoodsTemp = [NSMutableArray arrayWithCapacity:1]; 
        
        for (NSDictionary *neighborhoodInfo in tempArray) {
            Neighborhood * newNeighborhood = [[Neighborhood alloc] init];
            [newNeighborhood setName:[neighborhoodInfo objectForKey:@"name"]];
            CLLocationCoordinate2D coord;
            coord.latitude = [[neighborhoodInfo objectForKey:@"lat"] floatValue];
            coord.longitude = [[neighborhoodInfo objectForKey:@"lon"] floatValue];
            [newNeighborhood setCoord:coord];
            [neighborhoodsTemp addObject:newNeighborhood];
            [newNeighborhood release];
        } 
    } else {
        return;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count]; 
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection]; 
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1]; 
        [sectionArrays addObject:sectionArray];
    }
    for (NSDictionary *neighborhood in neighborhoodsTemp) {
        NSInteger sect = [theCollation sectionForObject:neighborhood collationStringSelector:@selector(name)];
        [(NSMutableArray *)[sectionArrays objectAtIndex:sect] addObject:neighborhood];
    } // (4) 
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [self.neighborhoods addObject:sortedSection];
    }
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [neighborhoods count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[neighborhoods objectAtIndex:section]
            count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString * neighborhoodName = [[[neighborhoods objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] name];
    [[cell textLabel] setText:neighborhoodName];
    [[cell textLabel] setFont:[UIFont fontWithName:@"American Typewriter" size:20.0]];
    // Set up the cell...
	
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.neighborhoods objectAtIndex:section] count] > 0) { 
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles]
                                                               objectAtIndex:section]; 
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index]; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Neighborhood * neighborhood = [[neighborhoods objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    ByNeighborhoodDataSource * bnDS = [[ByNeighborhoodDataSource alloc] init];
    [bnDS setNeighborhood:neighborhood];
    InfoMapViewController * imVC = [[InfoMapViewController alloc] initWithNibName:@"InfoMapViewController" bundle:[NSBundle mainBundle] mapCenter:[neighborhood coord] dataSource:bnDS];
    [bnDS release];
    [[self navigationController] pushViewController:imVC animated:YES];
    [imVC release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

