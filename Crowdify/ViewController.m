//
//  ViewController.m
//  Crowdify
//
//  Created by Sony Theakanath on 6/23/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <SPTTrackPlayerDelegate>

@property (nonatomic, strong) SPTTrackPlayer *trackPlayer;
@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) SPTPlaylistSnapshot *currentPlaylist;
@property (nonatomic, strong) RefresherView *refresh;
@property (nonatomic, strong) AudioController *bottomcontroller;

@end

@implementation ViewController

#pragma mark - Spotify Authentation

-(void)handleNewSession:(SPTSession *)session playlist:(SPTPartialPlaylist*)partialplaylist {
    [self moveToPlaylistScreen];
    NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sessionData forKey:@"SpotifySession"];
    [userDefaults synchronize];
    self.session = session;
    SPTPartialPlaylist *partial = partialplaylist;
    [SPTRequest requestItemAtURI:partial.uri withSession:session callback:^(NSError *error, id object) {
        if(object != NULL) {
            SPTPlaylistSnapshot *playlist = (SPTPlaylistSnapshot*)object;
            NSLog(@"%@", playlist);
            _currentPlaylist = playlist;
            [playlist.firstTrackPage requestNextPageWithSession:session callback:^(NSError *error, id object) {
                [playlist.firstTrackPage pageByAppendingPage:object];
                [_items addObjectsFromArray:playlist.firstTrackPage.items];
                SPTListPage *incomplete = object;
                [_items addObjectsFromArray:incomplete.items];
                self.navigationItem.title = [playlist.name uppercaseString];
                [playlistitems reloadData];
                [self.refresh removeFromSuperview];
            }];
            [self.refresh removeFromSuperview];
        } else {
            NSLog(@"THIS ERROR %@", error);
        }
    }];
}

-(IBAction)addSong:(id)sender {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    AddSongTableViewController* addsongscreen = [[AddSongTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [addsongscreen addSession:self.session playlistName:self.currentPlaylist];
    [self.navigationController pushViewController:addsongscreen animated:YES];
}

#pragma mark - Table Views

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongCell *cell = (SongCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil){
        cell = [[SongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    } else {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    SPTTrack *track = [_items objectAtIndex:indexPath.row];
    [cell.songText setText:track.name];
    SPTPartialArtist *trackartist = [track.artists objectAtIndex:0];
    [cell.artistText setText:[NSString stringWithFormat:@"%@ | %@", trackartist.name, track.album.name]];
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [playlistitems deselectRowAtIndexPath:indexPath animated:YES];
    if (self.trackPlayer == nil) {
		self.trackPlayer = [[SPTTrackPlayer alloc] initWithCompanyName:@"Spotify" appName:@"SimplePlayer"];
		self.trackPlayer.delegate = self;
	}
	[self.trackPlayer enablePlaybackWithSession:_session callback:^(NSError *error) {
		if (error != nil) {
			NSLog(@"*** Enabling playback got error: %@", error);
			return;
		}
        [self.trackPlayer playTrackProvider: self.currentPlaylist fromIndex: indexPath.row];
        if(self.bottomcontroller == nil) {
             self.bottomcontroller = [[AudioController alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 50) initWithPlayer:_trackPlayer];
             [self.view addSubview:self.bottomcontroller];
            playlistitems.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-50);
            [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.bottomcontroller.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-50, [[UIScreen mainScreen] bounds].size.width, 50);
            } completion:nil];
        } else {
            [self.bottomcontroller updateAudioPlayer];
        }
	}];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60; }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return _items.count; }

#pragma Interface Methods

-(void) moveToPlaylistScreen {
    playlistitems = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    playlistitems.delegate = self;
    playlistitems.dataSource = self;
    [playlistitems setBackgroundColor:[UIColor blackColor]];
    [playlistitems setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:playlistitems];
    self.refresh = [[RefresherView alloc] init];
    [self.view addSubview:self.refresh];
}

- (void)viewDidLoad {
    self.title = @"LOADING...";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSong:)];
    self.view.backgroundColor = [UIColor blackColor];
    [super viewDidLoad];
    self.items = [NSMutableArray array];
}

@end
