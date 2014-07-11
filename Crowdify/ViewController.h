//
//  ViewController.h
//  Crowdify
//
//  Created by Sony Theakanath on 6/23/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>
#import "SpotifyButton.h"
#import "AudioController.h"
#import "SongCell.h"
#import "RefresherView.h"
#import "PageContentViewController.h"
#import "AddSongTableViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *playlistitems;
}

-(void)handleNewSession:(SPTSession *)session playlist:(SPTPartialPlaylist*)partialplaylist;

@end
