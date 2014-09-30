//
//  MTGSettingsViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 14/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGSettingsViewController.h"
#import "MTGColoursViewController.h"
#import "MTGViewController.h"

@interface MTGSettingsViewController ()
@property NSArray *frequencies;
@end

@implementation MTGSettingsViewController

@synthesize popoverController;
@synthesize chosenFrequency;
@synthesize customFrequency;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set the slide bar button action. When it is tapped, it will show up the slidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    //set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self createButton:440:200];
    [self createButton:415:250];
    [self createButton:256:300];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (customFrequency.text!= NULL){
        //chosenFrequency = customFrequency.text;
         NSLog(@"Not null");
         NSLog(@"Frequency not null : %@", customFrequency.text);
    }
    if ([[segue identifier] isEqualToString:@"SendInfo"]) {
        MTGViewController *detailViewController = [segue destinationViewController];
        
        NSLog(@"Number of splits inputed : %@",self.numberOfSplitsInput.text);
        NSLog(@"Frequency inputed : %@", chosenFrequency);
        //This is the id infoRequest, which is a pointer to the object
        //Look at the viewDidLoad in the Destination implementation.
        detailViewController.numberOfSplitsRequest = self.numberOfSplitsInput.text;
        
        detailViewController.frquencyRequest = chosenFrequency;
    }
}


- (IBAction)showPopover:(id)sender {

        MTGColoursViewController *newViewController = [[MTGColoursViewController alloc] initWithNibName:@"MTGColoursViewController" bundle:nil];
        
        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:newViewController];
        popoverController.popoverContentSize = CGSizeMake(225.0, 100.0);
        [popoverController presentPopoverFromRect:[(UIButton *)sender frame]
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:YES];
}

- (IBAction)sendInformation:(id)sender {

}

-(void)createButton:(float)fixedFrequency:(int)yCoordinate{
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setTag:fixedFrequency];
    
    //action of button
    [aButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* title =[NSString stringWithFormat:@"%2.1f", fixedFrequency];;
    [aButton setTitle:title forState:UIControlStateNormal];
    [aButton setTintColor:[UIColor blackColor]];
    //aButton.backgroundColor = [UIColor colorWithHue:hueOfKeys saturation:saturation brightness:1.0 alpha:1.0];
    aButton.frame = CGRectMake(360, yCoordinate, 50, 30);
    [self.view addSubview:aButton];
    
}
- (void)buttonClicked:(UIButton*)aButton
{
    NSLog(@"Button %f clicked.", (float)[aButton tag]);
    //customFrequency.text = NULL;
    chosenFrequency = [NSString stringWithFormat:@"%ld",(long)[aButton tag]];
     NSLog(@"Frequency inputed : %@", chosenFrequency);
    
}
@end
