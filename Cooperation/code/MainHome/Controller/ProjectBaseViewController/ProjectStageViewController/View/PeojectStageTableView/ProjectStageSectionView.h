//
//  ProjectStageSectionView.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectTaskModel;

extern NSString *const PS_SECTION_ID; //section重用标识

@interface ProjectStageSectionView : UITableViewHeaderFooterView

@property (nonatomic,strong) ProjectTaskModel *taskModel;

//获取section高度
+ (CGFloat)getSectionHeightWithModel:(ProjectTaskModel *)model tableWidth:(CGFloat)tableWidth;

@end
