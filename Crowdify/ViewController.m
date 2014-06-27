//
//  ViewController.m
//  Crowdify
//
//  Created by Sony Theakanath on 6/23/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "ViewController.h"
#import "SpotifyButton.h"
#import "AudioController.h"
#import "InterfaceText.h"

@interface ViewController () <SPTTrackPlayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) SPTTrackPlayer *trackPlayer;
@property (nonatomic, strong) SPTSession *session;

//Interface buttons
@property (nonatomic, strong) SpotifyButton *linkspotifybutton;
@property (nonatomic, strong) SpotifyButton *linkomletbutton;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) SPTPlaylistSnapshot *currentPlaylist;

@end

@implementation ViewController

#pragma Spotify Authentation Methods


//To do: Handle multiple pages and add on.
-(void)handleNewSession:(SPTSession *)session {
    self.session = session;
    [self moveToPlaylistScreen];
    
    [SPTRequest playlistsForUserInSession:session callback:^(NSError *error, SPTPlaylistList *_playlists) {
        SPTPartialPlaylist *partial = [_playlists.items objectAtIndex:2]; //Just pulling a random playlist
        [SPTRequest requestItemAtURI:partial.uri withSession:session callback:^(NSError *error, id object) {
            SPTPlaylistSnapshot *playlist = (SPTPlaylistSnapshot*)object;
            NSLog(@"%@", playlist.firstTrackPage);
            _currentPlaylist = playlist;
            _items = playlist.firstTrackPage.items;
            self.navigationItem.title = [playlist.name uppercaseString];
            [playlistitems reloadData];
        }];
	}];
}

#pragma mark - Table Views

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    } else {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    cell.backgroundColor = [UIColor blackColor];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(15, 60, screenWidth-35, 0.5)];
    separator.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:separator];
    
    SPTTrack *track = [_items objectAtIndex:indexPath.row];
    InterfaceText *trackname = [[InterfaceText alloc] initWithFrame:CGRectMake(20.0, 0, screenWidth-40 , 50) initwithFontSize: 16 initWithLabelText:track.name initwithFormatting:NSTextAlignmentLeft withColor:[UIColor whiteColor]];
    [cell.contentView addSubview:trackname];
    
    SPTPartialArtist *trackartist = [track.artists objectAtIndex:0];
    InterfaceText *artistname = [[InterfaceText alloc] initWithFrame:CGRectMake(20.0, 20, screenWidth-40 , 50) initwithFontSize: 13 initWithLabelText:[NSString stringWithFormat:@"%@ | %@", trackartist.name, track.album.name] initwithFormatting:NSTextAlignmentLeft withColor:[UIColor grayColor]];
    [cell.contentView addSubview:artistname];
    

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.trackPlayer == nil) {
		self.trackPlayer = [[SPTTrackPlayer alloc] initWithCompanyName:@"Spotify" appName:@"SimplePlayer"];
		self.trackPlayer.delegate = self;
	}
	[self.trackPlayer enablePlaybackWithSession:_session callback:^(NSError *error) {
		if (error != nil) {
			NSLog(@"*** Enabling playback got error: %@", error);
			return;
		}
        [self.trackPlayer playTrackProvider: _currentPlaylist fromIndex: indexPath.row];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        AudioController *bottomcontroller = [[AudioController alloc] initWithFrame:CGRectMake(0, screenHeight-50, screenWidth, 50) initWithPlayer:_trackPlayer];
        [self.view addSubview:bottomcontroller];
	}];
    [playlistitems deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}



#pragma Interface Methods

- (void) setUpNavigationController {
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0]];
    [shadow setShadowOffset: CGSizeMake(0.0f, -1.0f)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName:shadow, NSFontAttributeName:[UIFont fontWithName:@"ProximaNova-Regular" size:18.0] };
    self.navigationItem.title = @"CROWDIFY";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:23/255.0f green:23/255.0f blue:23/255.0f alpha:1.0f];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = @"CROWDIFY";
}

- (void) setUpInterface {
    self.view.backgroundColor = [UIColor blackColor];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [self setUpNavigationController];
    
    _linkspotifybutton = [[SpotifyButton alloc] initWithFrame:CGRectMake(80.0, 210.0, 160.0, 40.0)];
    [_linkspotifybutton setTitle:@"Link Spotify" forState:UIControlStateNormal];
    [self.view addSubview:_linkspotifybutton];
    
    _linkomletbutton = [[SpotifyButton alloc] initWithFrame:CGRectMake(80.0, 300.0, 160.0, 40.0)];
    [_linkomletbutton setTitle:@"Link Omlet" forState:UIControlStateNormal];
    [self.view addSubview:_linkomletbutton];
    
    if([self.session isValid]) {
        [self moveToPlaylistScreen];
    }

}

-(void) moveToPlaylistScreen {
    [_linkspotifybutton setTitle:@"Spotify Linked! \u2713" forState:UIControlStateNormal];
    [_linkspotifybutton setHidden:YES];
    [_linkomletbutton setHidden:YES];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    playlistitems = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64)];
    playlistitems.delegate = self;
    playlistitems.dataSource = self;
    playlistitems.scrollEnabled = YES;
    [playlistitems reloadData];
    [playlistitems setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:playlistitems];
}

- (void)viewDidLoad {
    [self setUpInterface];
    [self setNeedsStatusBarAppearanceUpdate];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
