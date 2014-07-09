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

//To do: Handle multiple pages and add on.
-(void)handleNewSession:(SPTSession *)session {
    [self moveToPlaylistScreen];
    [SPTRequest playlistsForUserInSession:session callback:^(NSError *error, SPTPlaylistList *_playlists) {
        SPTPartialPlaylist *partial = [_playlists.items objectAtIndex:1]; //Just pulling a random playlist
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
            } else {
                NSLog(@"%@", partial);
                NSLog(@"%@", session);
                NSLog(@"THIS ERROR %@", error);
            }
        }];
	}];
}

-(IBAction)addSong:(id)sender {
    AddSongTableViewController* addsongscreen = [[AddSongTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [addsongscreen addSession:self.session playlistName:self.currentPlaylist];
    [self.navigationController pushViewController:addsongscreen animated:YES];
}

-(void)addTheSession:(SPTSession *)session {
    NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sessionData forKey:@"SpotifySession"];
    [userDefaults synchronize];
    self.session = session;
}

#pragma mark - Table Views

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

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
            playlistitems.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-114);
            [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.bottomcontroller.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-50, [[UIScreen mainScreen] bounds].size.width, 50);
            } completion:nil];
        } else {
            [self.bottomcontroller updateAudioPlayer];
        }
	}];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60; }

#pragma Interface Methods

- (void) setUpNavigationController {
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0]];
    [shadow setShadowOffset: CGSizeMake(0.0f, -1.0f)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName:shadow, NSFontAttributeName:[UIFont fontWithName:@"ProximaNova-Regular" size:18.0] };
    self.navigationItem.title = @"CROWDIFY";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:23/255.0f green:23/255.0f blue:23/255.0f alpha:1.0f];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.title = @"CROWDIFY";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSong:)];

}


-(void) moveToPlaylistScreen {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pageViewController.view.alpha = 0;
        self.pageViewController.view.transform = CGAffineTransformMakeScale(2,2);
    } completion:^ (BOOL finished) {
        playlistitems = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64)];
        playlistitems.delegate = self;
        playlistitems.dataSource = self;
        [playlistitems setBackgroundColor:[UIColor blackColor]];
        [playlistitems setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:playlistitems];
        self.refresh = [[RefresherView alloc] init];
        [self.view addSubview:self.refresh];
     }];

}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor blackColor];
    [self setUpNavigationController];
    [self setNeedsStatusBarAppearanceUpdate];
    [super viewDidLoad];
    _pageImages = @[@"page1.png", @"page2.png"];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.items = [NSMutableArray array];
    if([self.session isValid]) {
        [self moveToPlaylistScreen];
    }
}

- (IBAction)startWalkthrough:(id)sender {
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageImages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
