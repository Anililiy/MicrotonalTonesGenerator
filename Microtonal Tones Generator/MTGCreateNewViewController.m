//
//  MTGCreateNewViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 15/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGCreateNewViewController.h"
#import "SWRevealViewController.h"

@interface MTGCreateNewViewController ()

@end

@implementation MTGCreateNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    //set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view.
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


- (IBAction)createIt:(id)sender {
    
}

- (IBAction)frequencyInputChanged:(UISlider *)slider {
    frequency = slider.value;
    frequencyLabel.text = [NSString stringWithFormat:@"%4.1f Hz", frequency];
}

- (IBAction)splitInputChanged:(UISlider *)slider{
    split = slider.value;
    splitLabel.text = [NSString stringWithFormat:@"%i", split];
}
@end
