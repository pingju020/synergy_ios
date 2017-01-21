//
//  BaseInfomationViewController.h
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BaseViewController.h"


// 该页面有两个状态，一个是新建项目，一个是查看项目。
typedef NS_ENUM(NSInteger, E_INFO_TYPE){
    E_INFO_EDIT = 0, // 新建项目时，项目id为空，需要另外指定项目的负责人和名称
    E_INFO_VIEW,     // 查看项目时，项目id不为空
};

@interface BaseInfomationViewController : BaseViewController

-(id)initWithProjectId:(NSString*)projectId ProjectName:(NSString*)projectName type:(E_INFO_TYPE)type;
@end
