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
    	- manage a background picture
     */
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background1.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
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
            [self createKey: i];
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
    
    [startButtonItem setTitle:@"Polyphony"];
    creationState = false;
    saveButton.enabled = false;
    playPreviousStateButton.enabled = false;
    playNextStateButton.enabled = false;

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
    
    /**
    	- load settings of the app with NSUserDefaults class, which allows to save
     settings and properties related to application or user data.
    */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    currentScale = [[MTGSavedScale alloc]init];
    
    /**
    	- archivedSessions is an array stored in NSUserDefaults which contains all saved sessions
     */
    NSMutableArray *archivedSessions = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"savedSessions"]];
    sessionIsSaved = [defaults boolForKey:@"saved"];

    if (loading){
        
        NSLog(@"Index of file loading: %li",(long)indexOfFileLoading);
        currentScale = [NSKeyedUnarchiver unarchiveObjectWithData:archivedSessions[indexOfFileLoading]];
    
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
        
        NSInteger currentScaleIndex = [defaults integerForKey:@"currentScaleIndex"];
        currentScale    = [NSKeyedUnarchiver unarchiveObjectWithData:archivedSessions[currentScaleIndex]];
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
        
        NSInteger scalePositionInArray = [archivedSessions count];
        [defaults setInteger:scalePositionInArray forKey:@"currentScaleIndex"];
        NSLog(@"Index passed %li",(long)scalePositionInArray);
        
        [defaults synchronize];

        [savedStates removeAllObjects];
        savedStates     = [NSMutableArray array];
    }
    
    NSLog(@"Received %li splits, %4.1f Hz frequency",(long)numberOfSplits, frequency);
    
    /**
    	- set values for current scale
     */
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
    
    /**
        - set tint colour for the mainToolbar
     */
    [self.mainToolbar setBarTintColor:[UIColor colorWithHue:hueOfKeys saturation:(saturOfKeys/4) brightness:brightOfKey alpha:0.1]];

}

