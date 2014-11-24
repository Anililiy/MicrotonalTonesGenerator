//
//  MTGSavedStatesTableViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 14/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "MTGViewController.h"

@interface MTGSavedStatesTableViewController : UITableViewController
@property NSMutableArray *savedStates;
@property NSString *str;

-(void)dataFill;
@end
