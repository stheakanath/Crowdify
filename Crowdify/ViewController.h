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
#import "InterfaceText.h"
#import "RefresherView.h"
#import "PageContentViewController.h"
#import "AddSongTableViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPageViewControllerDataSource> {
    UITableView *playlistitems;
}

-(void)handleNewSession:(SPTSession *)session;
-(void)addTheSession:(SPTSession *)session;
-(void)moveToPlaylistScreen;
-(IBAction)startWalkthrough:(id)sender;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;

@end
