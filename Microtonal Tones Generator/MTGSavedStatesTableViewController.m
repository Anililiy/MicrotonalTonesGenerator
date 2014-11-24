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
@synthesize savedStates,str;

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
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    [self dataFill];
}

-(void)dataFill{
    savedStates = [NSMutableArray array];
    
    NSUserDefaults *savedSettings = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *archivedScales = [[NSMutableArray alloc] initWithArray:[savedSettings objectForKey:@"savedSessions"]];
    MTGSavedScale *scale;
    NSMutableArray *scales;
    scales = [NSMutableArray array];
    for (NSData *data in archivedScales){
        scale = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [scales addObject:scale];
    }
    int indexOfScale = [savedSettings integerForKey:@"currentScaleIndex"];
    scale = [scales objectAtIndex:indexOfScale];
    savedStates = scale.savedStates;
    
    //[savedStates addObjectsFromArray:@[@"12",@"14"]];
    NSLog(@"We are given: %@", savedStates);
    
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
        
            NSString *label=@"";
            MTGKeyObject *key;
            for (int i=0; i<[keysPressed count];i++){
                key = keysPressed[i];
                label = [NSString stringWithFormat:@"%@ - %ld",label, (long)key.index];
            }
            UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell1.textLabel.textAlignment = NSTextAlignmentCenter;
            cell1.textLabel.text = label;
            return cell1;
        }break;
            
    }
    return 0;

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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
