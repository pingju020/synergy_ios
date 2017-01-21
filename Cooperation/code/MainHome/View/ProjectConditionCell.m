//
//  ProjectConditionCell.m
//  Cooperation
//
//  Created by Tion on 17/1/20.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectConditionCell.h"

@implementation ProjectConditionCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = @"ProjectCondtionCell";
    ProjectConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectConditionCell" owner:nil options:nil] lastObject];
    }
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
