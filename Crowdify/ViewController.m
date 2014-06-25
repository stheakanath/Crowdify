//
//  ViewController.m
//  Crowdify
//
//  Created by Sony Theakanath on 6/23/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "ViewController.h"
#import "SpotifyButton.h"
#import "InterfaceText.h"

@interface ViewController () <SPTTrackPlayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) SPTTrackPlayer *trackPlayer;

//Interface buttons
@property (nonatomic, strong) SpotifyButton *linkspotifybutton;
@property (nonatomic, strong) SpotifyButton *linkomletbutton;

@end

@implementation ViewController

#pragma Spotify Authentation Methods

-(void)handleNewSession:(SPTSession *)session {
    [_linkspotifybutton setTitle:@"Spotify Linked! \u2713" forState:UIControlStateNormal];
    [_linkspotifybutton setEnabled:NO];
	if (self.trackPlayer == nil) {
		self.trackPlayer = [[SPTTrackPlayer alloc] initWithCompanyName:@"Spotify" appName:@"SimplePlayer"];
		self.trackPlayer.delegate = self;

	}
	[self.trackPlayer enablePlaybackWithSession:session callback:^(NSError *error) {
		if (error != nil) {
			NSLog(@"*** Enabling playback got error: %@", error);
			return;
		}
		[SPTRequest requestItemAtURI:[NSURL URLWithString:@"spotify:album:5aLY2ivPGXvFX770ihBnmd"] withSession:session callback:^(NSError *error, id object) {
            if (error != nil) {
                NSLog(@"*** Album lookup got error %@", error);
                return;
            }
            [self.trackPlayer playTrackProvider:(id <SPTTrackProvider>)object];
        }];
	}];
}

#pragma Interface Methods

- (void) setUpInterface {
    self.view.backgroundColor = [UIColor blackColor];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    InterfaceText *welcometext = [[InterfaceText alloc] initWithFrame:CGRectMake(0, 0.0, screenWidth, 60) initwithFontSize:20 initWithLabelText:@"CROWDIFY"];
    [self.view addSubview:welcometext];
    
    _linkspotifybutton = [[SpotifyButton alloc] initWithFrame:CGRectMake(80.0, 210.0, 160.0, 40.0)];
    [_linkspotifybutton setTitle:@"Link Spotify" forState:UIControlStateNormal];
    [self.view addSubview:_linkspotifybutton];
    
    _linkomletbutton = [[SpotifyButton alloc] initWithFrame:CGRectMake(80.0, 300.0, 160.0, 40.0)];
    [_linkomletbutton setTitle:@"Link Omlet" forState:UIControlStateNormal];
    [self.view addSubview:_linkomletbutton];
    
 
}

- (void)viewDidLoad
{
    [self setUpInterface];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
