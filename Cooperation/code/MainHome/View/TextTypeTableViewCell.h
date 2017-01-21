//
//  TextTypeTableViewCell.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FactorModel;

@interface TextTypeTableViewCell : UITableViewCell
@property(nonatomic,assign)BOOL bEdit;
@property(nonatomic,strong)FactorModel* model;
@end
