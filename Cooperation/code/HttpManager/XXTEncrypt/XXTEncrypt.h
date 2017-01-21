//
//  XXTEncrypt.h
//

#import <Foundation/Foundation.h>

@interface XXTEncrypt : NSObject
+(NSString *) XXTmd5: (NSString *) inputString ;
+(NSString *) XXTmd5_base64: (NSString *) inputString;
+(NSString *) extendDES: (NSString *) Token ;

+(NSString *)extendDESWithAds: (NSString *) userID userType:(NSString *)type;
+(NSString *) extendDESForClassSpace: (NSString *) Token ;
+(NSString *) extendDES: (NSString *) Token withKey:(NSString*)strKey;

+(NSString *)encodeDES:(NSString *)Token;
+(NSString *) decryptDES: (NSString *) Token;

//  获取udid
+(NSString *)getUDID;
@end
