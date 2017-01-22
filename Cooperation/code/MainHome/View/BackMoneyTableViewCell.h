//
//  BackMoneyTableViewCell.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreditModel;

@interface BackMoneyTableViewCell : UITableViewCell
@property(nonatomic,assign)BOOL isTableHeader;
@property(nonatomic,strong)CreditModel* model;
@end
