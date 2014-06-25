//
//  ViewController.h
//  Crowdify
//
//  Created by Sony Theakanath on 6/23/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface ViewController : UIViewController

-(void)handleNewSession:(SPTSession *)session;

@end
