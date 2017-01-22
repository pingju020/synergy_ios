//
//  ProjectReplyTableViewCell.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectReplyModel.h"

@interface ReplyLabel : UILabel
-(void)setChangeModel:(ChangeModel*)model withName:(NSString*)name;
@end

@interface ProjectReplyTableViewCell : UITableViewCell
-(void)setModel:(ChangeModel*)model Name:(NSString*)name;
@end
