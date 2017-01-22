//
//  PPLabelMenuView.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "PPLabelMenuView.h"
#import "ViewButtonModel.h"

@interface PPLabelMenuView()
@property(nonatomic,strong)NSArray* buttons;
@end

@implementation PPLabelMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - 按钮状态切换
- (void)animateViewProgress:(CGFloat)progress
{
    NSInteger index = progress / MAIN_WIDTH ;
    [self selectButton:index];
}

-(void)selectButton:(NSInteger)index{
    ViewButtonModel* model = _arrViewList[index];
    for (NSInteger i = 0; i < _buttons.count; i++) {
        UIButton* btn = _buttons[i];
        if (i == index) {
            btn.selected = YES;
        }
        else{
            btn.selected = NO;
        }
    }
}

@end
