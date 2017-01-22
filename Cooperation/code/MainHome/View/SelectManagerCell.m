//
//  SelectManagerCell.m
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "SelectManagerCell.h"

@implementation SelectManagerCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = @"SelectManagerCell";
    SelectManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectManagerCell" owner:nil options:nil] lastObject];
    }
    cell.SelectedImageView.layer.masksToBounds=YES;
    cell.SelectedImageView.layer.cornerRadius=10;
//    [cell.ConditionLabel setTextColor:[UIColor darkGrayColor]];
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
