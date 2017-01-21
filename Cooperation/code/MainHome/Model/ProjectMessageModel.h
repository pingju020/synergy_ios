//
//  ProjectMessageModel.h
//  Cooperation
//
//  Created by Tion on 17/1/20.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectMessageModel : NSObject


@property (nonatomic, strong) NSString *MessageInfo;
@property (nonatomic) BOOL Mark;
@property (nonatomic, strong) NSString *Status;
@property (nonatomic) BOOL Red;
//@property (nonatomic, strong) NSString *avatar;
//@property (nonatomic, strong) NSString *userType;
//@property (nonatomic, strong) NSString *token;
//@property (nonatomic, strong) NSString *replyName;
//@property (nonatomic, strong) NSString *creditScore;
//@property (nonatomic, strong) NSString *creditScoreEndtime;
//@property (nonatomic, strong) NSString *isSign;
//@property (nonatomic, strong) NSString *isChat;

- (instancetype)initWithDic:(NSMutableDictionary*)dic;

@end
