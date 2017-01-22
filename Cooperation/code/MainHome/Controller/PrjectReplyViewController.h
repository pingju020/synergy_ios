//
//  PrjectReplyViewController.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BaseViewController.h"

@interface PrjectReplyViewController : BaseViewController
@property(nonatomic,strong)BaseViewController* backVC;
-(id)initWithProjectId:(NSString*)projectId ProjectName:(NSString*)projectName;
@end
