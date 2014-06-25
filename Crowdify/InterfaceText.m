//
//  InterfaceText.m
//  Crowdify
//
//  Created by Sony Theakanath on 6/25/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "InterfaceText.h"

@implementation InterfaceText

- (id)initWithFrame:(CGRect)frame initwithFontSize:(CGFloat)fontsize initWithLabelText:(NSString*)text
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:fontsize]];
        [self setText:text];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setTextColor:[UIColor whiteColor]];
        [self setShadowColor:[UIColor blackColor]];
        [self setShadowOffset:CGSizeMake(1, 0)];
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.numberOfLines = 0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
