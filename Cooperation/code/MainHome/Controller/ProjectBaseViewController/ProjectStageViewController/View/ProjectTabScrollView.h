//
//  ProjectTabScrollView.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectTabModel;

@interface ProjectTabScrollView : UIScrollView

@property (nonatomic,strong) NSArray <ProjectTabModel *>*dataList;

@property (nonatomic,copy) void (^tabHandle)(NSString *stageId);

@end
