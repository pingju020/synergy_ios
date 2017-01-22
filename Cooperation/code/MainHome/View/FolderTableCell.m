//
//  FolderTableCell.m
//  Cooperation
//
//  Created by Tion on 17/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "FolderTableCell.h"

@implementation FolderTableCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = @"FolderTableCell";
    FolderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FolderTableCell" owner:nil options:nil] lastObject];
    }
    [cell.FoldImageView setImage:[UIImage imageNamed:@"文件夹.png"]];
    [cell.ArrowRightImageView setImage:[UIImage imageNamed:@"右箭头@2x.png"]];
    cell.FoldNumberLabel.layer.masksToBounds=YES;
    cell.FoldNumberLabel.layer.cornerRadius=15;
    cell.FoldNumberLabel.backgroundColor=[UIColor colorWithHexString:@"#485464"];
    [cell.FoldNumberLabel setTextColor:[UIColor whiteColor]];
    [cell.FoldNumberLabel setTextAlignment:NSTextAlignmentCenter];
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
