//
//  AudioController.h
//  Crowdify
//
//  Created by Sony Theakanath on 6/26/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AudioController : UIView

- (id)initWithFrame:(CGRect)frame initWithPlayer: (SPTTrackPlayer*)player;
- (void) updateAudioPlayer;

@end
