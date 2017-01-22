//
//  ProjectTabModel.m
//  Cooperation
//
//  Created by 葛君语 on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectTabModel.h"

@implementation ProjectTabModel

+ (NSArray<ProjectTabModel *> *)parsingDataListWithArray:(NSArray *)data
{
    if (IsArrEmpty(data)) {
        return nil;
    }
    
    NSMutableArray *mulArr = [NSMutableArray array];
    
    for (NSDictionary *dict in data) {
        ProjectTabModel *model = [ProjectTabModel new];
        
        model.stageId = dict[@"id"];
        model.stageModuleName = dict[@"stageModuleName"];
        
        [mulArr addObject:model];
    }
    
    return [mulArr copy];
}

@end