-(void)representStateSeleted{
    if (stateSelected){
        NSMutableArray *keysSelected = savedStates[indexOfStateChosen];

        for (MTGKeyButton *keyPressed in keysSelected){
            for(MTGKeyButton* aKey in keyboard){
                if (aKey.index == keyPressed.index){
                    aKey.selected = true;
                    [pressedKeys addObject:keyPressed];
                }
            }
            
            [self playNoteLong:keyPressed.frequency at:keyPressed.index];
        }
        [startButtonItem setTitle:@"Stop polyphony"];
        creationState = true;
        
        if (indexOfStateChosen<([savedStates count]-1)) playNextStateButton.enabled = true;
        if (indexOfStateChosen>=([savedStates count]-1)) playNextStateButton.enabled = false;
        if (indexOfStateChosen>0) playPreviousStateButton.enabled = true;
        if (indexOfStateChosen==0) playPreviousStateButton.enabled = false;
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

-(void)createKey:(int)index{

    MTGKeyButton* aKey =[[MTGKeyButton alloc]init];
    
    /**
    	- set title of the key
     */
    [aKey setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateNormal];
    
    /**
    	- add action buttonClicked
     */
    [aKey addTarget:self action:@selector(keyPressed:) forControlEvents:UIControlEventTouchDown];
    
    /**
    	- set colour and values for index and frequency
     */
    aKey.hue = hueOfKeys;
    aKey.saturation = 0.1+saturOfKeys*(index+1)/((float)numberOfSplits+1);;
    aKey.brightness = brightOfKey;
    aKey.index = index;
    aKey.frequency = calcFreqOfNote(index, numberOfSplits, frequency);
    /**
    	- set position, which is calculated for each key
     */
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
    aKey.frame = CGRectMake(xPosition, yPosition, keyWidth, keyHeight);

    /**
    	- add key to keyboard array and display on the screen
     */
    [keyboard addObject:aKey];
    [self.view addSubview:aKey];
}

- (void)keyPressed:(MTGKeyButton*)aKey{
    
    NSLog(@"Key %li clicked.",(long)aKey.index);
    
    if (creationState){
        saveButton.enabled = true;

        if(!aKey.selected){
            // when user select key in polyphony state (creationState) we should add this key to the array of pressedKeys
            aKey.selected = YES;
            [pressedKeys addObject:aKey];
            // 	sends a signal to PD to create sound with specified frequency which will continue until aKey pressed again
            [self playNoteLong:aKey.frequency at:aKey.index];
        }
        else{
            // when user press already selected key, the key should be decelected nd removed from pressedKeys
            aKey.selected = NO;
            [pressedKeys removeObject:aKey];
            // also the sound creation should be finished
            [patches removeObjectAtIndex:      aKey.index];
            [patches insertObject:@"1" atIndex:aKey.index];
            // user cannot save state when there are no pressed keys and session already saved
            if ([pressedKeys count]==0 && sessionIsSaved) saveButton.enabled = false;
        }
    }
    else [self playNoteShort:aKey.frequency]; //
}

#pragma mark - button call back

-(void)playNoteLong:(float)f at:(NSInteger)index{
    PdFile *patchOfKey = [PdFile openFileNamed:kTestPatchName path:[[NSBundle mainBundle] bundlePath]];
    
    if (patchOfKey) {
        NSLog(@"opened patch with $0 = %d", [patchOfKey dollarZero]);

        [patches removeObjectAtIndex:            index];
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


#pragma mark - octave movements
// right arrow when pressed takes us up an octave
- (IBAction)rightArrowPressed:(id)sender {
    if (frequency<=600){
        frequency =2*frequency;
        frequencyLabel.text = [NSString stringWithFormat:@"fo = %2.2f Hz", frequency];
        downTheOctave.enabled = true;
        for(MTGKeyButton* aKey in keyboard) aKey.frequency = calcFreqOfNote(aKey.index, numberOfSplits, frequency);
    }
    else upTheOctave.enabled= false;
}
// left arrow when pressed takes us down an octave
- (IBAction)leftArrowPressed:(UIButton*)sender {
    if (frequency>200){
        upTheOctave.enabled = true;
        frequency=frequency/2;
        frequencyLabel.text = [NSString stringWithFormat:@"fo = %2.2f Hz", frequency];
        for(MTGKeyButton* aKey in keyboard) aKey.frequency = calcFreqOfNote(aKey.index, numberOfSplits, frequency);
    }
    else downTheOctave.enabled = false;
}


#pragma mark - saving
- (IBAction)saveState:(id)sender {
    
    saveButton.enabled = false;
    currentScale.dateUpdated = [NSDate date];

    NSMutableArray *keys =[NSMutableArray array];
    [keys addObjectsFromArray:pressedKeys];
    if (keys.count != 0 ) [savedStates addObject:keys];
    
    NSLog(@"States saved %@", savedStates);

    currentScale.savedStates = savedStates;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* archSessions = [NSMutableArray array];
    NSData *encodedSession = [NSKeyedArchiver archivedDataWithRootObject:currentScale];

    archSessions = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"savedSessions"]];
    
    if  (!sessionIsSaved){
        currentScale.freqInitial = frequency;
        currentScale.dateCreated = [NSDate date];
        [self takeScreenshot];
        sessionIsSaved = YES;
        [defaults setBool:sessionIsSaved forKey:@"saved"];
        [changeOctave setHidden:true];
        [frequencyLabel setHidden:true];
        
        NSData *encodedScale = [NSKeyedArchiver archivedDataWithRootObject:currentScale];

        [archSessions addObject:encodedScale];
        [defaults setObject:archSessions forKey:@"savedSessions"];
        sessionIsSaved = YES;
        
        if(keys.count>0)self.navigationItem.rightBarButtonItem.enabled = true;
        else self.navigationItem.rightBarButtonItem.enabled = false;
        [self clearUp];

        NSLog(@"Saved session");
    }
    else {
        NSInteger indexOfScaleInTheArray = [defaults integerForKey:@"currentScaleIndex"];
        [archSessions replaceObjectAtIndex:indexOfScaleInTheArray withObject:encodedSession];
    }
    [defaults setObject:archSessions forKey:@"savedSessions"];
    
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
