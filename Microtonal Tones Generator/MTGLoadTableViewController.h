//
//  MTGLoadTableViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 14/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "MTGSavedScale.h"


@interface MTGLoadTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *sessions /** array of saved sessions */;
    NSInteger index /** index of session which will be loaded */;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton /** array containing primary colours */;

/**
    Method called after the view controller has loaded its view hierarchy into memory.
    In this method all main initialization is performed.
	@returns nothing
 */
- (void)viewDidLoad;

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
/**
   Tells the delegate that the specified row is now selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
	Tells the delegate that a specified row is about to be selected.
	@returns indexPath
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/**
	Support conditional editing of the table view.
    @returns YES
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

/**
	Support editing the table view.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
	Set values to be passed to MTGViewController
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
