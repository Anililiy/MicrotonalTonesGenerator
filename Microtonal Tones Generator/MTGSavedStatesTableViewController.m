//
//  MTGSavedStatesTableViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 14/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGSavedStatesTableViewController.h"

@implementation MTGSavedStatesTableViewController
@synthesize savedStates, indexOfStateSelected, indexOfSession, sessionUsed;

-(void)viewDidAppear:(BOOL)animated{
    [self dataFill];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self dataFill];
}

-(void)dataFill{
    NSMutableArray* sessions = [NSMutableArray array];
    savedStates = [NSMutableArray array];
    
    NSUserDefaults *savedSettings = [NSUserDefaults standardUserDefaults];
    NSMutableArray *archivedSessions = [[NSMutableArray alloc] initWithArray:[savedSettings objectForKey:@"savedSessions"]];

    for (NSData *data in archivedSessions){
        sessionUsed = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [sessions addObject:sessionUsed];
    }
    
    indexOfSession = [savedSettings integerForKey:@"currentScaleIndex"];
    
    sessionUsed = [sessions objectAtIndex:indexOfSession];
    
    savedStates = sessionUsed.savedStates;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
        
            MTGKeyButton *key;
            key = keysPressed[0];
            NSString *label=[NSString stringWithFormat:@"%li",(long)key.index];
           
            for (int i=1; i<[keysPressed count];i++){
                key = keysPressed[i];
                label = [NSString stringWithFormat:@"%@-%ld",label, (long)key.index];
            }
            UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell1.textLabel.textAlignment = NSTextAlignmentRight;
            cell1.textLabel.font = [UIFont fontWithName:@"GillSans" size:18.0];
            cell1.textLabel.text = label;
            
            return cell1;
        }break;
            
    }
    return 0;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath %li", (long)indexPath.row);
    indexOfStateSelected = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexOfStateSelected = indexPath.row;
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
        sessionUsed.savedStates = savedStates;
        NSUserDefaults *savedSettings = [NSUserDefaults standardUserDefaults];
        NSMutableArray *archivedSessions = [[NSMutableArray alloc] initWithArray:[savedSettings objectForKey:@"savedSessions"]];
        
        NSData * archivedSessoin = [NSKeyedArchiver archivedDataWithRootObject:sessionUsed];
        [archivedSessions replaceObjectAtIndex:indexOfSession withObject:archivedSessoin];
        
        [savedSettings setObject:archivedSessions forKey:@"savedSessions"];
        [savedSettings synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
        detailViewController.indexOfStateChosen = indexOfStateSelected;
        detailViewController.stateSelected = true;
    }
}


@end
