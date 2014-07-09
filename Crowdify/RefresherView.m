//
//  RefresherView.m
//  Refresh Screen
//
//  Created by Sony Theakanath on 6/28/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "RefresherView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RefresherView

UIView *leftdot;
UIView *middledot;
UIView *rightdot;

- (id) init {
    self = [super initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-75, [[UIScreen mainScreen] bounds].size.height/2-75, 150, 150)];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        self.alpha = 0.5;
        self.layer.cornerRadius = 8;
        leftdot = [self createCircle:CGRectMake(150/2-55, 150/2-17.5, 35, 35)];
        middledot = [self createCircle:CGRectMake(150/2-17.5, 150/2-17.5, 35, 35)];
        rightdot = [self createCircle:CGRectMake(150/2+37.5-17.5, 150/2-17.5, 35, 35)];
        [self addSubview:leftdot];
        [self addSubview:middledot];
        [self addSubview:rightdot];
        [self animateObjects];
    }
    return self;
}

- (void)animateObjects{
    [self moveObjects];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(moveObjects) userInfo:nil repeats:YES];
}

- (void) moveObjects {
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
        [leftdot setAlpha:0.7];
        [leftdot setAlpha:1];
        [leftdot setTransform: CGAffineTransformMakeScale(0.5,0.5)];
        [leftdot setTransform: CGAffineTransformMakeScale(0.7,0.7)];
    } completion:^ (BOOL finished) {
        [leftdot setAlpha:0.7];
        [leftdot setTransform: CGAffineTransformMakeScale(0.5,0.5)];
    }];
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAutoreverse animations:^{
        [middledot setAlpha:0.7];
        [middledot setAlpha:1];
        [middledot setTransform: CGAffineTransformMakeScale(0.5,0.5)];
        [middledot setTransform: CGAffineTransformMakeScale(0.7,0.7)];
    } completion:^ (BOOL finished) {
        [middledot setAlpha:0.7];
        [middledot setTransform: CGAffineTransformMakeScale(0.5,0.5)];
    }];
    [UIView animateWithDuration:0.5f delay:1.0f options:UIViewAnimationOptionAutoreverse animations:^{
        [rightdot setAlpha:0.7];
        [rightdot setAlpha:1];
        [rightdot setTransform: CGAffineTransformMakeScale(0.5,0.5)];
        [rightdot setTransform: CGAffineTransformMakeScale(0.7,0.7)];
    } completion:^ (BOOL finished) {
        [rightdot setAlpha:0.7];
        [rightdot setTransform: CGAffineTransformMakeScale(0.5,0.5)];
    }];
}

- (UIView*)createCircle:(CGRect)frame {
    UIView *circle = [[UIView alloc] initWithFrame:frame];
    circle.layer.cornerRadius = 17.5;
    circle.backgroundColor = [UIColor whiteColor];
    [circle setTransform: CGAffineTransformMakeScale(0.5,0.5)];
    return circle;
}

@end
