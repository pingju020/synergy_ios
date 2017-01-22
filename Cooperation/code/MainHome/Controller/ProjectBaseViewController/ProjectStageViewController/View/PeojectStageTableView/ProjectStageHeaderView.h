//
//  ProjectStageHeaderView.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectStageModel;


@protocol ProjectStageHeaderDelegate <NSObject>

- (void)projectStageHeaderChangeState; //点击更改状态

- (void)projectStageHeaderAddMission;  //新增任务


@end

@interface ProjectStageHeaderView : UIView

@property (nonatomic,strong) ProjectStageModel *model;

@property (nonatomic,weak) id <ProjectStageHeaderDelegate>delegate;

@end
