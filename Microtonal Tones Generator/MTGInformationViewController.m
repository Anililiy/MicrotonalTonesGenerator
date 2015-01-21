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
    /*_menuCalled = !_menuCalled;
    [self.view bringSubviewToFront:_ViewCover];
    
    if (_menuCalled)[_ViewCover setHidden:false];
    else            [_ViewCover setHidden:true];
    */
    SWRevealViewController *reveal = self.revealViewController;
    [reveal revealToggleAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
