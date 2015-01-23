//
//  MTGViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 13/09/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import "MTGViewController.h"
#import "MTGAppDelegate.h"
#import "MTGCreateNewViewController.h"

#import "PdFile.h"
#import "PdBase.h"

NSString *const kTestPatchName   = @"test2.pd";
NSString *const kShortPatchName  = @"KeyNote.pd";
NSString *const kShortPatchName2 = @"KeyNote3.pd";

@implementation MTGViewController

@synthesize loading, indexOfFileLoading, saveButton, startButtonItem;
@synthesize stateSelected, indexOfStateChosen, frequencyLabel;
@synthesize playNextStateButton, playPreviousStateButton, ViewCover, ViewCover2;
@synthesize upTheOctave, downTheOctave, changeOctave;


// function that calculates frequency of the note
float calcFreqOfNote (NSInteger position, NSInteger splits, float f0){

    float frequencyOfNote = f0 * powf(2, position/((float)(splits)));
    
    NSLog(@"frequency calculated: %f", frequencyOfNote);
    
    return frequencyOfNote;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    /**
       -  check if app loads for the first time or if there has been no saved sessions selected, nor any newly created, but not saved, and if it is true, represent MTGCreateNewViewController
     */
    if(![(MTGAppDelegate*)[[UIApplication sharedApplication] delegate] authenticated]) {
           SWRevealViewController *revealViewController = self.revealViewController;
           UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
           MTGCreateNewViewController *frontViewController = [sb instantiateViewControllerWithIdentifier:@"myViewController"];
           UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
           [revealViewController setFrontViewController:frontNavigationController animated:YES];
    }
    else{
        //primary settings of Session View Controller
        
        /**
           - create two views on the top of View Controller of a size of iPad screen so that in if menus called cover appear initially set hidden because no menu called
         */
        [self changeSize];
        [ViewCover  setHidden:true];
        [ViewCover2 setHidden:true];
        
        /**
            - add Gesture Recognizers to cover views so that if they pressed menus would be closed and if menus open then those views to be shown
         */
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(openLeftMenu)];
        [ViewCover addGestureRecognizer:singleFingerTap];

        UITapGestureRecognizer *singleFingerTap2 =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(openRightMenu)];
        [ViewCover2 addGestureRecognizer:singleFingerTap2];

        /** - allocate Navigation Item Bar Buttons to open and show menus */
        SWRevealViewController *revealViewController = self.revealViewController;
        
        if ( revealViewController )
        {
            UIBarButtonItem *barBtnMenu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openLeftMenu)];
            barBtnMenu.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
            
            self.navigationItem.leftBarButtonItem = barBtnMenu;
            
            UIBarButtonItem *barBtnStates = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openRightMenu)];
            barBtnStates.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
            
            self.navigationItem.rightBarButtonItem = barBtnStates;
            
            [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        }
        
        /** - load values passed from other scenes using NSUserDefaults */
        [self initialiseValues];

        creationState = false;
        menuCalled    = false;

        if (savedStates.count>0){
            self.navigationItem.rightBarButtonItem.enabled = true;
        }
        else {
            self.navigationItem.rightBarButtonItem.enabled = false;
        }
        
        /**
          - register a dispatcher object with libpd. It logs status messages that Pd prints to the console. After registering the receiver, open short patch.
         */
        dispatcher = [[PdDispatcher alloc]init];

        [PdBase setDelegate:dispatcher];
        patch = [PdBase openFile:kShortPatchName path:[[NSBundle mainBundle] resourcePath]];
        if (!patch) {
            NSLog(@"Failed to open patch!");
        }
        
        /** - initialize arrays */
        patches     = [NSMutableArray array];
        keyboard    = [NSMutableArray array];
        pressedKeys = [NSMutableArray array];
        
        /** - fill patches array */
        for (int i = 0; i<=numberOfSplits; i++){
            [patches addObject:@"1"];
             [self createButton: i];
        }
        NSLog(@"Patches: %lu", (unsigned long)[patches count]);

        /**  - represent selected state when passing from saved states menu */
        [self representStateSeleted];
        
        /**  - represent initial frequency on the screen */
        frequencyLabel.text = [NSString stringWithFormat:@"fo = %4.1f Hz", frequency];
    }
}

-(void)changeSize{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect frame = ViewCover.frame;
    frame.size.height = screenRect.size.height;
    frame.size.width  = screenRect.size.width;
    frame.origin = CGPointMake (0, 0);
    ViewCover.frame = frame;
    ViewCover2.frame = frame;
    
    [self.view bringSubviewToFront:ViewCover];
    [self.view bringSubviewToFront:ViewCover2];
}

