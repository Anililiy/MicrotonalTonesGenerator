//
//  MTGRootViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 27/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGRootViewController.h"
#import "MTGFirstLoginViewController.h"
#import "MTGAppDelegate.h"
#import "SWRevealViewController.h"

@interface MTGRootViewController ()

@end

@implementation MTGRootViewController

@synthesize loginView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginBtnPressed:(id)sender {
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:12 forKey:@"deaultNumberOfSplits"];
    [defaults setFloat:440 forKey:@"defaultFrequency"];
    [defaults setFloat:0.7 forKey:@"initThemeHue"];
    [defaults setFloat:1 forKey:@"initThemeSat"];
    [defaults setFloat:1 forKey:@"initThemeBrg"];
    [defaults setInteger:0 forKey:@"currentScale"];
    [defaults setInteger:0 forKey:@"currentScaleIndex"];
    [defaults setInteger:0 forKey:@"noOfScalesCreated"];
    [defaults setBool:YES forKey:@"firstRun"];
    
    [defaults synchronize];
    
    NSLog(@"Data saved");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginActionFinished:)
                                                 name:@"loginActionFinished"
                                               object:loginView];
    
}

-(void) loginActionFinished:(NSNotification*)notification {
    
    MTGAppDelegate *authObj = (MTGAppDelegate*)[[UIApplication sharedApplication] delegate];
    authObj.authenticated = YES;
    
    [self dismissLoginAndShowProfile];
}

- (void)dismissLoginAndShowProfile {
    [self dismissViewControllerAnimated:NO completion:^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWRevealViewController *tabView = [storyboard instantiateViewControllerWithIdentifier:@"profileView"];
        [self presentViewController:tabView animated:YES completion:nil];
    }];
    
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
