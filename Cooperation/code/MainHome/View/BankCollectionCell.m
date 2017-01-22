//
//  BankCollectionCell.m
//  Cooperation
//
//  Created by Tion on 17/1/20.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BankCollectionCell.h"

@implementation BankCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2-20-20-20-10, 40)];
        titleLabel.font = [UIFont systemFontOfSize:12.f];
        self.titleLabel = titleLabel;
        [self.contentView addSubview:self.titleLabel];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40+2, 13, 16, 14)];
        self.selectedImageView=imageView;
        [self.selectedImageView setImage:[UIImage imageNamed:@"conditionSelected.png"]];
        [self.contentView addSubview:self.selectedImageView];
        
        UIView *LineView=[[UIView alloc]initWithFrame:CGRectMake(0,frame.size.height-1,SCREEN_WIDTH,1)];
        self.LineView=LineView;
        [self.LineView setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
        [self.contentView addSubview:self.LineView];
        
    }
    return self;
}
@end
