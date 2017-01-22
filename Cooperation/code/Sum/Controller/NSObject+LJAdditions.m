//
//  NSObject+LJAdditions.m
//  jialin
//
//  Created by LeonJing on 4/7/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

#import "NSObject+LJAdditions.h"
#import <objc/runtime.h>

@implementation NSObject (LJAdditions)

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 关联对象

- (void)lj_setValue:(id)value forKey:(NSString *)key
{
    NSAssert(key.length, @"参数 key 为空字符串或 nil.");
    
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
        [self setValue:value forKey:key];
    }
    else
    {
        objc_setAssociatedObject(self, NSSelectorFromString(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id)lj_valueForKey:(NSString *)key
{
    NSAssert(key.length, @"参数 key 为空字符串或 nil.");
    
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
        return [self valueForKey:key];
    }
    else
    {
        return objc_getAssociatedObject(self, NSSelectorFromString(key));
    }
}
@end
