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
@property (nonatomic,strong) UIImageView *fileIcon;
@property (nonatomic,strong) UILabel *fileLabel;
@property (nonatomic,strong) UILabel *contentLabel;


@property (nonatomic,assign) BOOL isFileType;//是否是文档cell

@end


@implementation ProjectStageFileCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -赋值
- (void)setCreateTime:(NSString *)createTime
{
    self.isFileType = NO;
    
    self.contentLabel.text = createTime;
}

- (void)setContentWithName:(NSString *)name text:(NSString *)text
{
    NSString *str = [NSString stringWithFormat:@"%@：%@",name,text];
    
    //用富文本显示
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    
    //名字
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0DBEF5"],
                          NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, name.length)];
    
    //内容
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2A2A2A"],
                          NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(str.length-text.length, text.length)];
    
    self.contentLabel.attributedText = attr;
}

//文档
- (void)setFileInfoWithFileType:(NSInteger)fileType title:(NSString *)title
{
    self.isFileType = YES;
    
    NSString *imageName;
    switch (fileType) {
        case 7: //图片
            imageName = @"jpg";
            break;
            
        case 11: //doc
            imageName = @"doc";
            break;
        case 12: //xls
            imageName = @"xls";
            break;
        case 13: //ppt
            imageName = @"ppt";
            break;
        default:
            imageName = @"";
            break;
    }
    
    
    self.fileIcon.image = [UIImage imageNamed:imageName];
    
    self.fileLabel.text = title;
}

- (void)setIsFileType:(BOOL)isFileType
{
    _isFileType = isFileType;
    
    self.fileIcon.hidden     = !isFileType;
    self.fileLabel.hidden    = !isFileType;
    
    self.contentLabel.hidden = isFileType;
}

#pragma mark -setUI
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backView.frame   = CGRectMake(30, 0, self.width-30-10, self.height);
    
    //backview的子控件
    self.fileIcon.frame     = CGRectMake(10, (_backView.height-19)/2, 13, 19);
    
    self.fileLabel.frame    = CGRectMake(_fileIcon.right+10, 0, _backView.width-(_fileIcon.right+10)-10, _backView.height);
    
    self.contentLabel.frame = CGRectMake(10, 0, _backView.width-20, _backView.height);
    
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

- (UIImageView *)fileIcon
{
    if (!_fileIcon) {
        _fileIcon = [UIImageView new];
        [self.backView addSubview:_fileIcon];
    }
    return _fileIcon;
}

- (UILabel *)fileLabel
{
    if (!_fileLabel) {
        _fileLabel = [UILabel new];
        _fileLabel.font = [UIFont systemFontOfSize:14];
        _fileLabel.textAlignment = NSTextAlignmentLeft;
        _fileLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.backView addSubview:_fileLabel];
    }
    return _fileLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor colorWithHexString:@"#959595"];
        [self.backView addSubview:_contentLabel];
    }
    return _contentLabel;
}


@end
