//
//  ProjectStageFileCell.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectStageFileCell.h"
#import "ProjectStageModel.h"

@interface ProjectStageFileCell ()

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *titleLabel;

@end


@implementation ProjectStageFileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -赋值
- (void)setInfoWithFileType:(NSInteger)fileType title:(NSString *)title
{
    NSString *imageName = [self getImageNameWithFileType:fileType];
    
    self.icon.image = [UIImage imageNamed:imageName];
    
    self.titleLabel.text = title;
}

- (NSString *)getImageNameWithFileType:(NSInteger)fileType
{
    NSString *image;
    switch (fileType) {
        case 7: //图片
            image = @"jpg";
            break;
            
        case 11: //doc
            image = @"doc";
            break;
        case 12: //xls
            image = @"xls";
            break;
        case 13: //ppt
            image = @"ppt";
            break;
        default:
            image = @"";
            break;
    }
    
    return image;
}

#pragma mark -setUI
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backView.frame   = CGRectMake(30, 0, self.width-30-10, self.height);
    
    //backview的子控件
    self.icon.frame       = CGRectMake(10, (_backView.height-20)/2, 20, 20);
    
    self.titleLabel.frame = CGRectMake(self.icon.right+10, (_backView.height-20)/2, 20, 20);
    
    
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [self.contentView addSubview:_backView];

    }
    return _backView;
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [UIImageView new];
        [self.backView addSubview:_icon];
    }
    return _icon;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.backView addSubview:_titleLabel];
    }
    return _titleLabel;
}


@end