-(void)openLeftMenu{
    [self clearUp];
    menuCalled = !menuCalled;
    [self.view bringSubviewToFront:ViewCover];

    if (menuCalled)[ViewCover setHidden:false];
    else [ViewCover setHidden:true];
    
    SWRevealViewController *reveal = self.revealViewController;
    [reveal revealToggleAnimated:YES];
}

-(void)openRightMenu{
    [self clearUp];
    menuCalled = !menuCalled;
    [self.view bringSubviewToFront:ViewCover2];

    if (menuCalled)[ViewCover2 setHidden:false];
    else {
        [ViewCover2 setHidden:true];
        [self initialiseValues];
    }

    [startButtonItem setTitle:@"Polyphony"];
    creationState = false;
    saveButton.enabled = false;
    playPreviousStateButton.enabled = false;
    playNextStateButton.enabled = false;
    
    SWRevealViewController *reveal = self.revealViewController;
    [reveal rightRevealToggleAnimated:YES];
}

- (void)initialiseValues{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    currentScale = [[MTGSavedScale alloc]init];
    NSMutableArray *archivedScales = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"savedSessions"]];
    sessionIsSaved = [defaults boolForKey:@"saved"];

    if (loading){
        
        NSLog(@"Index of file loading: %li",(long)indexOfFileLoading);
        currentScale = [NSKeyedUnarchiver unarchiveObjectWithData:archivedScales[indexOfFileLoading]];
    
        savedStates = [NSMutableArray arrayWithArray:currentScale.savedStates];
        numberOfSplits = currentScale.splitsNumber;
        frequency = currentScale.freqInitial;
        hueOfKeys = currentScale.hue;
        saturOfKeys = currentScale.saturation;
        brightOfKey = currentScale.brightness;
        loading = false;
        sessionIsSaved = true;
        
        [defaults setInteger:numberOfSplits forKey:     @"numberOfSplits"   ];
        [defaults setFloat:frequency        forKey:     @"frequency"        ];
        [defaults setFloat:hueOfKeys        forKey:     @"themeHue"         ];
        [defaults setFloat:saturOfKeys      forKey:     @"themeSat"         ];
        [defaults setFloat:brightOfKey      forKey:     @"themeBrg"         ];
        [defaults setBool:sessionIsSaved    forKey:     @"saved"            ];
        [defaults setInteger:indexOfFileLoading forKey: @"currentScaleIndex"];
        [defaults synchronize];
         
    }
    else if (sessionIsSaved){
        
        int currentScaleIndex = [defaults integerForKey:@"currentScaleIndex"];
        currentScale    = [NSKeyedUnarchiver unarchiveObjectWithData:archivedScales[currentScaleIndex]];
        savedStates     = [NSMutableArray arrayWithArray:currentScale.savedStates];
        numberOfSplits  = currentScale.splitsNumber;
        frequency       = currentScale.freqInitial;
        hueOfKeys       = currentScale.hue;
        saturOfKeys     = currentScale.saturation;
        brightOfKey     = currentScale.brightness;
        
    }
    else{
        numberOfSplits  =  [defaults integerForKey: @"numberOfSplits"   ];
        frequency       =  [defaults floatForKey:   @"frequency"        ];
        hueOfKeys       =  [defaults floatForKey:   @"themeHue"         ];
        saturOfKeys     =  [defaults floatForKey:   @"themeSat"         ];
        brightOfKey     =  [defaults floatForKey:   @"themeBrg"         ];
        
        int scalePositionInArray = [archivedScales count];
        [defaults setInteger:scalePositionInArray forKey:@"currentScaleIndex"];
        NSLog(@"Index passed %i",scalePositionInArray);
        
        [defaults synchronize];

        [savedStates removeAllObjects];
        savedStates     = [NSMutableArray array];
    }
    
    NSLog(@"Received %i splits, %4.1f Hz frequency",numberOfSplits, frequency);
    currentScale.freqInitial = frequency;
    currentScale.splitsNumber = numberOfSplits;
    currentScale.hue = hueOfKeys;
    currentScale.brightness = brightOfKey;
    currentScale.saturation = saturOfKeys;
    currentScale.savedStates = savedStates;
    if (sessionIsSaved) {
        [changeOctave setHidden:true];
        [frequencyLabel setHidden:true];
        saveButton.enabled = false;
    }
    [self.mainToolbar setBarTintColor:[UIColor colorWithHue:hueOfKeys saturation:(saturOfKeys/4) brightness:brightOfKey alpha:0.1]];

}

