//
//  MTGCreateNewViewController.h
//  Microtonal Tones Generator
//
//  Created by Anna on 15/10/2014.
//  Copyright (c) 2014 Anna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGColoursViewController.h"

#import "MTGKeyButton.h"

@interface MTGCreateNewViewController : UIViewController <UIPopoverControllerDelegate, MTGColoursViewControllerDelegate>

@property NSArray *colorCollection /** array containing primary colours */;
@property (strong, nonatomic) IBOutlet MTGKeyButton *colourButton /** each button represent one colour from colorCollection*/;
@property (nonatomic, strong) NSArray* colorButtons /** array of colourButton */;
@property (strong, nonatomic) IBOutlet MTGKeyButton *chooseTheme /** button which represents colour chosen, when pressed opens popoverController */;
@property (nonatomic,retain) UIPopoverController *popoverController /** view which represents a colour wheel */;

@property BOOL menuCalled /** boolean value which shows if either of menus was called */;
@property CGFloat colourHue /** hue of the color chosen */;
@property CGFloat colourSat /** saturation of the color chosen */;
@property CGFloat colourBrg /** brightness of the color chosen */;

@property IBOutletCollection(UIButton) NSArray *freqButtons /** fiven frequency buttons*/;
@property IBOutlet UILabel *frequencyLabel /** label representing frequency chosen */;
@property CGFloat frequency /** initial frequency chosen by user */;
@property (strong, nonatomic) IBOutlet UITextField *freqTextField /** field allowing to input custom frequency */;

@property NSInteger split /** number of splits chosen */;
@property  IBOutlet UILabel *splitLabel /** label representing split chosen */;

@property (strong, nonatomic) IBOutlet UIButton *continueButton /** button which is when pressed pass user to MTGViewController */;

@property (strong, nonatomic) IBOutlet UIView *ViewCover /** view on the top of View Controller of a size of iPad screen that, if menu is called, covers the view */;

/**
	Method called after the view controller has loaded its view hierarchy into memory.
    In this method all main initialization is performed:
	@returns nothing
 */
- (void)viewDidLoad;
/**
    Sets up SWRevealViewController to be called
 */
- (void)setupMenuRevelation;
/**
	calls for SWRevealViewController to open left menu - MTGSidebarTableViewController
    also turns off all sound production and releasing all keys pressed
    makes ViewCover visible, so it covers all view 
 */
-(void)openLeftMenu;
/**
	shows colour popup
*/
- (IBAction)showColourPopup:(id)sender;

/**
	receive information from popup
 */
-(void)colorPopoverControllerDidSelectColor:(UIColor*) colour;

/**
	set up color buttons
 */
-(void)setupColorButtons;

/**
   when colour button pressed color is chosen
 */
-(void)chooseColor:(MTGKeyButton *)button;

/**
	sets color from popover to chooseTheme button
	@param color colour chosen in popover
 */
-(void)setColor:(UIColor*)color;
/**
	fills array of colours - colorCollection - with basic colors
 */
-(void) createColorsArray;
/**
	instanly resieves the change in value in slider
	@param slider slider with int values from 1 to 32
 */
- (IBAction)splitInputChanged:(UISlider *)slider;
/**
	recieves the input from text field and saves it in float value to frequency
 */
- (IBAction)frequencyInputTxtField:(id)sender;
/**
	if user start inputing frequency in text field no frequency buttons should be selected therefore they are all released on the action
 */
- (IBAction)releaseFreqBts:(id)sender;
/**
	dismiss the keyboard when user tap outside the textfield
 */
-(void)dismissKeyboard;
/**
	check if frequency is float and is between 100 and 600
 */
- (void)validateFreq;
/**
    action of the button continueButton that pushes to MTGViewController
 */
- (IBAction)createIt:(id)sender;

@end
