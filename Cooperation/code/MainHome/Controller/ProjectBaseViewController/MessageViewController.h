//
//  MessageViewController.h
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BaseViewController.h"
#import "XHMessageTableViewController.h"

@interface MessageViewController : XHMessageTableViewController
@property(nonatomic,strong)BaseViewController* backVC;
@property (nonatomic,strong) NSString* projectId;

@end