-(void)representStateSeleted{
    if (stateSelected){
        NSMutableArray *keysSelected = savedStates[indexOfStateChosen];

        for (MTGKeyObject *key in keysSelected){
            for(UIButton* button in keyboard){
                if (button.tag == key.index){
                    button.selected = true;
                    [pressedKeys addObject:key];
                }
            }
            [self playNoteLong:key.keyFrequency at:key.index];
            [startButtonItem setTitle:@"Stop polyphony"];
            
            creationState = true;
            if (indexOfStateChosen<([savedStates count]-1)) playNextStateButton.enabled = true;
            if (indexOfStateChosen>=([savedStates count]-1)) playNextStateButton.enabled = false;
            if (indexOfStateChosen>0) playPreviousStateButton.enabled = true;
            if (indexOfStateChosen==0) playPreviousStateButton.enabled = false;
        }
    }
}

- (void)viewDidUnload{
    [self clearUp];
    [super viewDidUnload];
    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)clearUp{
    for (UIButton* button in keyboard) button.selected = false;
    
    [patches     removeAllObjects];
    [pressedKeys removeAllObjects];
    
    for (int i = 0; i<=numberOfSplits; i++) [patches addObject:@"1"];
    
}

#pragma mark - buttons regulation
- (IBAction)polphonyStart:(id)sender {
    
    if (!creationState){
        [startButtonItem setTitle:@"Stop polyphony"];
        creationState = true;
        [changeOctave setHidden:YES];
    }
    else
    {
        [startButtonItem setTitle:@"Polyphony"];
        creationState = false;
        
        if (sessionIsSaved) saveButton.enabled = false;
        else [changeOctave setHidden:NO];

        playPreviousStateButton.enabled = false;
        playNextStateButton.enabled = false;
        [self clearUp];
    }
}

- (IBAction)playNextStateAction:(id)sender {
    indexOfStateChosen +=1;
    [self clearUp];
    [self representStateSeleted];
}

- (IBAction)playPreviousStateAction:(id)sender {
    indexOfStateChosen -=1;
    [self clearUp];
    [self representStateSeleted];
}

-(void)createButton:(int)index{

    MTGKeyButton* aButton =[[MTGKeyButton alloc]init];
    [aButton setTag:index];
    
    [aButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];

    NSString* title =[NSString stringWithFormat:@"%d", index];;
    [aButton setTitle:title forState:UIControlStateNormal];
    aButton.titleLabel.font =[UIFont fontWithName: @"Frangelica" size:30 ];
    
    aButton.hue = hueOfKeys;
    aButton.saturation = 0.1+saturOfKeys*(index+1)/((float)numberOfSplits+1);;
    aButton.brightness = brightOfKey;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat keyWidth, keyHeight, xPosition, yPosition;
    CGFloat difference = 0.5;
    NSInteger maxNoKeys = 9;
    CGFloat nRows = (numberOfSplits+1)/maxNoKeys+1;
    keyHeight = 3*(screenHeight/nRows)/4;

    if (numberOfSplits<maxNoKeys){
        keyWidth  = (screenWidth-difference*((numberOfSplits+1)*2))/(numberOfSplits+1);
    }
    else keyWidth  = (screenWidth-difference*((maxNoKeys)*2))/(maxNoKeys);

    yPosition = 120+(index/maxNoKeys)*(keyHeight+difference);
    xPosition = difference+(index%maxNoKeys)*(keyWidth+2*difference);
    aButton.frame = CGRectMake(xPosition, yPosition, keyWidth, keyHeight);

    [keyboard addObject:aButton];
    [self.view addSubview:aButton];
}

- (void)buttonClicked:(UIButton*)aButton{
    
    NSLog(@"Button %li clicked.",(long)[aButton tag]);
    
    float frequencyOfNote = calcFreqOfNote([aButton tag], numberOfSplits, frequency);
   
    MTGKeyObject *keyPressed = [[MTGKeyObject alloc]init];

    if (creationState){
        
        saveButton.enabled = true;

        if(!aButton.selected) {
            aButton.selected = true;
            [keyboard[[aButton tag]] isSelected];
            [self playNoteLong:frequencyOfNote at:[aButton tag]];
            
            keyPressed.index = [aButton tag];
            keyPressed.keyFrequency = frequencyOfNote;
            
            NSLog(@"Index %li, freq %f",(long)keyPressed.index, keyPressed.keyFrequency);
            [pressedKeys addObject:keyPressed];
        }
        else{
            NSLog(@"Patch removed with %li", (long)[aButton tag]);
            [patches removeObjectAtIndex:[aButton tag]];
            [pressedKeys removeObject:[NSNumber numberWithInteger:[aButton tag]]];
            [patches insertObject:@"1" atIndex:[aButton tag]];
            for (int i=0; i<[pressedKeys count];i++){
                keyPressed = pressedKeys[i];
                if (keyPressed.index == [aButton tag]) [pressedKeys removeObjectAtIndex:i];
            }
            aButton.selected =!aButton.selected;
            if ([pressedKeys count]==0 && sessionIsSaved) saveButton.enabled = false;
        }
    }
    else{
        [self playNoteShort:frequencyOfNote];
        aButton.selected = false;
        
    }
}

