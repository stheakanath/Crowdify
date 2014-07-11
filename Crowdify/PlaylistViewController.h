//
//  PlaylistViewController.h
//  Crowdify
//
//  Created by Sony Theakanath on 7/10/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>
#import "SpotifyButton.h"
#import "SongCell.h"
#import "RefresherView.h"
#import "PageContentViewController.h"

@interface PlaylistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPageViewControllerDataSource> {
    UITableView *playlistitems;
}

-(void)handleNewSession:(SPTSession *)session;
-(void)addTheSession:(SPTSession *)session;
-(void)moveToPlaylistScreen;
-(IBAction)startWalkthrough:(id)sender;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;


@end
