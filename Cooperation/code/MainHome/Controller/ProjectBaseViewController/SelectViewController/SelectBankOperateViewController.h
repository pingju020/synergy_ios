//
//  SelectBankOperateViewController.h
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BaseViewController.h"
@protocol SelectBankModel <NSObject>

- (void)SelectBankModel:(NSMutableDictionary*)bankDic;

@end
@interface SelectBankOperateViewController : BaseViewController
@property(nonatomic,strong) id<SelectBankModel>delegate;
@end
