//
//  FolderModel.h
//  Cooperation
//
//  Created by Tion on 17/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FolderModel : NSObject
@property (nonatomic,strong)NSString* stageModuleId;//文件夹id
@property (nonatomic,strong)NSString* stageModuleName;//文件夹名称
@property (nonatomic,strong)NSString* num;//从属文件数量
@end
