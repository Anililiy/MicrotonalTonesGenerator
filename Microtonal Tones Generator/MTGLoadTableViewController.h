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


@interface MTGLoadTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *scales;
    NSArray *tableData;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property(nonatomic) NSInteger indexOfFileLoading;

@end
