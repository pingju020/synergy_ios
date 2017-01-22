//
//  FileModel.h
//  Cooperation
//
//  Created by Tion on 17/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject

@property (nonatomic,strong)NSString* createTime;//创建时间
@property (nonatomic,strong)NSString* fileName;//文件名称
@property (nonatomic,strong)NSString* fileType;//文件类型
@property (nonatomic,strong)NSString* fileUrl;//文件url
@property (nonatomic,strong)NSString* fileid;//文件id
@property (nonatomic,strong)NSString* projectId;//项目id
@property (nonatomic,strong)NSString* createUserName;//创建人
@end
