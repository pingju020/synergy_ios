//
//  ProjectStageModel.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProjectTaskModel;
@class ProjectTaskFileModel;
@class ProjectFeedbackModel;
@class ProjectFeedbackFileModel;


//为方便修改，这里定义一个通用cell高度
static CGFloat PS_CELL_H = 35;

#pragma mark -查询阶段详情
@interface ProjectStageModel : NSObject

///阶段id
@property (nonatomic,copy,getter=stageId) NSString *id;
///项目id
@property (nonatomic,copy) NSString *projectId;
///阶段名称
@property (nonatomic,copy) NSString *stageModuleName;
///阶段状态（0：未开始 1：进行中 2：已完成  3：暂停）
@property (nonatomic,strong) NSNumber *state;
///状态描述
@property (nonatomic,copy) NSString *possibilityState;
///当前阶段是第几步
@property (nonatomic,strong) NSNumber *stageOrder;
///该项目的最大步数
@property (nonatomic,strong) NSNumber *maxStageOrder;
///项目状态（0：进行中 1：已经完成 2：已关闭）
@property (nonatomic,strong) NSNumber *projectStage;
///阶段中所有的任务集合
@property (nonatomic,strong) NSArray <ProjectTaskModel *>*projectTasks;

//构建方法
+ (instancetype)parsingModelWithDict:(NSDictionary *)dict;

@end


#pragma mark -任务集合

@interface ProjectTaskModel : NSObject

///任务id
@property (nonatomic,copy,getter=taskId) NSString *id;
///任务阶段id
@property (nonatomic,copy) NSString *projectStageId;
///任务内容
@property (nonatomic,copy) NSString *taskContent;
///任务状态（0：进行中 1：已完成）
@property (nonatomic,strong) NSNumber *taskState;
///创建时间
@property (nonatomic,copy) NSString *createTime;
///任务附件集合
@property (nonatomic,strong) NSArray <ProjectTaskFileModel *>*taskFiles;
///任务反馈集合
@property (nonatomic,strong) NSArray <ProjectFeedbackModel *>*taskFeedbacks;

///自定义参数 是否展开列表
@property (nonatomic,assign) BOOL isOn; //default YES

///自定义反馈cell高度
@property (nonatomic,assign) CGFloat feedBackCellHeight; //default-1 -1表示未计算过

//构建方法
+ (NSArray *)parsingArrayWithList:(NSArray *)list;

@end


#pragma mark -任务附件集合

@interface ProjectTaskFileModel : NSObject
///任务附件id
@property (nonatomic,copy,getter=fileId) NSString *id;
///附件地址
@property (nonatomic,copy) NSString *fileUrl;
///附件名称
@property (nonatomic,copy) NSString *fileName;
///附件类型（7：图片，11：doc，12：xls，13：ppt）
//@property (nonatomic,strong) NSNumber *fileType;
@property (nonatomic,copy) NSString *fileType;

//构建方法
+ (NSArray *)parsingArrayWithList:(NSArray *)list;

@end


#pragma mark -任务反馈集合

@interface ProjectFeedbackModel : NSObject
///任务反馈id
@property (nonatomic,copy,getter=feedbackId) NSString *id;
///任务id
@property (nonatomic,copy) NSString *taskId;
///反馈内容
@property (nonatomic,copy) NSString *contents;
///反馈人姓名
@property (nonatomic,copy) NSString *createByName;
///创建时间
@property (nonatomic,copy) NSString *createTime;
///任务反馈附件集合
@property (nonatomic,strong) NSArray <ProjectTaskFileModel *>*taskFeedFiles;


///自定义反馈内容cell高度
@property (nonatomic,assign) CGFloat contentCellHeight; //default-1 -1表示未计算过

//构建方法
+ (NSArray *)parsingArrayWithList:(NSArray *)list;



@end










