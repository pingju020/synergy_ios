//
//  ProjectMessageModel.m
//  Cooperation
//
//  Created by Tion on 17/1/20.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import "ProjectMessageModel.h"
#import "Tools.h"
@implementation ProjectMessageModel

- (instancetype)initWithDic:(NSMutableDictionary *)dic{
    self=[super init];
    if(dic!=nil){
        self.createDate=[dic objectForKey:@"createDate"];
        self.id=[dic objectForKey:@"id"];
        NSNumber* num=[dic objectForKey:@"isTop"];
        self.isTop=[NSString stringWithFormat:@"%@",num];
        self.state=[dic objectForKey:@"state"];
        
//        self.projectName=[dic objectForKey:@"projectName"];
        if([dic objectForKey:@"projectName"]){
            self.projectName=[dic objectForKey:@"projectName"];
        }
        else{
            NSDictionary* mydic=[dic objectForKey:@"project"];
            self.projectName=[mydic objectForKey:@"projectName"];
        }
        self.stageName=[dic objectForKey:@"stageName"];
        self.userName=[dic objectForKey:@"userName"];
        
//        self.projectName=[Tools replaceUnicode:[dic objectForKey:@"projectName"]];
//        self.stageName=[Tools replaceUnicode:[dic objectForKey:@"stageName"]];
//        self.userName=[Tools replaceUnicode:[dic objectForKey:@"userName"]];
        
        
        if([dic objectForKey:@"projectStages"]){
            self.projectStages=[dic objectForKey:@"projectStages"];
        }
        if([dic objectForKey:@"projectStages"]){
            self.stageId=[dic objectForKey:@"stageId"];
        }
    }
    return self;
}

@end
