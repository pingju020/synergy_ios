//
//  ProjectTabModel.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectTabModel : NSObject

@property (nonatomic,copy) NSString *stageId;
@property (nonatomic,copy) NSString *stageModuleName;

+ (NSArray <ProjectTabModel *>*)parsingDataListWithArray:(NSArray *)data;

@end
