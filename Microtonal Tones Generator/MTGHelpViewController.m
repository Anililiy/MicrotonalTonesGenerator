//
//  MTGHelpViewController.m
//  Microtonal Tones Generator
//
//  Created by Anna on 03/02/2015.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "MTGHelpViewController.h"
#import "SWRevealViewController.h"

@interface MTGHelpViewController ()

@end

@implementation MTGHelpViewController
@synthesize text;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupMenuRevelation];
    if (text)_helpTextView.text =text;
    else [self playMovie];
    NSLog(@"\n");
    NSLog(@"Help is opened");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMenuRevelation{
    /** - allocates Navigation Item Bar Buttons to open and show menus */
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        UIBarButtonItem *barBtnMenu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openLeftMenu)];
        barBtnMenu.tintColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
        
        self.navigationItem.leftBarButtonItem = barBtnMenu;
        
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

-(void)openLeftMenu{
    SWRevealViewController *reveal = self.revealViewController;
    [reveal revealToggleAnimated:YES];
}
-(void)playMovie
{
    // NSURL *url = [NSURL URLWithString:@"http://www.ebookfrenzy.com/ios_book/movie/movie.mov"];
    NSURL *url= [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"App Preview" ofType:@"mp4"]];
    _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    _moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    _moviePlayer.shouldAutoplay = NO;
    _moviePlayer.backgroundView.backgroundColor = [UIColor clearColor];
    
    
    _moviePlayer.view.frame = CGRectMake(10, 400, self.view.bounds.size.width/3, self.view.bounds.size.height/3);
    
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

@end
