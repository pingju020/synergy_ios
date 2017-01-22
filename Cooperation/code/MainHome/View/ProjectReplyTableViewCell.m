//
//  ProjectReplyTableViewCell.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectReplyTableViewCell.h"

@implementation ReplyLabel

-(id)initWithFrame:(CGRect) frame{
    if (self = [super initWithFrame:frame]) {
        self.numberOfLines = 0;
        self.textColor = COMMON_CORLOR_NORMAL;
        self.font = [UIFont systemFontOfSize:14];
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

-(void)setChangeModel:(ChangeModel*)model withName:(NSString*)name{
    NSMutableAttributedString* att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ 将", name]];
    [att appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(%@)",model.oldValue] attributes:@{NSForegroundColorAttributeName:COMMON_CORLOR_HIGHLIGHT}]];
    [att appendAttributedString:[[NSAttributedString alloc]initWithString:@"变更为"]];
    [att appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(%@)",model.nowValue] attributes:@{NSForegroundColorAttributeName:COMMON_CORLOR_HIGHLIGHT}]];
    self.attributedText = att;
}

@end

@interface ProjectReplyTableViewCell()
@property(nonatomic,strong)ReplyLabel* infoLabel;
@end

@implementation ProjectReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _infoLabel = [[ReplyLabel alloc]initWithFrame:CGRectMake(10, 0, MAIN_WIDTH-20, 56)];
        [self.contentView addSubview:_infoLabel];
    }
    return self;
}

-(void)setModel:(ChangeModel*)model Name:(NSString*)name{
    [_infoLabel setChangeModel:model withName:name];
}

@end
