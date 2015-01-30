//
//  MTGLoadTableViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 14/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGLoadTableViewController.h"
#import "MTGSaveTableViewCell.h"
#import "MTGViewController.h"
#import "MTGAppDelegate.h"

@implementation MTGLoadTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //set the slide bar button action. When it is tapped, it will show up the slidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];

    //
    NSUserDefaults *savedSettings = [NSUserDefaults standardUserDefaults];

    NSMutableArray *archivedSessions = [[NSMutableArray alloc] initWithArray:[savedSettings objectForKey:@"savedSessions"]];
    MTGSavedScale *session;
    sessions = [NSMutableArray array];
    for (NSData *data in archivedSessions){
        session = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [sessions addObject:session];
    }
    
    NSLog(@"Saved %@, count %lu", sessions, (unsigned long)[sessions count]);

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [sessions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTGSavedScale *scale = [sessions objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"chooseScale";
   
    MTGSaveTableViewCell *cell =(MTGSaveTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"chooseScale" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.splitLabel.text = [NSString stringWithFormat:@"Number of splits %li", (long)scale.splitsNumber];
    cell.freqLabel.text = [NSString stringWithFormat:@"f0 = %4.1f Hz", scale.freqInitial];
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    cell.dateLabel.text = [dateFormatter stringFromDate:scale.dateCreated];
    cell.lastUpdateLabel.text = [dateFormatter stringFromDate:scale.dateUpdated];
    cell.imageView.frame = CGRectMake(100, 50, 100, 100);
    cell.imageView.image = scale.imageOfScale;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath %li", (long)indexPath.row);
    index = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath.row;
    return indexPath;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /** - Delete the row from the data source */
        
        [sessions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        /** - Remove the session from saved sessions */
        NSUserDefaults *savedSettings = [NSUserDefaults standardUserDefaults];
        NSMutableArray *archivedSessions = [NSMutableArray array];
        
        for( NSData *data in sessions){
            NSData *encodedSession = [NSKeyedArchiver archivedDataWithRootObject:data];
            [archivedSessions addObject:encodedSession];
        }
        [savedSettings setObject:archivedSessions forKey:@"savedSessions"];
        
        /** - update current index of the session */
        long currentIndex = [savedSettings integerForKey:@"currentScaleIndex"];
        if (currentIndex>=1) currentIndex-=1;
        [savedSettings setInteger:currentIndex forKey:@"currentScaleIndex"];
        [savedSettings synchronize];
        
        /** set app unauthenticated if there is no session saved left */
        if ([sessions count] == 0) {
            MTGAppDelegate *authObj = (MTGAppDelegate*)[[UIApplication sharedApplication] delegate];
            authObj.authenticated = NO;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:NO forKey:@"authenticated"];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loadSaved"])
    {
        MTGViewController *detailViewController = [segue destinationViewController];
        detailViewController.indexOfFileLoading = index;
        detailViewController.loading = true;
    }
}


@end
