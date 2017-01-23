//
//  ProjectStageDateCell.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectTaskModel;


@protocol ProjectStageDateDelegate <NSObject>

- (void)projectStageWrite:(NSString *)taskId; //反馈
- (void)projectStageFinish:(NSString *)taskId; //完成

@end

@interface ProjectStageDateCell : UITableViewCell

@property (nonatomic,strong) ProjectTaskModel *taskModel;

@property (nonatomic,weak) id <ProjectStageDateDelegate> delegate;

@end
