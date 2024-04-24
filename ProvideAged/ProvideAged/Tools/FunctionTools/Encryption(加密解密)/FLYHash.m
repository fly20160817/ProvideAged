//
//  FLYHash.m
//  FLYKit
//
//  Created by fly on 2021/10/25.
//

#import "FLYHash.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation FLYHash


/// MD5信息摘要算法
/// @param string 信息
+ (NSString *)MD5:(NSString *)string
{
    const char *str = string.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

/// SHA1算法
+ (NSString *)sha1:(NSString *)string
{
    const char *str = string.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

/// SHA224算法
+ (NSString *)sha224:(NSString *)string
{
    const char *str = string.UTF8String;
    uint8_t buffer[CC_SHA224_DIGEST_LENGTH];
    
    CC_SHA224(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA224_DIGEST_LENGTH];
}

/// SHA256算法
+ (NSString *)sha256:(NSString *)string
{
    const char *str = string.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

/// SHA384算法
+ (NSString *)sha384:(NSString *)string
{
    const char *str = string.UTF8String;
    uint8_t buffer[CC_SHA384_DIGEST_LENGTH];
    
    CC_SHA384(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA384_DIGEST_LENGTH];
}

/// SHA512算法
+ (NSString *)sha512:(NSString *)string
{
    const char *str = string.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

/// HmacMD5 (带密钥的MD5)
/// @param string 字符串
/// @param key 密钥
+ (NSString *)hmacMD5:(NSString *)string key:(NSString *)key
{
    const char *keyData = key.UTF8String;
    const char *strData = string.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

/// hmacSHA1 (带密钥的SHA1)
/// @param string 字符串
/// @param key 密钥
+ (NSString *)hmacSHA1:(NSString *)string key:(NSString *)key
{
    const char *keyData = key.UTF8String;
    const char *strData = string.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

/// hmacSHA224 (带密钥的SHA224)
/// @param string 字符串
/// @param key 密钥
+ (NSString *)hmacSHA224:(NSString *)string key:(NSString *)key
{
    const char *keyData = key.UTF8String;
    const char *strData = string.UTF8String;
    uint8_t buffer[CC_SHA224_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA224, keyData, strlen(keyData), strData, strlen(strData), buffer);

    return [self stringFromBytes:buffer length:CC_SHA224_DIGEST_LENGTH];
}

/// hmacSHA256 (带密钥的SHA256)
/// @param string 字符串
/// @param key 密钥
+ (NSString *)hmacSHA256:(NSString *)string key:(NSString *)key
{
    const char *keyData = key.UTF8String;
    const char *strData = string.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

/// hmacSHA384 (带密钥的SHA384)
/// @param string 字符串
/// @param key 密钥
+ (NSString *)hmacSHA384:(NSString *)string key:(NSString *)key
{
    const char *keyData = key.UTF8String;
    const char *strData = string.UTF8String;
    uint8_t buffer[CC_SHA384_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA384, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA384_DIGEST_LENGTH];
}

/// hmacSHA512 (带密钥的SHA512)
/// @param string 字符串
/// @param key 密钥
+ (NSString *)hmacSHA512:(NSString *)string key:(NSString *)key
{
    const char *keyData = key.UTF8String;
    const char *strData = string.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}



#pragma mark - private methods

/**
 *  返回二进制 Bytes 流的字符串表示形式
 *
 *  @param bytes  二进制 Bytes 数组
 *  @param length 数组长度
 *
 *  @return 字符串表示形式
 */
+ (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length
{
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++)
    {
        //这里小写x，转出来就是小写的；还成大写X,转出来就是大写的。
        [strM appendFormat:@"%02X", bytes[i]];
    }
    
    return [strM copy];
}


@end
