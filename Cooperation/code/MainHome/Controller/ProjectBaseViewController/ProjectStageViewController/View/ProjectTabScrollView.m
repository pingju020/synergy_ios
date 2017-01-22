//
//  ProjectTabScrollView.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectTabScrollView.h"
#import "ProjectTabModel.h"

@interface ProjectTabButton : UIControl
@property (nonatomic,strong) UILabel *idxLabel; //序号
@property (nonatomic,strong) UILabel *titleLabel; //标题
@property (nonatomic,strong) UIView *sepLine; //分割线
@end


@interface ProjectTabScrollView ()

//右边的灰色分割线
@property (nonatomic,strong) UIView *rightSepLine;

//按钮合集
@property (nonatomic,strong) NSMutableArray *buttonList;


@end

@implementation ProjectTabScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self rightSepLine];
    }
    return self;
}

#pragma mark -data
- (void)setDataList:(NSArray<ProjectTabModel *> *)dataList
{
    _dataList = dataList;
    
    
    /* ↓↓↓↓↓↓↓↓可删除↓↓↓↓↓↓↓↓↓↓ */
    //再次赋值先清理旧的数据 ，如果以后该页面只会赋值一次，该if语句可以删除
    if (self.buttonList.count > 0) {
        for (UIButton *btn in self.buttonList) {
            [btn removeFromSuperview];
        }
        [self.buttonList removeAllObjects];
    }
    /* ↑↑↑↑↑↑↑↑可删除↑↑↑↑↑↑↑ */
    
    
    //构建按钮
    [dataList enumerateObjectsUsingBlock:^(ProjectTabModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        ProjectTabButton *btn = [[ProjectTabButton alloc]initWithFrame:CGRectMake(0, 70*idx, self.width-1 ,70)];
        
        btn.titleLabel.text = model.stageModuleName;
        btn.tag = idx+1;
        btn.selected = (idx == 0);
        
        [btn addTarget:self action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.buttonList addObject:btn];
        
        if(idx == dataList.count-1){ //最后一个按钮确定滚动范围
            self.contentSize = CGSizeMake(0, btn.bottom);
        }

    
    }];

}

#pragma mark -btnAction
- (void)tabClicked:(ProjectTabButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    //更改选中状态
    for (ProjectTabButton *btn in self.buttonList) {
        if (btn.selected) {
            btn.selected = NO;
            break;
        }
    }
    sender.selected = YES;
    
    //传值
    if (_tabHandle) {
        NSString *stageId = [self.dataList[sender.tag-1] stageId];
        _tabHandle(stageId);
    }
    
}

#pragma mark -setUI
- (UIView *)rightSepLine
{
    if (!_rightSepLine) {
        _rightSepLine = [[UIView alloc]initWithFrame:CGRectMake(self.width-1, 0, 1, self.height)];
        _rightSepLine.backgroundColor = [UIColor colorWithHexString:@"#DCDFE0"];
        [self addSubview:_rightSepLine];
    }
    return _rightSepLine;
}


- (NSMutableArray *)buttonList
{
    if (!_buttonList) {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

@end


#pragma mark -ProjectTabButton

@implementation ProjectTabButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sepLine];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.titleLabel.textColor = selected ? [UIColor colorWithHexString:@"#26BEF2"] : [UIColor colorWithHexString:@"#959595"];
    self.idxLabel.textColor   = selected ? [UIColor colorWithHexString:@"#26BEF2"] : [UIColor colorWithHexString:@"#959595"];
    self.backgroundColor =  selected ? [UIColor colorWithHexString:@"#ECF5F7"] : [UIColor whiteColor];

}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    self.idxLabel.text = [NSString stringWithFormat:@"%lu",tag];
}

- (UILabel *)idxLabel
{
    if (!_idxLabel) {
        _idxLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.width, 20)];
        _idxLabel.font = [UIFont systemFontOfSize:18];
        _idxLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_idxLabel];
    }
    return _idxLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.idxLabel.bottom, self.width-10, self.height-self.idxLabel.bottom)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)sepLine
{
    if (!_sepLine) {
        _sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [self addSubview:_sepLine];
    }
    return _sepLine;
}

@end
