//
//  ProjectMessageCell.m
//  Cooperation
//
//  Created by Tion on 17/1/20.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectMessageCell.h"
#import "UIView+LJAdditions.h"

@implementation ProjectMessageCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = @"ProjectMessageCell";
    ProjectMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectMessageCell" owner:nil options:nil] lastObject];
       
    }
    [cell.StatusLabel setTextColor:[UIColor colorWithHexString:@"#00B1F0"]];
    [cell.StatusLabel setTextAlignment:NSTextAlignmentLeft];
    [cell.StatusLabel setFont:[UIFont systemFontOfSize:12.f]];
    
    
    [cell.MessgaeLabel setTextColor:[UIColor darkGrayColor]];
    [cell.MessgaeLabel setFont:[UIFont systemFontOfSize:12.f]];
    
    
    
    
    return cell;
}
- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commoninit];
    }
    return self;
}

- (void) commoninit{
    
}

- (void) commonlayout{
    
    self.StatusLabel.lj_centerY = self.contentView.lj_centerY;
    
    self.MessgaeLabel.lj_centerY = self.contentView.lj_centerY;
    
    self.StatusImageView.lj_centerY = self.contentView.lj_centerY;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    [self commonlayout];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
