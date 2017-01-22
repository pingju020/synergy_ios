//
//  ProjectTableViewModel.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProjectStageModel;

extern NSString *const PS_CELL_ID; //重用标识

//逻辑层

@interface ProjectTableViewModel : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) ProjectStageModel *stageModel;

@end
