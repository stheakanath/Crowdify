//
//  SongCell.h
//  Crowdify
//
//  Created by Sony Theakanath on 7/8/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceText.h"

@interface SongCell : UITableViewCell

@property (strong, nonatomic) InterfaceText *songText;
@property (strong, nonatomic) InterfaceText *artistText;

@end
