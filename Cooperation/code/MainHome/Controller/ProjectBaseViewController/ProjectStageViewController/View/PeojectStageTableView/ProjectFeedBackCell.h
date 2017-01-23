//
//  ProjectFeedBackCell.h
//  Cooperation
//
//  Created by 葛君语 on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectTaskModel;

@protocol ProjectFeedBackDelegate <NSObject>

- (void)projectReadFile:(NSString *)fileUrl;

@end

@interface ProjectFeedBackCell : UITableViewCell

@property (nonatomic,strong) ProjectTaskModel *taskModel;

@property (nonatomic,weak) id <ProjectFeedBackDelegate> delegate;

+ (CGFloat)getHeightWith:(ProjectTaskModel *)taskModel tableWidth:(CGFloat)tableWidth;//获取高度并缓存



@end
