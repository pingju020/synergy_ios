//
//  NSArray+LJAdditions.m
//  jialin
//
//  Created by LeonJing on 4/7/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

#import "NSArray+LJAdditions.h"

@implementation NSArray (LJAdditions)
#pragma mark - 常用方法

+ (instancetype)lj_arrayWithResourcePath:(NSString *)path
{
    NSAssert(path.length, @"参数 path 为空字符串或 nil.");
    
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:nil]];
}

#pragma mark - 函数式便捷方法

- (__kindof instancetype)lj_map:(id _Nullable (^)(id _Nonnull, BOOL * _Nonnull))map
{
    NSMutableArray *array = @[].mutableCopy;
    
    if (self.count == 0) {
        return array;
    }
    
    BOOL stop=NO;
    for (id obj in self) {
        id result = map(obj, &stop);
        if (result) {
            [array addObject:result];
        }
        if (stop) {
            return array;
        }
    }
    return array; // 出于性能考虑就不 copy 了.
}

- (instancetype)lj_filter:(BOOL (^)(id _Nonnull))filter
{
    NSMutableArray *array = @[].mutableCopy;
    
    if (self.count == 0) {
        return array;
    }
    
    for (id obj in self) {
        if (filter(obj)) {
            [array addObject:obj];
        }
    }
    return array; // 出于性能考虑就不 copy 了.
}

- (id)lj_reduceWithInitial:(id)initial combine:(id _Nullable (^)(id _Nullable, id _Nonnull))combine
{
    id result = initial;
    
    if (self.count == 0) {
        return result;
    }
    
    for (id item in self) {
        result = combine(result, item);
    }
    return result;
}

#pragma mark - log 增强


-(id) lj_safeObjectAtIndex:(NSUInteger)index {
    if (index>=self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end
