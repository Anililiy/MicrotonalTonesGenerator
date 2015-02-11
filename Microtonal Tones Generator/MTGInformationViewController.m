//
//  MTGInformationViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 13/01/2015.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "MTGInformationViewController.h"
#import "SWRevealViewController.h"

@implementation MTGInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Information view is opened");
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        UIBarButtonItem *barBtnMenu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openLeftMenu)];
        barBtnMenu.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
        
        self.navigationItem.leftBarButtonItem = barBtnMenu;
        
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }

}

-(void)openLeftMenu{
    SWRevealViewController *reveal = self.revealViewController;
    [reveal revealToggleAnimated:YES];
    NSLog(@"Opens menu - main menu");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
