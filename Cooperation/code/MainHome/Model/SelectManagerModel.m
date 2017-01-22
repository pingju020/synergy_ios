//
//  SelectManagerModel.m
//  Cooperation
//
//  Created by Tion on 17/1/21.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "SelectManagerModel.h"
#import "Tools.h"
@implementation SelectManagerModel

-(instancetype)initWithDic:(NSDictionary*)dic{
    self=[super init];
    if(dic){
        self.Mark=NO;
        self.name=[Tools replaceUnicode:[dic objectForKey:@"userName"]];
        self.peopleid=[dic objectForKey:@"id"];
        self.ImageUrlString=[dic objectForKey:@"photo"];
    }
    return self;
}

@end
