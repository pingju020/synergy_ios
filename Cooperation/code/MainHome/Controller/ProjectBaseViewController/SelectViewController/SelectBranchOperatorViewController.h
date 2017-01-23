//
//  SelectBranchOperatorViewController.h
//  Cooperation
//
//  Created by Tion on 17/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BaseViewController.h"
@protocol SelectBranchOperatorModel <NSObject>

- (void)SelectBranchOperator:(NSMutableArray*)bankArray;

@end
@interface SelectBranchOperatorViewController : BaseViewController
@property(nonatomic,strong) id<SelectBranchOperatorModel>delegate;
- (instancetype)initWithBranchId:(NSString *)branchId;
@end
