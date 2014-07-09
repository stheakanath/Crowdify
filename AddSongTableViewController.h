//
//  AddSongTableViewController.h
//  Crowdify
//
//  Created by Sony Theakanath on 7/8/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongCell.h"
#import <Spotify/Spotify.h>

@interface AddSongTableViewController : UITableViewController {
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

-(void) addSession:(SPTSession*)session playlistName:(SPTPlaylistSnapshot*)playlist;

@end
