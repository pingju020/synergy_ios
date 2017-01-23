//
//  ProjectStageFileCell.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectStageFileCell : UITableViewCell

//赋值

//文档信息
- (void)setFileInfoWithFileType:(NSInteger)fileType title:(NSString *)title;

//反馈内容
- (void)setContentWithName:(NSString *)name text:(NSString *)text;

//时间
- (void)setCreateTime:(NSString *)createTime;

@end
