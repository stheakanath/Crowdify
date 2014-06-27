//
//  AudioController.m
//  Crowdify
//
//  Created by Sony Theakanath on 6/26/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "AudioController.h"
#import "InterfaceText.h"


@interface AudioController () <SPTTrackPlayerDelegate>

@property (nonatomic, strong) SPTTrackPlayer *trackPlayer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) IBOutlet UIImageView *coverView;
@property (strong, nonatomic) IBOutlet InterfaceText *songname;
@property (strong, nonatomic) IBOutlet InterfaceText *artistname;
@property (strong, nonatomic) IBOutlet UIButton *playbutton;

@end

BOOL pauseorplay;
CGRect screenRect;
CGFloat screenWidth;
CGFloat screenHeight;


@implementation AudioController

- (id)initWithFrame:(CGRect)frame initWithPlayer: (SPTTrackPlayer*)player
{
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    _trackPlayer = player;
    self.trackPlayer.delegate = self;
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor blackColor]];
    _songname = [[InterfaceText alloc] initWithFrame:CGRectMake(60, 2, screenWidth-120, 30) initwithFontSize:15 initWithLabelText:@"" initwithFormatting:NSTextAlignmentLeft withColor:[UIColor whiteColor]];
    _artistname = [[InterfaceText alloc] initWithFrame:CGRectMake(60, 20, screenWidth-120 , 30) initwithFontSize: 12 initWithLabelText:@"" initwithFormatting:NSTextAlignmentLeft withColor:[UIColor grayColor]];
    [self addSubview:_songname];
    [self addSubview:_artistname];
    _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _coverView.image = nil;
    [self addSubview:_coverView];
    [self createPlayButton];
    if (self) {
        [self updateAudioPlayer];
    }
    return self;
}

-(void)trackPlayer:(SPTTrackPlayer *)player didStartPlaybackOfTrackAtIndex:(NSInteger)index ofProvider:(id <SPTTrackProvider>)provider {
    NSLog(@"next song");
	[self updateAudioPlayer];
}

- (void) updateAudioPlayer {
    SPTPlaylistSnapshot *currentsnap = (SPTPlaylistSnapshot*) self.trackPlayer.currentProvider;
    SPTTrack *currenttrack = [currentsnap.firstTrackPage.items objectAtIndex:[self.trackPlayer indexOfCurrentTrack]];
    
    // Album Cover -- Set another function for this later
    NSURL *imageURL = (NSURL *)currenttrack.album.largestCover.imageURL;
    if (imageURL == nil) {
        NSLog(@"Album doesn't have any images!");
        _coverView.image = nil;
        [_trackPlayer skipToNextTrack];
    } else {

        //Name
        [_songname setText:currenttrack.name];
        [_artistname setText:[NSString stringWithFormat:@"%@ | %@", currenttrack.name, currenttrack.album.name]];
        [self.spinner startAnimating];
        
        // Pop over to a background queue to load the image over the network.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSError *error = nil;
            UIImage *image = nil;
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL options:0 error:&error];
            
            if (imageData != nil) {
                image = [UIImage imageWithData:imageData];
            }
            
            // …and back to the main queue to display the image.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner stopAnimating];
                _coverView.image = image;
                if (image == nil) {
                    NSLog(@"Couldn't load cover image with error: %@", error);
                }
            });
        });
    }

}

- (void) createPlayButton {
    pauseorplay = TRUE;
    _playbutton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-40, 10, 30, 30)];
    UIImage *btnImage = [UIImage imageNamed:@"pausebutton.png"];
    [_playbutton addTarget:self action:@selector(clickpause:) forControlEvents:UIControlEventTouchUpInside];
    [_playbutton setImage:btnImage forState:UIControlStateNormal];
    [self addSubview:_playbutton];
}

- (IBAction)clickpause:(id)sender {
    if(pauseorplay == TRUE) {
        [_trackPlayer pausePlayback];
        pauseorplay = false;
        UIImage *btnImage = [UIImage imageNamed:@"playbutton.png"];
        [_playbutton setImage:btnImage forState:UIControlStateNormal];
    } else {
        [_trackPlayer resumePlayback];
        pauseorplay = TRUE;
        UIImage *btnImage = [UIImage imageNamed:@"pausebutton.png"];
        [_playbutton setImage:btnImage forState:UIControlStateNormal];
    }
}

@end
