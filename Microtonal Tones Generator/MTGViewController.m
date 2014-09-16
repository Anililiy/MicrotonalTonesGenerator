//
//  MTGViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGViewController.h"

@interface MTGViewController ()

@end

@implementation MTGViewController

@synthesize frequency;
@synthesize numberOfSplits;
@synthesize hueOfKeys;
@synthesize startButton;
@synthesize creationState;

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
   
    //inputed settings
    
    frequency = 440;
    numberOfSplits = 12;
    hueOfKeys = 0.1;
    creationState = false;
    
    //
    numberOfSplits+=1;
    
    // sound creation
    dispatcher = [[PdDispatcher alloc]init];
    [PdBase setDelegate:dispatcher];
    patch = [PdBase openFile:@"KeyNote.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
    }
    
    
    //change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
    _savedStatesSlideButton.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
    
    //set the slide bar button action. When it is tapped, it will show up the slidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    //set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //set the slide bar button action. When it is tapped, it will show up the slidebar.
    _savedStatesSlideButton.target = self.revealViewController;
    _savedStatesSlideButton.action = @selector(rightRevealToggle:);
    
    //get length and height of screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // calculate the width of key
    float widthOfKey = 3*(float)screenHeight / (4*(numberOfSplits));
    float divisionOfScreen = (float)screenHeight / (numberOfSplits);
   //create array of buttons
    NSLog(@"Number of splits %i", numberOfSplits);
    
    for( int i = 0; i < numberOfSplits; i++ ) {
        UIButton* aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [aButton setTag:i];
        [aButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString* title =[NSString stringWithFormat:@"%d", i+1];;
        [aButton setTitle:title forState:UIControlStateNormal];
        [aButton setTintColor:[UIColor blackColor]];
        float saturation = 1.0*(i+1)/((float)numberOfSplits+1);
        aButton.backgroundColor = [UIColor colorWithHue:hueOfKeys saturation:saturation brightness:1.0 alpha:1.0];
        aButton.frame = CGRectMake(i*divisionOfScreen+(divisionOfScreen-widthOfKey)/2, 100.0, widthOfKey, screenWidth/2);
        [self.view addSubview:aButton];
    }
    
    //set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //control of a start button
    self.startButton.backgroundColor = [UIColor colorWithHue:hueOfKeys saturation:1.0 brightness:0.8 alpha:1];
    [self.startButton addTarget:self action:@selector(startPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// then ...

- (void)buttonClicked:(UIButton*)aButton
{
    NSLog(@"Button %ld clicked.", (long int)[aButton tag]);
    
    float a = powf(2, 1/((float)(numberOfSplits)));
    float n = (([aButton tag]+40) - 49);
    float frequencyOfNote = frequency * (powf(a,n));
    NSLog(@"frequency: %f", frequencyOfNote);
    //[self playNote:frequencyOfNote];
    if (creationState) {
        [self playNote:frequencyOfNote];
    }
    else{
        
    }
}
- (IBAction)buttonPressed:(id)sender
{
}


-(void)startPressed:(UIButton*)button
{
    if (!creationState){
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        creationState = true;
    }
    else
    {
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        creationState = false;
    }
    
}

#pragma mark - button call back

-(void)playNote:(int)n{
    [PdBase sendFloat:n toReceiver:@"midinote"];
    [PdBase sendBangToReceiver:@"trigger"];
}


@end
