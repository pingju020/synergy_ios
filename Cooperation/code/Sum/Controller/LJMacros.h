//
//  LJMacros.h
//  jialin
//
//  Created by LeonJing on 4/7/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

///------------------------------------------------------------------------------------------------
/// @name log 宏
///------------------------------------------------------------------------------------------------

#pragma mark - log 宏

#ifdef DEBUG

/**
 *  附带 文件名,行号,函数名 的 log 宏.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-zero-variadic-macro-arguments"
#define LJLog(format, ...) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wcstring-format-directive\"") \
NSLog(@"[%@ : %d] %s\n\n%@\n\n", \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
__LINE__, \
__FUNCTION__, \
[NSString stringWithFormat:(format), ##__VA_ARGS__]) \
_Pragma("clang diagnostic pop")
#pragma clang diagnostic pop

/**
 *  打印 CGRect.
 */
#define LJLogRect(rect) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wcstring-format-directive\"") \
LJLog(@"%s => %@", #rect, NSStringFromCGRect(rect)) \
_Pragma("clang diagnostic pop")

/**
 *  打印 CGSize.
 */
#define LJLogSize(size) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wcstring-format-directive\"") \
LJLog(@"%s => %@", #size, NSStringFromCGSize(size)) \
_Pragma("clang diagnostic pop")

/**
 *  打印 CGPoint.
 */
#define LJLogPoint(point) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wcstring-format-directive\"") \
LJLog(@"%s => %@", #point, NSStringFromCGPoint(point)) \
_Pragma("clang diagnostic pop")

/**
 *  打印 NSRange.
 */
#define LJLogRange(range) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wcstring-format-directive\"") \
LJLog(@"%s => %@", #range, NSStringFromRange(range)) \
_Pragma("clang diagnostic pop")

/**
 *  打印 UIEdgeInsets.
 */
#define LJLogInsets(insets) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wcstring-format-directive\"") \
LJLog(@"%s => %@", #insets, NSStringFromUIEdgeInsets(insets)) \
_Pragma("clang diagnostic pop")

/**
 *  打印 NSIndexPath.
 */
#define LJLogIndexPath(indexPath) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wcstring-format-directive\"") \
LJLog(@"%s => %lu - %lu", #indexPath, [indexPath indexAtPosition:0], [indexPath indexAtPosition:1]) \
_Pragma("clang diagnostic pop")

///------------------------------------------------------------------------------------------------
/// @name 调试宏
///------------------------------------------------------------------------------------------------

#pragma mark - 调试宏

#define LJ_BENCHMARKING_BEGIN CFTimeInterval begin = CACurrentMediaTime();
#define LJ_BENCHMARKING_END   CFTimeInterval end   = CACurrentMediaTime(); printf("运行时间: %g 秒.\n", end - begin);

#pragma mark -

#else

#define LJLog(format, ...)
#define LJLogRect(rect)
#define LJLogSize(size)
#define LJLogPoint(point)
#define LJLogRange(range)
#define LJLogInsets(insets)
#define LJLogIndexPath(indexPath)

#define LJ_BENCHMARKING_BEGIN
#define LJ_BENCHMARKING_END

#endif

///UIView
#define UIViewAutoresizingFlexibleAll (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin)

///------------------------------------------------------------------------------------------------
/// @name weak,strong
///------------------------------------------------------------------------------------------------
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


///------------------------------------------------------------------------------------------------
/// @name 单例 宏
///------------------------------------------------------------------------------------------------

#pragma mark - 单例 宏

/**
 *  生成单例接口的宏.
 *
 *  单例使用 dispatch_once 函数实现,禁用了 +allocWithZone: 和 -copyWithZone: 方法.
 *
 *  @param methodName 单例方法名.
 */
#define LJ_SINGLETON_INTERFACE(methodName) + (instancetype)methodName;

/**
 *  生成单例实现的宏.
 */
#define LJ_SINGLETON_IMPLEMENTTATION(methodName) \
\
+ (instancetype)methodName \
{ \
static id sharedInstance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[super allocWithZone:NULL] init]; \
}); \
return sharedInstance; \
} \
\
+ (instancetype)allocWithZone:(__unused struct _NSZone *)zone \
{ \
NSAssert(NO, @"使用单例方法直接获取单例,不要另行创建单例."); \
return [self methodName]; \
} \
\
- (id)copyWithZone:(__unused NSZone *)zone \
{ \
NSAssert(NO, @"使用单例方法直接获取单例,不要另行创建单例."); \
return self; \
}

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
