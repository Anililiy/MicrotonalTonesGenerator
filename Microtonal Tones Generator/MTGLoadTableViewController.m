//
//  MTGLoadTableViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 14/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGLoadTableViewController.h"
#import "MTGSaveTableViewCell.h"
//#import "SimpleTableCell.h"

@interface MTGLoadTableViewController ()

@end

@implementation MTGLoadTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //set the slide bar button action. When it is tapped, it will show up the slidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    //set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //
    NSUserDefaults *savedSettings = [NSUserDefaults standardUserDefaults];
    NSMutableArray *archivedScales = [[NSMutableArray alloc] initWithArray:[savedSettings objectForKey:@"scales"]];
    MTGSavedScale *scale;
    scales = [NSMutableArray array];
    for (NSData *data in archivedScales){
        scale = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [scales addObject:scale];
    }
    
    NSLog(@"Saved %@, count %lu", scales, (unsigned long)[scales count]);

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
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [scales count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTGSavedScale *scale = [scales objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"chooseScale";
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"%i", scale.splitsNumber];
    return cell;
     */
   
    MTGSaveTableViewCell *cell =(MTGSaveTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"chooseScale" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.splitLabel.text = [NSString stringWithFormat:@"%i", scale.splitsNumber];
    cell.freqLabel.text = [NSString stringWithFormat:@"%4.1f", scale.freqInitial];
    cell.dateLabel.text = @"12";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath %li", (long)indexPath.row);
    
    // Checked the selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _indexOfFileLoading = indexPath.row;
    //
    /*
    NSUserDefaults *savedSettings = [NSUserDefaults standardUserDefaults];
    [savedSettings setInteger:indexPath.row forKey:@"savedCopyLoad"];
    [savedSettings synchronize];
     */
}

/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loadSaved"])
    {
        MTGLoadTableViewController *controller = (MTGLoadTableViewController *)segue.destinationViewController;
        controller.indexOfFileLoading = _indexOfFileLoading;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
