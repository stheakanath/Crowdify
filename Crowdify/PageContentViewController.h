//
//  PageContentViewController.h
//  Crowdify
//
//  Created by Sony Theakanath on 6/23/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpotifyButton.h"

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property SpotifyButton *clickButton;
@property NSString *imageFile;
@end
