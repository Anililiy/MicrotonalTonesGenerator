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
#import "MTGAppDelegate.h"
#import "MTGRootViewController.h"

NSString *const kTestPatchName = @"test2.pd";

@interface MTGViewController ()

@property (nonatomic, retain) NSMutableArray *patches;
@property (nonatomic, assign) int dollarZero;

@end

@implementation MTGViewController

@synthesize startButton;
@synthesize patches = _patches;
@synthesize dollarZero = dollarZero_;
@synthesize numberOfSplitsRequest;
@synthesize frquencyRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    /*
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"textures_1.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    */
    // sound creation
    dispatcher = [[PdDispatcher alloc]init];
    [PdBase setDelegate:dispatcher];
    patch = [PdBase openFile:@"KeyNote.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
    }
    
    //
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults integerForKey:@"numberOfSplits"]) {
        numberOfSplits = [defaults integerForKey:@"deaultNumberOfSplits"];
        frequency = [defaults floatForKey:@"defaultFrequency"];
        hueOfKeys = [defaults floatForKey:@"initThemeHue"];
        saturOfKeys = [defaults floatForKey:@"initThemeSat"];
        brightOfKey = [defaults floatForKey:@"initThemeBrg"];
    }
    else{
        numberOfSplits = [defaults integerForKey:@"numberOfSplits"];
        frequency = [defaults floatForKey:@"frequency"];
        hueOfKeys = [defaults floatForKey:@"themeHue"];
        saturOfKeys = [defaults floatForKey:@"themeSat"];
        brightOfKey = [defaults floatForKey:@"themeBrg"];
    }
   
    
    //inputed settings
    /*
    NSString *numberOfSplitsInp = [self.numberOfSplitsRequest description];
    if ([numberOfSplitsInp intValue]>=1) {
        NSLog(@"received number of splits %@", [self.numberOfSplitsRequest description]);
        numberOfSplits = [numberOfSplitsInp intValue];
    }
    NSString *frequencyInput = [self.frquencyRequest description];
    if ([frequencyInput floatValue]>100) {
        NSLog(@"received frequency %@", [self.frquencyRequest description]);
        frequency = [frequencyInput floatValue];
    }
    */
   
    //setting of prog
    
    creationState = false;
    
    _patches = [NSMutableArray array];
    for (int i = 0; i<numberOfSplits; i++)[_patches addObject:@"1"];
    NSLog(@"Patches: %i", [_patches count]);
    
    {
    //change slidebar button color
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
    }
    //create an array of buttons
    for( int i = 0; i <= numberOfSplits; i++ ) {
        [self createButton: i];
    }
   
    //control of a start button
    self.startButton.tintColor = [UIColor colorWithHue:hueOfKeys saturation:1.0 brightness:0.8 alpha:1];
    [self.startButton addTarget:self action:@selector(startPressed:) forControlEvents:UIControlEventTouchUpInside];
    ///
    //
    if(![(MTGAppDelegate*)[[UIApplication sharedApplication] delegate] authenticated]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        MTGRootViewController *initView =  (MTGRootViewController*)[storyboard instantiateViewControllerWithIdentifier:@"initialView"];
        [initView setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:initView animated:NO completion:nil];
    } else{
        // proceed with the profile view
    }

}

- (void)viewDidUnload {
    [super viewDidUnload];
    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - buttons regulation

-(void)startPressed:(UIButton*)button{
    if (!creationState){
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
        creationState = true;
    }
    else
    {
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        creationState = false;
        [self.patches removeAllObjects];
        for (int i = 0; i<numberOfSplits; i++)
        {
            [_patches addObject:@"1"];
        }
        NSLog(@"Patches: %i", [_patches count]);
    }
    
}

-(void)createButton:(int)index{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // calculate the width of key
    float widthOfKey = 3*(float)screenHeight / (4*(numberOfSplits+1));
    float divisionOfScreen = (float)screenHeight / (numberOfSplits+1);
    
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [aButton setTag:index];
    
    //action of button
    [aButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* title =[NSString stringWithFormat:@"%d", index];;
    [aButton setTitle:title forState:UIControlStateNormal];
    UIImage *btnImage = [UIImage imageNamed:@"transparent.png"];
    //[aButton setImage:btnImage forState:UIControlStateNormal];
    [aButton setTintColor:[UIColor blackColor]];
    float saturation = saturOfKeys*(index+1)/((float)numberOfSplits+1);
    float brightnesOfKey = brightOfKey;
    if (brightOfKey<0.09) brightnesOfKey=1.0*(index+1)/((float)numberOfSplits+1);
    aButton.backgroundColor = [UIColor colorWithHue:hueOfKeys saturation:saturation brightness:brightnesOfKey alpha:1.0];
    //aButton.tintColor = [UIColor colorWithHue:hueOfKeys saturation:saturation brightness:brightnesOfKey alpha:0.5f];
    
    aButton.frame = CGRectMake(index*divisionOfScreen+(divisionOfScreen-widthOfKey)/2, 100.0, widthOfKey, screenWidth/2);
    
    [self.view addSubview:aButton];

}

- (void)buttonClicked:(UIButton*)aButton{
    
    NSLog(@"Button %i clicked.",[aButton tag]);
    
    float frequencyOfNote = calcFreqOfNote([aButton tag], numberOfSplits, frequency);
    
    if (creationState){
        if(!aButton.selected) {
            aButton.selected = true;
            [self playNoteLong:frequencyOfNote:[aButton tag]];
        }
        else{
            NSLog(@"Patch removed with %i", [aButton tag]);
            [self.patches removeObjectAtIndex:[aButton tag]];
            [self.patches insertObject:@"1" atIndex:[aButton tag]];
            aButton.selected =!aButton.selected;
        }
    }
    else{
        [self playNoteShort:frequencyOfNote];
        aButton.selected =false;
    }
}

float calcFreqOfNote (int tag, int ns, float f){
    
    float a = powf(2, 1/((float)(ns)));
    float n = (tag+40) - 49;
    float frequencyOfNote = f * (powf(a,n));
    
    NSLog(@"frequency calculated: %f", frequencyOfNote);

    return frequencyOfNote;
}
#pragma mark - button call back

-(void)playNoteLong:(int)n:(int)index{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    PdFile *patchOfKey = [PdFile openFileNamed:kTestPatchName path:bundlePath];
    if (patchOfKey) {
        NSLog(@"opened patch with $0 = %d", [patchOfKey dollarZero]);
        NSLog(@"Patches: %i", [_patches count]);

        [_patches insertObject:patchOfKey atIndex:index];
    }
    else {
        NSLog(@"error: couldn't open patch");
    }
    [PdBase sendFloat:n toReceiver:[NSString stringWithFormat:@"%d-pitch", [patchOfKey dollarZero]]];
}

-(void)playNoteShort:(int)n{
    [PdBase sendFloat:n toReceiver:@"midinote"];
    [PdBase sendBangToReceiver:@"trigger"];
}

@end
