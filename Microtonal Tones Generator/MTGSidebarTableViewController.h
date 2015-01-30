//
//  MTGSidebarTableViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 14/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface MTGSidebarTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray* menuItems /** array of menu items */;
}
/**
   Method called after the view controller has loaded its view hierarchy into memory.
   In this method all main initialization is performed:
   @returns nothing
 */
- (void)viewDidLoad;

/**
	Asks the delegate for the estimated height of a row in a specified location.
	@returns height
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
   Asks the delegate for the height to use for a row in a specified location.
	@returns height
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath ;

/**
    Return the number of sections.
	@param tableView table
	@returns Return the number of sections.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

/**
	Return the number of rows in the section.
	@param tableView table itself
	@param section section of the table
	@returns Return the number of rows in the section.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/**
   Define the inrormation represented in each cell of the table
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
