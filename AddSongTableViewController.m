//
//  AddSongTableViewController.m
//  Crowdify
//
//  Created by Sony Theakanath on 7/8/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "AddSongTableViewController.h"
#import "InterfaceText.h"


@interface AddSongTableViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate>

@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTPlaylistSnapshot *currentPlaylist;
@property (nonatomic, strong)  NSArray *searchData;

@end

@implementation AddSongTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.searchData = [[NSMutableArray alloc] init];
        self.navigationItem.title = [@"Add Song" uppercaseString];
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void) addSession: (SPTSession*)session playlistName:(SPTPlaylistSnapshot*)playlist {
    self.session = session;
    self.currentPlaylist = playlist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.barStyle = UIBarStyleBlack;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    [self.searchDisplayController.searchResultsTableView setRowHeight:60];
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor blackColor]];
    [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableHeaderView = searchBar;
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [SPTRequest performSearchWithQuery:searchString queryType:SPTQueryTypeTrack offset:0 session:self.session callback:^(NSError *error, id object) {
        if(object != NULL) {
            self.searchData = ((SPTListPage*)object).items;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
    return YES;
}

#pragma mark - Table View Stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchData count];
    } else {
        return 0;
    }
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.currentPlaylist addTracksToPlaylist:[self.searchData objectAtIndex:indexPath.row] withSession:self.session callback:^(NSError *error, SPTPlaylistSnapshot *playlist) {
        if(error){
            NSLog(@"Adding song to playlist gives error%@", error);
       }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    SongCell *cell = (SongCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[SongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    } else {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        SPTTrack *track = [self.searchData objectAtIndex:indexPath.row];
        [cell.songText setText:track.name];
        SPTPartialArtist *trackartist = [track.artists objectAtIndex:0];
        [cell.artistText setText:[NSString stringWithFormat:@"%@ | %@", trackartist.name, track.album.name]];
    }
    return cell;
}

@end
