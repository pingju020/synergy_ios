//
//  BackMoneyTableViewCell.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreditModel;

@protocol BankMoneyPassValue <NSObject>

- (void)BankMoneyPassValue:(NSString*)Text;

@end
@interface BackMoneyTableViewCell : UITableViewCell
@property(nonatomic,strong) id<BankMoneyPassValue>delegate;
@property(nonatomic,assign)BOOL isTableHeader;
@property(nonatomic,strong)CreditModel* model;
@end
