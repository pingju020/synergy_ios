//
//  ProjectSearchConditionModel.h
//  Cooperation
//
//  Created by Tion on 17/1/20.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectSearchConditionModel : NSObject
@property (nonatomic, strong) NSString *MessageInfo;
@property (nonatomic) BOOL Mark;
@property (nonatomic, strong) NSString *stageOrder;
@property (nonatomic, strong) NSString *bankId;
@property (nonatomic, strong) NSMutableArray *branchBankArray;

@property (nonatomic, strong) NSString *passParam;

- (instancetype)initWithDic:(NSMutableDictionary *)dic;

@end
