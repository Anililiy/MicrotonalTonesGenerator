//
//  MTGViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGViewController.h"
#import "PdFile.h"
#import "PdBase.h"

NSString *const kTestPatchName = @"test2.pd";

@interface MTGViewController ()

@property (nonatomic, retain) NSMutableArray *patches;
@property (nonatomic, assign) int dollarZero;

@end

@implementation MTGViewController

@synthesize frequency;
@synthesize numberOfSplits;
@synthesize hueOfKeys;
@synthesize startButton;
@synthesize creationState;
@synthesize patches = _patches;
@synthesize dollarZero = dollarZero_;


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
    self.patches = [NSMutableArray array];
    
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
    
    //create an array of buttons
    for( int i = 0; i < numberOfSplits; i++ ) {
        [self createButton: i];
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


- (void)buttonClicked:(UIButton*)aButton
{
    NSLog(@"Button %ld clicked.", (long int)[aButton tag]);

    float a = powf(2, 1/((float)(numberOfSplits)));
    float n = (([aButton tag]+40) - 49);
    float frequencyOfNote = frequency * (powf(a,n));
    NSLog(@"frequency: %f", frequencyOfNote);

    if (creationState) {
        [self playNote:frequencyOfNote];
        //aButton.backgroundColor = [UIColor yellowColor];
    }
    else{
        [self.patches removeAllObjects];
    }
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
        [self.patches removeAllObjects];
    }
    
}

-(void)createButton:(int)index{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // calculate the width of key
    float widthOfKey = 3*(float)screenHeight / (4*(numberOfSplits));
    float divisionOfScreen = (float)screenHeight / (numberOfSplits);
    
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setTag:index];
    
    //action of button
    [aButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* title =[NSString stringWithFormat:@"%d", index];;
    [aButton setTitle:title forState:UIControlStateNormal];
    [aButton setTintColor:[UIColor blackColor]];
    float saturation = 1.0*(index+1)/((float)numberOfSplits+1);
    aButton.backgroundColor = [UIColor colorWithHue:hueOfKeys saturation:saturation brightness:1.0 alpha:1.0];
    aButton.frame = CGRectMake(index*divisionOfScreen+(divisionOfScreen-widthOfKey)/2, 100.0, widthOfKey, screenWidth/2);
    [self.view addSubview:aButton];

}


#pragma mark - button call back

-(void)playNote:(int)n{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    PdFile *patchOfKey = [PdFile openFileNamed:kTestPatchName path:bundlePath];
    if (patchOfKey) {
        NSLog(@"opened patch with $0 = %d", [patchOfKey dollarZero]);
        
        [self.patches addObject:patchOfKey];
    } else {
        NSLog(@"error: couldn't open patch");
    }
    [PdBase sendFloat:n toReceiver:[NSString stringWithFormat:@"%d-pitch", [patchOfKey dollarZero]]];
}


@end
