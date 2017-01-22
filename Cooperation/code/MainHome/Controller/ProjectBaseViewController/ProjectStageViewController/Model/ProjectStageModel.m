//
//  ProjectStageModel.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectStageModel.h"
#import "MJExtension.h"

#pragma mark -查询阶段详情
@implementation ProjectStageModel

+ (instancetype)parsingModelWithDict:(NSDictionary *)dict
{
    ProjectStageModel *model = [ProjectStageModel mj_objectWithKeyValues:dict];
    
    model.projectTasks = [ProjectTaskModel parsingArrayWithList:dict[@"projectTasks"]];
    
    return model;
}

@end


#pragma mark -任务集合

@implementation ProjectTaskModel

+ (NSArray *)parsingArrayWithList:(NSArray *)list
{
    if (IsArrEmpty(list)) {
        return nil;
    }
    
    NSMutableArray *mulArr = [NSMutableArray array];
    
    for (NSDictionary *dict in list) {
        ProjectTaskModel *model = [ProjectTaskModel mj_objectWithKeyValues:dict];
        
        model.isOn = YES;
        
        model.taskFiles = [ProjectTaskFileModel parsingArrayWithList:dict[@"taskFiles"]];
        
        model.taskFeedbacks = [ProjectFeedbackModel parsingArrayWithList:dict[@"taskFeedbacks"]];
        
        [mulArr addObject:model];
        
    }
    
    return [mulArr copy];
}

@end

#pragma mark -任务附件集合

@implementation ProjectTaskFileModel

+ (NSArray *)parsingArrayWithList:(NSArray *)list
{
    if (IsArrEmpty(list)) {
        return nil;
    }
    
    NSMutableArray *mulArr = [ProjectTaskFileModel mj_keyValuesArrayWithObjectArray:list];
    
    return [mulArr copy];
    
    
}

@end

#pragma mark -任务反馈集合
@implementation ProjectFeedbackModel

+ (NSArray *)parsingArrayWithList:(NSArray *)list
{
    if (IsArrEmpty(list)) {
        return nil;
    }
    
    
    NSMutableArray *mulArr = [NSMutableArray array];
    
    for (NSDictionary *dict in list) {
        ProjectFeedbackModel *model = [ProjectFeedbackModel mj_objectWithKeyValues:dict];
        
        model.cellHeight = -1;
        
        model.taskFeedFiles = [ProjectFeedbackFileModel parsingArrayWithList:dict[@"taskFeedFiles"]];
        
        [mulArr addObject:model];
    }
    
    return [mulArr copy];
}

@end


#pragma mark -任务反馈附件集合
@implementation ProjectFeedbackFileModel

+ (NSArray *)parsingArrayWithList:(NSArray *)list
{
    if (IsArrEmpty(list)) {
        return nil;
    }
    
    NSMutableArray *mulArr = [ProjectFeedbackFileModel mj_keyValuesArrayWithObjectArray:list];
    
    return [mulArr copy];
}

@end