#pragma mark - button call back

-(void)playNoteLong:(float)f at:(NSInteger)index{
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        PdFile *patchOfKey = [PdFile openFileNamed:kTestPatchName path:bundlePath];
        if (patchOfKey) {
            NSLog(@"opened patch with $0 = %d", [patchOfKey dollarZero]);
            NSLog(@"Patches: %li", (unsigned long)[patches count]);
            [patches removeObjectAtIndex:index];
            [patches insertObject:patchOfKey atIndex:index];
        }
        else {
            NSLog(@"error: couldn't open patch");
        }
        [PdBase sendFloat:f toReceiver:[NSString stringWithFormat:@"%d-pitch", [patchOfKey dollarZero]]];
}

-(void)playNoteShort:(float)freqValue{
    
    [PdBase sendFloat:freqValue toReceiver:@"midinote"];
    [PdBase sendBangToReceiver:@"trigger"];
}

// right arrow when pressed takes us up an octave
- (IBAction)rightArrowPressed:(id)sender {
    if (frequency<=600){
        frequency =2*frequency;
        frequencyLabel.text = [NSString stringWithFormat:@"fo = %2.2f Hz", frequency];
        downTheOctave.enabled = true;
    }
    else upTheOctave.enabled= false;
}

- (IBAction)leftArrowPressed:(UIButton*)sender {
    if (frequency>200){
        upTheOctave.enabled = true;
        frequency=frequency/2;
        frequencyLabel.text = [NSString stringWithFormat:@"fo = %2.2f Hz", frequency];
    }
    else downTheOctave.enabled = false;
}

- (IBAction)saveState:(id)sender {
    
    saveButton.enabled = false;
    currentScale.dateUpdated = [NSDate date];

    NSMutableArray *keys =[NSMutableArray array];
    [keys addObjectsFromArray:pressedKeys];
    if (keys.count != 0 ) [savedStates addObject:keys];
    
    NSLog(@"States saved %@", savedStates);

    currentScale.savedStates = savedStates;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* archScales = [NSMutableArray array];
    NSData *encodedScale = [NSKeyedArchiver archivedDataWithRootObject:currentScale];

    archScales = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"savedSessions"]];
    
    if  (!sessionIsSaved){
        currentScale.freqInitial = frequency;
        currentScale.dateCreated = [NSDate date];
        [self takeScreenshot];
        sessionIsSaved = YES;
        [defaults setBool:sessionIsSaved forKey:@"saved"];
        [changeOctave setHidden:true];
        [frequencyLabel setHidden:true];
        
        NSData *encodedScale = [NSKeyedArchiver archivedDataWithRootObject:currentScale];

        [archScales addObject:encodedScale];
        [defaults setObject:archScales forKey:@"savedSessions"];
        sessionIsSaved = YES;
        
        if(keys.count>0)self.navigationItem.rightBarButtonItem.enabled = true;
        else self.navigationItem.rightBarButtonItem.enabled = false;
        [self clearUp];

        NSLog(@"Saved");
    }
    else {
        int indexOfScaleInTheArray = [defaults integerForKey:@"currentScaleIndex"];
        [archScales replaceObjectAtIndex:indexOfScaleInTheArray withObject:encodedScale];
    }
    [defaults setObject:archScales forKey:@"savedSessions"];
    
    NSLog(@"Saved state");
    [defaults synchronize];
    
    if(currentScale.savedStates.count>0)self.navigationItem.rightBarButtonItem.enabled = true;
    else self.navigationItem.rightBarButtonItem.enabled = false;
    
}

- (void)takeScreenshot {
    /** - define the dimensions of the screenshot */
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGSize size =  CGRectMake(10, 110, screenWidth , 7*screenHeight/8).size;
    /** - create the screenshot */
    UIGraphicsBeginImageContext(size);
    /** - put everything in the current view into the screenshot */
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    /** - save the current image context info into a UIImage */
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    /** - set the image of the session*/
    currentScale.imageOfScale = newImage;
}

@end
