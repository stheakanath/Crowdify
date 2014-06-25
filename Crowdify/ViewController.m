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
@property (nonatomic, strong) SPTSession *session;

//Interface buttons
@property (nonatomic, strong) SpotifyButton *linkspotifybutton;
@property (nonatomic, strong) SpotifyButton *linkomletbutton;


@property (nonatomic, strong) NSArray *items;

@end

@implementation ViewController

#pragma Spotify Authentation Methods

-(void)handleNewSession:(SPTSession *)session {
    self.session = session;

	if (self.trackPlayer == nil) {
		self.trackPlayer = [[SPTTrackPlayer alloc] initWithCompanyName:@"Spotify" appName:@"SimplePlayer"];
		self.trackPlayer.delegate = self;

	}
	[self.trackPlayer enablePlaybackWithSession:session callback:^(NSError *error) {
		if (error != nil) {
			NSLog(@"*** Enabling playback got error: %@", error);
			return;
		}
        [SPTRequest playlistsForUserInSession:session callback:^(NSError *error, id object) {
            SPTPlaylistList *playlist = object;
            _items = playlist.items;
            [playlistitems reloadData];
        }];

		/**[SPTRequest requestItemAtURI:[NSURL URLWithString:@"spotify:album:5aLY2ivPGXvFX770ihBnmd"] withSession:session callback:^(NSError *error, id object) {
            if (error != nil) {
                NSLog(@"*** Album lookup got error %@", error);
                return;
            }
            [self.trackPlayer playTrackProvider:(id <SPTTrackProvider>)object];
        }]; */
	}];
}

#pragma mark - Table Views

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    static NSString *MyIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    } else {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    
    UILabel *articlename = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0, screenWidth-40 , 60)];
    [articlename setBackgroundColor:[UIColor clearColor]];
    [articlename setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:17]];
    NSLog(@"%ld", (long)indexPath.row);
    [articlename setText: [NSString stringWithFormat:@"%@", [_items objectAtIndex:indexPath.row]]];
    [articlename setTextColor:[UIColor whiteColor]];
    [articlename setShadowColor:[UIColor blackColor]];
    [articlename setShadowOffset:CGSizeMake(1, 0)];
    articlename.numberOfLines = 0;
    [cell.contentView addSubview:articlename];
    
    cell.backgroundColor = [UIColor blackColor];
   /* UIImageView *bkgndimage =  [[UIImageView alloc] initWithImage:object.image];
    bkgndimage.contentMode = UIViewContentModeScaleAspectFill;
    cell.backgroundView = bkgndimage;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundView.clipsToBounds = YES;
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, bkgndimage.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [bkgndimage addSubview:overlay];
    
    UILabel *articlename = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 30, screenWidth-40 , 60)];
    [articlename setBackgroundColor:[UIColor clearColor]];
    [articlename setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:40]];
    [articlename setText:object.title];
    [articlename setTextColor:[UIColor whiteColor]];
    [articlename setShadowColor:[UIColor blackColor]];
    [articlename setShadowOffset:CGSizeMake(1, 0)];
    articlename.lineBreakMode = NSLineBreakByWordWrapping;
    articlename.numberOfLines = 0;
    [cell.contentView addSubview:articlename];
    
     UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 74.0, screenWidth-40 , 60)];
     [date setBackgroundColor:[UIColor clearColor]];
     [date setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20]];
     [date setText:[NSString stringWithFormat:@"Region: %@", object.wineregion]];
     [date setTextColor:[UIColor whiteColor]];
     [date setShadowColor:[UIColor blackColor]];
     [date setShadowOffset:CGSizeMake(1, 0)];
     date.lineBreakMode = NSLineBreakByWordWrapping;
     date.numberOfLines = 0;
     [cell.contentView addSubview:date];
    
    UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 47.0, screenWidth-40 , 60)];
    [author setBackgroundColor:[UIColor clearColor]];
    [author setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:22]];
    // [author setText:[NSString stringWithFormat:@"Distance: %@%@", object.author, @" miles"]];
    [author setText:[NSString stringWithFormat:@""]];
    [author setTextColor:[UIColor whiteColor]];
    [author setShadowColor:[UIColor blackColor]];
    [author setShadowOffset:CGSizeMake(1, 0)];
    author.lineBreakMode = NSLineBreakByWordWrapping;
    author.numberOfLines = 0;
    [cell.contentView addSubview:author];
    
    UIView *category = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 125)];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:object.dateposted];
    double ratingnum = [myNumber doubleValue];
    if(ratingnum < 4 && ratingnum > 2.5)
        category.backgroundColor = [UIColor colorWithRed:0 green:0.47 blue:0.725 alpha:1.0];
    else if(ratingnum <= 2.5)
        category.backgroundColor = [UIColor colorWithRed:0.752 green:0.12 blue:0.15 alpha:1.0];
    else
        category.backgroundColor = [UIColor colorWithRed:0.254 green:0.678 blue:0.286 alpha:1.0];
    [cell.contentView addSubview:category];
    
    */
    return cell;
}

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    RSSItem *object = self.listofwineries[indexPath.row];
    [infoController setDetailItem:object];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:infoController animated:YES];
}*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}



#pragma Interface Methods

- (void) setUpNavigationController {
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0]];
    [shadow setShadowOffset: CGSizeMake(0.0f, -1.0f)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName:shadow, NSFontAttributeName:[UIFont fontWithName:@"ProximaNova-Regular" size:20.0] };
    self.navigationItem.title = @"CROWDIFY";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:50/255.0f green:50/255.0f blue:50/255.0f alpha:1.0f];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = @"CROWDIFY";
}

- (void) setUpInterface {
    self.view.backgroundColor = [UIColor blackColor];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    [self setUpNavigationController];
    
    _linkspotifybutton = [[SpotifyButton alloc] initWithFrame:CGRectMake(80.0, 210.0, 160.0, 40.0)];
    [_linkspotifybutton setTitle:@"Link Spotify" forState:UIControlStateNormal];
    [self.view addSubview:_linkspotifybutton];
    
    _linkomletbutton = [[SpotifyButton alloc] initWithFrame:CGRectMake(80.0, 300.0, 160.0, 40.0)];
    [_linkomletbutton setTitle:@"Link Omlet" forState:UIControlStateNormal];
    [self.view addSubview:_linkomletbutton];
    
    if([self.session isValid]) {
        [_linkspotifybutton setTitle:@"Spotify Linked! \u2713" forState:UIControlStateNormal];
        [_linkspotifybutton setHidden:YES];
        [_linkomletbutton setHidden:YES];
        
        playlistitems = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 400)];
        playlistitems.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        playlistitems.delegate = self;
        playlistitems.dataSource = self;
        [playlistitems setSeparatorInset:UIEdgeInsetsZero];
        playlistitems.scrollEnabled = YES;
        [playlistitems reloadData];
        playlistitems.tableFooterView.hidden = YES;
        [self.view addSubview:playlistitems];
    }
 
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
