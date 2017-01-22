//
//  SelectManagerModel.h
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectManagerModel : NSObject

@property(nonatomic,strong) NSString* peopleid;
@property(nonatomic,strong) NSString* name;
@property(nonatomic) BOOL Mark;
@property(nonatomic,strong) NSString* ImageUrlString;
-(instancetype)initWithDic:(NSDictionary*)dic;

@end
