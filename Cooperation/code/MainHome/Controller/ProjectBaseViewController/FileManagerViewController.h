//
//  FileManagerViewController.h
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BaseViewController.h"

@interface FileManagerViewController : BaseViewController
@property(nonatomic,strong)BaseViewController* backVC;

-(instancetype)initWithProjectId:(NSString*)projectId;

@end
