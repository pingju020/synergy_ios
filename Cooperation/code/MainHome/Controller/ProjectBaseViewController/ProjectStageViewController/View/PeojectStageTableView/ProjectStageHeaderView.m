//
//  ProjectStageHeaderView.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectStageHeaderView.h"
#import "ProjectStageModel.h"

@interface ProjectStageHeaderView ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *stateButton;
@property (nonatomic,strong) UIView *possibilityView;
@property (nonatomic,strong) UILabel *possibilityLabel;
@property (nonatomic,strong) UIButton *addButton;

@end

@implementation ProjectStageHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return self;
}


#pragma mark -btnAction
- (void)addClicked
{
    if ([self.delegate respondsToSelector:@selector(projectStageHeaderAddMission)]) {
        [self.delegate projectStageHeaderAddMission];
    }

}

- (void)stateClicked
{
    if ([self.delegate respondsToSelector:@selector(projectStageHeaderChangeState)]) {
        [self.delegate projectStageHeaderChangeState];
    }

}

#pragma mark -赋值
- (void)setModel:(ProjectStageModel *)model
{
    _model = model;
    
    //标题
    self.titleLabel.text = [NSString stringWithFormat:@"%@.%@",model.stageOrder,model.stageModuleName];
    
    //状态
    [self changeState:model.state.integerValue];
    
    //状态描述
    self.possibilityLabel.text = model.possibilityState;
}

- (void)changeState:(NSInteger)state
{
    NSString *text;

    switch (state) {
        case 0:
            text = @"未开始";
            break;
            
        case 1:
            text = @"进行中";
            break;
        case 2:
            text = @"已完成";
            break;
        case 3:
            text = @"暂停";
            break;
            
        default:
            text = @"";
            break;
    }
    
    [self.stateButton setTitle:text forState:UIControlStateNormal];
    
    
    //如果任务完成，隐藏新增任务按钮
    BOOL isFinish = (state == 2);
    
    self.addButton.hidden = isFinish;
    
    self.height = (isFinish ? self.possibilityView.bottom+10 : self.addButton.bottom+10);

}

#pragma mark - setUI
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 150, 20)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#0DBEF5"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)stateButton
{
    if (!_stateButton) {
        _stateButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width-5-60, 0, 60, 20)];
        _stateButton.bottom = self.titleLabel.bottom;
        [_stateButton setTitleColor:[UIColor colorWithHexString:@"#09BB07"] forState:UIControlStateNormal];
        _stateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _stateButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_stateButton addTarget:self action:@selector(stateClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_stateButton];
        
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(_stateButton.width-8-5, (_stateButton.height-5)/2, 8, 5)];
        arrow.image = [UIImage imageNamed:@"任务-下拉2"];
        [_stateButton addSubview:arrow];
        
    }
    return _stateButton;
}

- (UIView *)possibilityView
{
    if (!_possibilityView) {
        _possibilityView = [[UIView alloc]initWithFrame:CGRectMake(5, self.stateButton.bottom+10, self.width-10, 50)];
        _possibilityView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_possibilityView];
        
        UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _possibilityView.width, 2)];
        sepLine.backgroundColor = [UIColor colorWithHexString:@"#0DBEF5"];
        [_possibilityView addSubview:sepLine];
        
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
        descLabel.text = @"状态描述:";
        descLabel.textColor = [UIColor grayColor];
        descLabel.font = [UIFont systemFontOfSize:13];
        [descLabel sizeToFit];
        descLabel.centerY = _possibilityView.height/2;
        [_possibilityView addSubview:descLabel];
        
        _possibilityLabel = [[UILabel alloc]initWithFrame:CGRectMake(descLabel.right, 0, 200, 20)];
        _possibilityLabel.centerY = descLabel.centerY;
        _possibilityLabel.font = [UIFont systemFontOfSize:13];
        _possibilityLabel.textColor = [UIColor colorWithHexString:@"#09BB07"];
        _possibilityLabel.textAlignment = NSTextAlignmentLeft;
        [_possibilityView addSubview:_possibilityLabel];
    }
    return _possibilityView;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [[UIButton alloc]initWithFrame:CGRectMake(5, self.possibilityView.bottom+3, self.width-10, 50)];
        
        [_addButton setTitle:@"新增任务" forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [_addButton addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
    }
    return _addButton;
}

@end
