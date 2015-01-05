//
//  MTGSidebarTableViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 14/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGSidebarTableViewController.h"
#import "MTGAppDelegate.h"

@interface MTGSidebarTableViewController (){
    NSArray* menuItems;
    NSArray* section2;
}
@end

@implementation MTGSidebarTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"MENU";
    //self
    menuItems = @[ @"new", @"load"]; //@"settings"
    section2 =  @[@"information"];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case 1: return [menuItems count];
            break;
        case 2: return [section2 count];
            break;
        case 0: return 1;
    }
    return 0;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section){
        case 0:{
            NSString *CellIdentifier0 = @"title";
            UITableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0 forIndexPath:indexPath];
            return cell0;
        }break;
        case 1:{
            NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
            UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            return cell1;
        }break;
        case 2:{
            NSString *CellIdentifier2 = [section2 objectAtIndex:indexPath.row];
            UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
            return cell2;
        }break;

    }
    return 0;
}

@end
