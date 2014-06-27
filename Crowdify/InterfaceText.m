//
//  InterfaceText.m
//  Crowdify
//
//  Created by Sony Theakanath on 6/25/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "InterfaceText.h"

@implementation InterfaceText

- (id)initWithFrame:(CGRect)frame initwithFontSize:(CGFloat)fontsize initWithLabelText:(NSString*)text initwithFormatting:(NSTextAlignment)textalignment withColor:(UIColor*)color{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:fontsize]];
        [self setText:text];
        [self setTextAlignment:textalignment];
        [self setTextColor:color];
        [self setShadowColor:[UIColor blackColor]];
        [self setShadowOffset:CGSizeMake(1, 0)];
        self.numberOfLines = 1;
    }
    return self;
}

@end
