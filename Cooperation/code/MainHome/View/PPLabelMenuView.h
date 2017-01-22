//
//  PPLabelMenuView.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPLabelMenuView : UIView

@property(nonatomic,strong)NSArray* arrViewList;
///动画关联scrollView（点击菜单按钮时会滚动到相应位置）
@property (weak, nonatomic) UIScrollView *scollView;

///动画(progress: 滚动条左边距/(菜单视图长度 * 3))
- (void)animateViewProgress:(CGFloat)progress;
@end
