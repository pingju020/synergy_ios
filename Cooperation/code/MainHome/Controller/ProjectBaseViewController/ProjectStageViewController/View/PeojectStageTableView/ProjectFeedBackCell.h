//
//  ProjectFeedBackCell.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectTaskModel;

@interface ProjectFeedBackCell : UITableViewCell

@property (nonatomic,strong) ProjectTaskModel *taskModel;

+ (CGFloat)getHeightWith:(ProjectTaskModel *)taskModel tableWidth:(CGFloat)tableWidth;//获取高度并缓存

@end
