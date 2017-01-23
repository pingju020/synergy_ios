//
//  ProjectStageDateCell.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectStageDateCell.h"
#import "ProjectStageModel.h"

@interface ProjectStageDateCell ()
@property (nonatomic,strong) UIImageView *arrowView; //箭头
@property (nonatomic,strong) UILabel *dateLabel; //日期
@property (nonatomic,strong) UIButton *writeButton; //反馈
@property (nonatomic,strong) UIButton *finishButton; //完成
@property (nonatomic,strong) UILabel *endLabel; //已完成

@end

@implementation ProjectStageDateCell
{
    BOOL _isFirstLoad; //是否首次加载
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _isFirstLoad = YES;
    }
    return self;
}

#pragma mark -btnAction
- (void)writeClicked
{
    if ([self.delegate respondsToSelector:@selector(projectStageWrite:)]) {
        [self.delegate projectStageWrite:_taskModel.taskId];
    }
}

- (void)finishClicked
{
    if ([self.delegate respondsToSelector:@selector(projectStageFinish:)]) {
        [self.delegate projectStageFinish:_taskModel.taskId];
    }

}

#pragma mark -赋值
- (void)setTaskModel:(ProjectTaskModel *)taskModel
{
    _taskModel = taskModel;
    
    self.arrowView.image = [UIImage imageNamed:taskModel.isOn ? @"任务-上拉2" : @"任务-下拉2"];
    
    self.dateLabel.text  = taskModel.createTime;
    
    BOOL isFinish = taskModel.taskState.integerValue;
    
    self.writeButton.hidden  = isFinish;
    self.finishButton.hidden = isFinish;
    self.endLabel.hidden     = !isFinish;
}


#pragma mark -setUI
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_isFirstLoad) {
        self.arrowView.frame = CGRectMake(30, (self.height-10.5)/2, 15.5, 10.5);
        
        self.finishButton.frame = CGRectMake(self.width-10-40, (self.height-30)/2, 40, 30);
        self.writeButton.frame = CGRectMake(_finishButton.left-15-40, (self.height-30)/2, 40, 30);
        self.endLabel.frame = CGRectMake(self.width-10-50, (self.height-30)/2, 50, 30);
        
        self.dateLabel.frame = CGRectMake(self.arrowView.right+5, (self.height-20)/2, 150, 20);
        
        _isFirstLoad = NO;
    }
    

}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [UIImageView new];
        [self.contentView addSubview:_arrowView];
    }
    return _arrowView;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.textColor = [UIColor colorWithHexString:@"#959595"];
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (UIButton *)writeButton
{
    if (!_writeButton) {
        _writeButton = [UIButton new];
        [_writeButton setTitle:@"反馈" forState:UIControlStateNormal];
        [_writeButton setTitleColor:[UIColor colorWithHexString:@"#0DBEF5"] forState:UIControlStateNormal];
        _writeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_writeButton addTarget:self action:@selector(writeClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_writeButton];
    }
    return _writeButton;
}

- (UIButton *)finishButton
{
    if (!_finishButton) {
        _finishButton = [UIButton new];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor colorWithHexString:@"#0DBEF5"] forState:UIControlStateNormal];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_finishButton addTarget:self action:@selector(finishClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_finishButton];
    }
    return _finishButton;
}

- (UILabel *)endLabel
{
    if (!_endLabel) {
        _endLabel = [UILabel new];
        _endLabel.text = @"已完成";
        _endLabel.textColor = [UIColor colorWithHexString:@"#F6A623"];
        _endLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_endLabel];
    }
    return _endLabel;
}

@end
