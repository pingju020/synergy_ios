//
//  ProjectReplyModel.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectReplyModel : NSObject
@property(nonatomic,strong)NSString* changeId;//	√	String	待审核ID
@property(nonatomic,strong)NSString* updateTime;//	√	String	更新时间
@property(nonatomic,strong)NSString* userName;//	√	String	操作人员
@property(nonatomic,strong)NSString* type;//	√	String	变更类型（0变更基本信息 1变更基本信息 2是完成阶段）
@property(nonatomic,strong)NSArray* changeList;//	√	String


+ (instancetype)creatModelWithDictonary:(NSDictionary *)dictonary;

@end

@interface ChangeModel : NSObject
@property(nonatomic,strong)NSString* oldValue;
@property(nonatomic,strong)NSString* nowValue;

+ (NSArray *)parsingDataWithResult:(NSDictionary *)resultDict;
@end
