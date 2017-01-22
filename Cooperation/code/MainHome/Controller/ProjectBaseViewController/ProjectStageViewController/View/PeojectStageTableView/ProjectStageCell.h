//
//  ProjectStageCell.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectFeedbackModel;

extern NSString *const PS_CELL_ID; //cell重用标识

@interface ProjectStageCell : UITableViewCell

@property (nonatomic,strong) ProjectFeedbackModel *feedBackModel;

//获取cell高度
+ (CGFloat)getCellHeightWithModel:(ProjectFeedbackModel *)model tableWidth:(CGFloat)tableWidth;

@end
