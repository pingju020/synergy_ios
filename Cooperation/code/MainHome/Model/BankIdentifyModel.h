//
//  BankIdentifyModel.h
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankIdentifyModel : NSObject
@property(nonatomic,strong) NSString* id;//分行id
@property(nonatomic,strong) NSString* name;//分行名称
@property(nonatomic,strong) NSMutableArray* orgViews;//支行
-(instancetype)initWithDic:(NSDictionary*)dic;
@end
