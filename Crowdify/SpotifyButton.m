//
//  SpotifyButton.m
//  Crowdify
//
//  Created by Sony Theakanath on 6/25/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "SpotifyButton.h"

@implementation SpotifyButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"buttonbackground.png"] forState:UIControlStateNormal];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:17]];

    }
    return self;
}

@end
