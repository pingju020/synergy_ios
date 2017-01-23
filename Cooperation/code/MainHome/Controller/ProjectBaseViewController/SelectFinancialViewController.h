//
//  SelectFinancialViewController.h
//  Cooperation
//
//  Created by Tion on 17/1/23.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "BaseViewController.h"
@protocol SelectFinancialModel <NSObject>

- (void)SelectFinancialModel:(NSString*)financialId;

@end
@interface SelectFinancialViewController : BaseViewController
@property(nonatomic,strong) id<SelectFinancialModel>delegate;
@end
