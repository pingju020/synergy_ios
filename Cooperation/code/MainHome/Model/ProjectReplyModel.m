//
//  ProjectReplyModel.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectReplyModel.h"
#import "NSObject+MJKeyValue.h"

@implementation ProjectReplyModel
+ (instancetype)creatModelWithDictonary:(NSDictionary *)dictonary
{
    ProjectReplyModel *model = [ProjectReplyModel mj_objectWithKeyValues:dictonary];
    model.changeId = dictonary[@"id"];
    model.changeList = [ChangeModel parsingDataWithResult:dictonary];
    return model;
}
@end

@implementation ChangeModel
+ (NSArray *)parsingDataWithResult:(NSDictionary *)resultDict{
    NSArray *factors = resultDict[@"changeList"];
    
    NSMutableArray *mulArr = [NSMutableArray array];
    
    for (NSDictionary *dict in factors) {
        ChangeModel *model = [ChangeModel mj_objectWithKeyValues:dict];
        model.nowValue = dict[@"newValue"];
        [mulArr addObject:model];
    }
    return [mulArr copy];
}
@end
