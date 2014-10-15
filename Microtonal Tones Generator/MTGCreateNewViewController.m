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
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    //set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // init
    frequency = 440.0;
    split = 12;
    splitLabel.text = [NSString stringWithFormat:@"%i", split];
    frequencyLabel.text = [NSString stringWithFormat:@"%4.0f Hz", frequency];
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

    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:split   forKey:@"numberOfSplits"];
    [defaults setFloat:frequency forKey:@"frequency"];
    [defaults setFloat:colourHue forKey:@"themeHue"];
    [defaults setFloat:colourSat forKey:@"themeSat"];
    [defaults setFloat:colourBrg forKey:@"themeBrg"];
    
    [defaults synchronize];
    
    NSLog(@"Data saved");

}

- (IBAction)showColourPopup:(id)sender {
    
    MTGColoursViewController *newViewController = [[MTGColoursViewController alloc] initWithNibName:@"MTGColoursViewController" bundle:nil];
    
    newViewController.delegate = self;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:newViewController];
    popoverController.popoverContentSize = CGSizeMake(225.0, 100.0);
    [popoverController presentPopoverFromRect:[(UIButton *)sender frame]
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionRight
                                     animated:YES];

}

-(void)colorPopoverControllerDidSelectColor:(UIColor*) colour{
    
    chooseTheme.backgroundColor = colour;
    [self.view setNeedsDisplay];
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    BOOL success = [colour getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    NSLog(@"success: %i hue: %0.2f, saturation: %0.2f, brightness: %0.2f, alpha: %0.2f", success, hue, saturation, brightness, alpha);
    colourHue = hue;
    colourSat = saturation;
    colourBrg = brightness;
}

- (IBAction)chooseFreq:(UIButton*)aButton {
    NSString *buttonName = [aButton titleForState:UIControlStateNormal];
    
    for (UIButton* button in freqButtons){
        if (button == aButton) button.selected = true;
        else button.selected = false;
    }
    if (chosenFrequency != buttonName) {
        chosenFrequency = buttonName;
        NSLog(@"Frequency selected: %@", chosenFrequency);
        frequency = [chosenFrequency floatValue];
    }
    
}

- (IBAction)frequencyInputChanged:(UISlider *)slider {
    frequency = slider.value;
    frequencyLabel.text = [NSString stringWithFormat:@"%4.0f Hz", frequency];
    for (UIButton* button in freqButtons)button.selected = false;
}

- (IBAction)splitInputChanged:(UISlider *)slider{
    split = slider.value;
    splitLabel.text = [NSString stringWithFormat:@"%i", split];
}
@end
