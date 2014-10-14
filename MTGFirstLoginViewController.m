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
#import "MTGColoursViewController.h"

@interface MTGFirstLoginViewController ()

@end

@implementation MTGFirstLoginViewController

@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    errorSplit.text = nil;
    splitInput = false;
    freqInput = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender{

    if (freqInput && splitInput){
        // Hide the keyboard
        [nameOfUser resignFirstResponder];
        [defaultSplitsInp resignFirstResponder];
        
        // Create strings and integer to store the text info
        NSString *userName = [nameOfUser text];
        int defNumberOfSplits = [[defaultSplitsInp text] integerValue];

        float defFrequency = [chosenFrequency floatValue];
        
        // Store the data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:userName forKey:@"userName"];
        [defaults setInteger:defNumberOfSplits forKey:@"deaultNumberOfSplits"];
        [defaults setFloat:defFrequency forKey:@"defaultFrequency"];
        [defaults setFloat:colourHue forKey:@"initThemeHue"];
        [defaults setFloat:colourSat forKey:@"initThemeSat"];
        [defaults setFloat:colourBrg forKey:@"initThemeBrg"];
        
        if (![defaults objectForKey:@"firstRun"]) [defaults setBool:YES forKey:@"firstRun"];
        
        [defaults synchronize];
        
        NSLog(@"Data saved");

        //create translation between screens
        MTGAppDelegate *authObj = (MTGAppDelegate*)[[UIApplication sharedApplication] delegate];
        authObj.authenticated = YES;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        MTGRootViewController *initView =  (MTGRootViewController*)[storyboard instantiateViewControllerWithIdentifier:@"profileView"];
        [initView setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:initView animated:NO completion:nil];
    }
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Some data is not inputed"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }

    
}

- (IBAction)validateInput:(id)sender {
    BOOL numberInputOnly = true;
    char y = [defaultSplitsInp.text characterAtIndex:(defaultSplitsInp.text.length-1)];
    if (y < '0' || y > '9'){
        NSLog(@"wrong input");
        numberInputOnly = false;
    }

    if (defaultSplitsInp.text.integerValue < 1 || defaultSplitsInp.text.integerValue> 64 || !numberInputOnly){
        defaultSplitsInp.backgroundColor = [UIColor redColor];
        splitInput = false;
        errorSplit.text = @"No! Split is between 1 and 64";
    }
    else{
        defaultSplitsInp.backgroundColor = nil;
        splitInput = true;
        errorSplit.text = nil;
    }
}

- (IBAction)colorSelection:(id)sender {
    MTGColoursViewController *newViewController = [[MTGColoursViewController alloc] initWithNibName:@"MTGColoursViewController" bundle:nil];
    
    newViewController.delegate = self;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:newViewController];
    popoverController.popoverContentSize = CGSizeMake(225.0, 100.0);
    [popoverController presentPopoverFromRect:[(UIButton *)sender frame]
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionRight
                                     animated:YES];
}

- (IBAction)chooseFreq:(UIButton*)aButton {
    NSString *buttonName = [aButton titleForState:UIControlStateNormal];

    for (UIButton* button in defFreqInp){
        if (button == aButton) button.selected = true;
        else button.selected = false;
    }
    if (chosenFrequency != buttonName) {
        chosenFrequency = buttonName;
        freqInput = true;
        NSLog(@"Frequency selected: %@", chosenFrequency);
    }
    
}

-(void)colorPopoverControllerDidSelectColor:(UIColor*) colour{
    
    colorSelector.backgroundColor = colour;
    [self.view setNeedsDisplay];
    [popoverController dismissPopoverAnimated:NO];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
