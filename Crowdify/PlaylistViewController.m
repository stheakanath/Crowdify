//
//  PlaylistViewController.m
//  Crowdify
//
//  Created by Sony Theakanath on 7/10/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "PlaylistViewController.h"
#import "ViewController.h"

@interface PlaylistViewController ()

@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) RefresherView *refresh;

@end

@implementation PlaylistViewController

-(void)handleNewSession:(SPTSession *)session {
    [self moveToPlaylistScreen];
    [SPTRequest playlistsForUserInSession:session callback:^(NSError *error, SPTPlaylistList *playlists) {
        if(!error) {
            [self.items addObjectsFromArray:playlists.items];
            self.navigationItem.title = [@"Playlists" uppercaseString];
            [playlistitems reloadData];
            [self.refresh removeFromSuperview];
        }
    }];
}

-(void)addTheSession:(SPTSession *)session {
    NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sessionData forKey:@"SpotifySession"];
    [userDefaults synchronize];
    self.session = session;
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
   SPTPartialPlaylist *playlist = (SPTPartialPlaylist*)[self.items objectAtIndex:indexPath.row];
   [cell.songText setText:playlist.name];
   [cell.artistText setText:[NSString stringWithFormat:@"%i tracks | Owner: %@", playlist.trackCount, playlist.owner.displayName]];
    //Need SPTAuthUserReadPrivateScope scope.
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [playlistitems deselectRowAtIndexPath:indexPath animated:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    ViewController* playlistScreen = [[ViewController alloc] init];
    [playlistScreen handleNewSession:self.session playlist:[_items objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:playlistScreen animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60; }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return _items.count; }

- (void)viewDidLoad {
    self.title = @"CROWDIFY";
    self.view.backgroundColor = [UIColor blackColor];
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

#pragma mark - Page View Controller Data Source

- (IBAction)startWalkthrough:(id)sender {
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound))
        return nil;
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if (index == NSNotFound)
        return nil;
    index++;
    if (index == [self.pageImages count])
        return nil;
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count]))
        return nil;
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


@end
