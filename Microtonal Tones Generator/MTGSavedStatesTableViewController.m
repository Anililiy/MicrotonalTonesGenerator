//
//  MTGSavedStatesTableViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 14/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGSavedStatesTableViewController.h"

@interface MTGSavedStatesTableViewController ()

@end

@implementation MTGSavedStatesTableViewController
@synthesize savedStates,str, indexOfScaleSelected, scales, indexOfScale, scaleUsed;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [self dataFill];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Input %@", str);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];

    [self dataFill];
}

-(void)dataFill{
    scales = [NSMutableArray array];
    savedStates = [NSMutableArray array];
    NSUserDefaults *savedSettings = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *archivedScales = [[NSMutableArray alloc] initWithArray:[savedSettings objectForKey:@"savedSessions"]];
    //MTGSavedScale *scaleUsed;
    for (NSData *data in archivedScales){
        scaleUsed = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [scales addObject:scaleUsed];
    }
    indexOfScale = [savedSettings integerForKey:@"currentScaleIndex"];
    scaleUsed = [scales objectAtIndex:indexOfScale];
    savedStates = scaleUsed.savedStates;
    
    //[savedStates addObjectsFromArray:@[@"12",@"14"]];
    NSLog(@"We are given: %@", savedStates);
    [self.tableView reloadData];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case 0: return 1;
            break;
        case 1: return [savedStates count];
            break;
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
            NSString *CellIdentifier = @"state";
            NSMutableArray *keysPressed = [[NSMutableArray alloc] initWithArray:savedStates[indexPath.row]];
        
            MTGKeyObject *key;
            key = keysPressed[0];
            NSString *label=[NSString stringWithFormat:@"%li",(long)key.index];
           
            for (int i=1; i<[keysPressed count];i++){
                key = keysPressed[i];
                label = [NSString stringWithFormat:@"%@-%ld",label, (long)key.index];
            }
            UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell1.textLabel.textAlignment = NSTextAlignmentRight;
            cell1.textLabel.font = [UIFont fontWithName:@"Frangelica" size:15.0];
            cell1.textLabel.text = label;
            
            return cell1;
        }break;
            
    }
    return 0;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath %li", (long)indexPath.row);
    indexOfScaleSelected = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexOfScaleSelected = indexPath.row;
    return indexPath;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section) {
        case 0: return NO;
            break;
        case 1: return YES;
            break;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
       
        [savedStates removeObjectAtIndex:[indexPath row]];
        NSLog(@"states afrer deletion %@",savedStates);
        scaleUsed.savedStates = savedStates;
        NSUserDefaults *savedSettings = [NSUserDefaults standardUserDefaults];
        NSMutableArray *archivedScales = [[NSMutableArray alloc] initWithArray:[savedSettings objectForKey:@"savedSessions"]];
        
        NSData * archivedScale = [NSKeyedArchiver archivedDataWithRootObject:scaleUsed];
        [archivedScales replaceObjectAtIndex:indexOfScale withObject:archivedScale];
        
        [savedSettings setObject:archivedScales forKey:@"savedSessions"];
        [savedSettings synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
       // [self.tableView reloadData];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"openState"])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        MTGViewController *detailViewController = (MTGViewController *)navController.topViewController;
        detailViewController.indexOfStateChosen = indexOfScaleSelected;
        detailViewController.stateSelected = true;
    }
}


@end
