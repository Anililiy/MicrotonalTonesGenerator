//
//  MTGFirstLoginViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 21/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGFirstLoginViewController.h"
#import "MTGAppDelegate.h"
#import "MTGRootViewController.h"

@interface MTGFirstLoginViewController ()

@end

@implementation MTGFirstLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender{

    // Hide the keyboard
    [nameOfUser resignFirstResponder];
    [defaultSplitsInp resignFirstResponder];
    
    // Create strings and integer to store the text info
    NSString *userName = [nameOfUser text];
    int defNumberOfSplits = [[defaultSplitsInp text] integerValue];
    
    //float defFrequency = [[defaultFrequencyInp text] floatValue];
    float defFrequency = [chosenFrequency floatValue];
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:userName forKey:@"userName"];
    [defaults setInteger:defNumberOfSplits forKey:@"deaultNumberOfSplits"];
    [defaults setFloat:defFrequency forKey:@"defaultFrequency"];
    
    //if (![defaults objectForKey:@"firstRun"]) [defaults setBool:YES forKey:@"firstRun"];
    [defaults setBool:FALSE forKey:@"firstRun"];
    
    [defaults synchronize];
    
    NSLog(@"Data saved");

    //[defaults setBool:true forKey:@"firstRun"];
    //create translation between screens
    MTGAppDelegate *authObj = (MTGAppDelegate*)[[UIApplication sharedApplication] delegate];
    authObj.authenticated = YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MTGRootViewController *initView =  (MTGRootViewController*)[storyboard instantiateViewControllerWithIdentifier:@"profileView"];
    [initView setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:initView animated:NO completion:nil];

    
}

- (IBAction)chooseFreq:(UIButton*)aButton {
    NSString *buttonName = [aButton titleForState:UIControlStateNormal];

    for (UIButton* button in defFreqInp){
        if (button == aButton) button.selected = true;
        else button.selected = false;
    }
    if (chosenFrequency != buttonName) {
        chosenFrequency = buttonName;
    }
    NSLog(@"Frequency selected: %@", chosenFrequency);
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
