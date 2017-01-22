//
//  ViewButtonModel.h
//  Cooperation
//
//  Created by yangjuanping on 2017/1/22.
//  Copyright © 2017年 Tion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, E_BUTTON_TYPE){
    E_BUTTON_TYPE_LINE = 0,
    E_BUTTON_TYPE_RIGHTARROW,
};
@interface ViewButtonModel : NSObject
@property(nonatomic,assign)E_BUTTON_TYPE buttonType;
@property(nonatomic,strong)NSString* Name;
@property(nonatomic,strong)UIViewController* vc;
@end
