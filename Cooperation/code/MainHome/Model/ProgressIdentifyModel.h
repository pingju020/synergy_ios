//
//  ProgressIdentifyModel.h
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressIdentifyModel : NSObject

//@property(nonatomic,strong) NSString*
@property(nonatomic,strong) NSString* id;
@property(nonatomic,strong) NSString* name;
-(instancetype)initWithDic:(NSDictionary*)dic;
@end
