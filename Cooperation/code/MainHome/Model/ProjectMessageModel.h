//
//  ProjectMessageModel.h
//  Cooperation
//
//  Created by Tion on 17/1/20.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectMessageModel : NSObject

//createDate = "2017-01-19";
//id = c4c99844497a4d799bc4ad037bea2d40;
//isTop = 0;
//projectName = "\U6d4b\U8bd52";
//projectStages = "<null>";
//stageId = "<null>";
//stageName = "\U672a\U5f00\U59cb";
//state = 0;
//userName = "\U4ed8\U5fd7\U8fdc";

@property (nonatomic,strong) NSString* createDate;
@property (nonatomic,strong) NSString* id;
@property (nonatomic,strong) NSString* isTop;
@property (nonatomic,strong) NSString* projectName;
@property (nonatomic,strong) NSString* projectStages;
@property (nonatomic,strong) NSString* stageId;
@property (nonatomic,strong) NSString* stageName;
@property (nonatomic,strong) NSString* state;
@property (nonatomic,strong) NSString* userName;

@property (nonatomic, strong) NSString *MessageInfo;
@property (nonatomic) BOOL Mark;
@property (nonatomic, strong) NSString *Status;
@property (nonatomic) BOOL Red;

- (instancetype)initWithDic:(NSMutableDictionary*)dic;

@end
