//
//  ProjectStageViewController.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BaseViewController.h"

@interface ProjectStageViewController : BaseViewController

@property(nonatomic,strong)BaseViewController* backVC;

- (instancetype)initWithProjectId:(NSString *)projectId;

@end
