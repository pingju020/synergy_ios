//
//  NSString+LJAdditions.m
//  jialin
//
//  Created by LeonJing on 4/7/16.
//  Copyright © 2016 sanlimi  . All rights reserved.
//

#import "NSString+LJAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LJAdditions)

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 常用

- (BOOL)lj_isEmpty
{
    return self.length == 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 文本范围

- (CGSize)lj_sizeWithBoundingSize:(CGSize)size font:(UIFont *)font
{
    NSAssert(font, @"参数 font 为 nil.");
    NSAssert(size.width && size.height, @"参数 size 的宽高必须大于 0. => %@", NSStringFromCGSize(size));
    
    return CGRectIntegral([self boundingRectWithSize:size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{ NSFontAttributeName : font }
                                             context:nil]).size;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 表单验证

- (BOOL)lj_evaluateWithRegularExpression:(NSString *)regularExpression
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpression];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)lj_isPhoneNumber
{
    /*
     三大运营商最新号段 合作版 共 36 个.
     移动号段：
     134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188
     联通号段：
     130 131 132 145 155 156 175 176 185 186
     电信号段：
     133 153 177 180 181 189
     虚拟运营商:
     170
     ------------------
     13x 系列: 130, 131, 132, 133, 134, 135, 136, 137, 138, 139. (全段.)
     14x 系列: 145, 147.
     15x 系列: 150, 151, 152, 153, 155, 156, 157, 158, 159. (唯独没有 154, 因为不吉利吗?)
     17x 系列: 170, 175, 176, 177, 178.
     18x 系列: 180, 181, 182, 183, 184, 185, 186, 187, 188, 189. (全段.吉利号有市场吗?)
     */
    
    /*
     3\d
     4[57]
     5[012356789]
     8\d
     第2,3位的判断条件为 ([38]\\d|4[57]|5[012356789])
     */
    return [self lj_evaluateWithRegularExpression:@"^1([38]\\d|4[57]|5[012356789])\\d{8}$"];
}

- (BOOL)lj_isEmail
{
    /*
     邮件地址一般是: 字母, 数字, "_". 有的还能有 ".", "-". 一般4-18字符.各种邮箱要求不一...
     域名几乎都是 abc.com, abc.cn, 123.com, 123.cn 这种形式.
     ^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$
     ^([a-zA-Z0-9\\.\\-_]+)@([a-zA-Z0-9]+)\\.(com|cn)$
     */
    return [self lj_evaluateWithRegularExpression:@"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 加密处理

typedef unsigned char *LXDigestFunction(const void *data, CC_LONG len, unsigned char *md);

- (NSString *)lj_hashStringWithDigestLength:(CC_LONG)digestLength
                             digestFunction:(LXDigestFunction)digestFunction
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[digestLength];
    
    digestFunction(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *hashedString = [NSMutableString new];
    
    for(CC_LONG i = 0; i < digestLength; ++i) {
        [hashedString appendFormat:@"%02x", digest[i]];
    }
    
    return hashedString;
}

- (NSString *)lj_MD5
{
    return [self lj_hashStringWithDigestLength:CC_MD5_DIGEST_LENGTH digestFunction:CC_MD5];
}

- (NSString *)lj_SHA1
{
    return [self lj_hashStringWithDigestLength:CC_SHA1_DIGEST_LENGTH digestFunction:CC_SHA1];
}

- (NSString *)lj_SHA224
{
    return [self lj_hashStringWithDigestLength:CC_SHA224_DIGEST_LENGTH digestFunction:CC_SHA224];
}

- (NSString *)lj_SHA256
{
    return [self lj_hashStringWithDigestLength:CC_SHA256_DIGEST_LENGTH digestFunction:CC_SHA256];
}

- (NSString *)lj_SHA384
{
    return [self lj_hashStringWithDigestLength:CC_SHA384_DIGEST_LENGTH digestFunction:CC_SHA384];
}

- (NSString *)lj_SHA512
{
    return [self lj_hashStringWithDigestLength:CC_SHA512_DIGEST_LENGTH digestFunction:CC_SHA512];
}

#pragma mark -
- (NSDate *)lj_dateWithFormat:(NSString *)format{
    NSAssert(nil != format, @"时间格式=nil");
    NSDateFormatter*fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:format];
    return [fmt dateFromString:self];
}

- (NSNumber*)lj_numberValue{
    NSNumberFormatter *f = [[NSNumberFormatter alloc]init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    return [f numberFromString:self];
}

@end
