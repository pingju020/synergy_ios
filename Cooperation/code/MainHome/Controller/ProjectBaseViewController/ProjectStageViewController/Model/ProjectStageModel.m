//
//  ProjectStageModel.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectStageModel.h"
#import "MJExtension.h"

//ProjectTaskFileModel在cellforrow方法里面取值会崩溃，原因未知，该类暂时改用这个方法
static NSString *safetyEncodeDicionary(NSDictionary *dict,NSString *key){
    if (!dict || !dict[key]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",dict[key]];
    
}


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
    
    //暂时不用该方法
//    NSMutableArray *mulArr = [ProjectTaskFileModel mj_keyValuesArrayWithObjectArray:list];
    
    
    NSMutableArray *mulArr = [NSMutableArray array];
    for (NSDictionary *dict in list) {
        ProjectTaskFileModel *model = [ProjectTaskFileModel new];
        [model setId:safetyEncodeDicionary(dict, @"id")];
        model.fileUrl = safetyEncodeDicionary(dict, @"fileUrl");
        model.fileName = safetyEncodeDicionary(dict, @"fileName");
        model.fileType = safetyEncodeDicionary(dict, @"fileType");
        
        [mulArr addObject:model];
    }
    
    
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
        
        model.taskFeedFiles = [ProjectTaskFileModel parsingArrayWithList:dict[@"taskFeedFiles"]];
        
        [mulArr addObject:model];
    }
    
    return [mulArr copy];
}

@end
