//
//  SongCell.m
//  Crowdify
//
//  Created by Sony Theakanath on 7/8/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "SongCell.h"

@implementation SongCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(15, 59, screenWidth-35, 0.5)];
        separator.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:separator];
        self.songText = [[InterfaceText alloc] initWithFrame:CGRectMake(20.0, 0, screenWidth-40 , 50) initwithFontSize: 16 initWithLabelText:@"" initwithFormatting:NSTextAlignmentLeft withColor:[UIColor whiteColor]];
        self.songText.tag = 1;
        [self.contentView addSubview:self.songText];
        self.artistText = [[InterfaceText alloc] initWithFrame:CGRectMake(20.0, 20, screenWidth-40 , 50) initwithFontSize: 13 initWithLabelText:[NSString stringWithFormat:@"%@ | %@", @"", @""] initwithFormatting:NSTextAlignmentLeft withColor:[UIColor grayColor]];
        [self.contentView addSubview:self.artistText];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
