//
//  ProjectDetailModel.m
//  Cooperation
//
//  Created by yangjuanping on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectDetailModel.h"
#import "NSObject+MJKeyValue.h"

@implementation ProjectDetailModel
+ (instancetype)creatModelWithDictonary:(NSDictionary *)dictonary
{
    ProjectDetailModel *model = [ProjectDetailModel mj_objectWithKeyValues:dictonary];
    model.project    = [ProjectModel parsingDataWithResult:dictonary];
    model.office     = [OfficeModel parsingDataWithResult:dictonary];
    model.factors    = [FactorModel parsingDataWithResult:dictonary];
    model.credits    = [CreditModel parsingDataWithResult:dictonary];
    return model;
}
@end

@implementation ProjectModel
+ (ProjectModel *)parsingDataWithResult:(NSDictionary *)resultDict{
    NSDictionary *project = resultDict[@"project"];
    ProjectModel *model = [ProjectModel mj_objectWithKeyValues:project];
    model.projectId      = project[@"id"];
    
    return model;
}
@end

@implementation OfficeModel
+ (OfficeModel *)parsingDataWithResult:(NSDictionary *)resultDict{
    NSDictionary *office = resultDict[@"office"];
    OfficeModel *model = [OfficeModel mj_objectWithKeyValues:office];
    model.officeId        = office[@"id"];
    
    return model;
}
@end


@implementation FactorModel
+ (NSArray *)parsingDataWithResult:(NSDictionary *)resultDict{
    NSArray *factors = resultDict[@"factors"];
    
    NSMutableArray *mulArr = [NSMutableArray array];
    
    for (NSDictionary *dict in factors) {
        FactorModel *model = [FactorModel mj_objectWithKeyValues:dict];
        model.factorId        = dict[@"id"];
        [mulArr addObject:model];
    }
    
    return [mulArr copy];
}
@end


@implementation CreditModel
+ (NSArray *)parsingDataWithResult:(NSDictionary *)resultDict{
    NSArray *credits = resultDict[@"credits"];
    
    NSMutableArray *mulArr = [NSMutableArray array];
    
    for (NSDictionary *dict in credits) {
        CreditModel *model = [CreditModel mj_objectWithKeyValues:dict];
        [mulArr addObject:model];
    }
    
    return [mulArr copy];
}
@end


@implementation ChangeInfoModel
@end
