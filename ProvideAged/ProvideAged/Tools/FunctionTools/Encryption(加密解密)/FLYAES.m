//
//  FLYAES.m
//  FLYKit
//
//  Created by fly on 2021/10/25.
//

#import "FLYAES.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation FLYAES

/// AES加密data
/// @param data 需要加密的data
/// @param key 密钥
+ (NSString *)aes128EncryptionWithData:(NSData *)data key:(NSString *)key
{
    //为结束符'\0' +1
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //加密后的data
        NSData * encryptionData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
        //把加密后的data转成base64字符串
        NSString * string = [encryptionData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        return string;
    }
    else
    {
        free(buffer);
        return nil;
    }
    
}

/// AES解密 （返回data）
/// @param content 需要解密的字符串
/// @param key 密钥
+ (NSData *)aes128DecryptionReturnData:(NSString *)content key:(NSString *)key
{
    //先对解密的字符串进行base64解码
    NSData * data = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
     
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess)
    {
        //解密后的data
        NSData * decryptionData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        
        return decryptionData;
    }
    else
    {
        free(buffer);
        return nil;
    }
}

/// AES加密
/// @param content 需要加密的字符串
/// @param key 密钥
+ (NSString *)aes128EncryptionWithString:(NSString *)content key:(NSString *)key
{
    //字符串转data
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    return [self aes128EncryptionWithData:contentData key:key];
}

/// AES 加密字典
/// @param dic 需要加密的字符串
/// @param key 密钥
+ (NSString *)aes128EncryptionWithDic:(NSDictionary *)dic key:(NSString *)key
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    return [self aes128EncryptionWithData:data key:key];
}

/// AES解密
/// @param content 需要解密的字符串
/// @param key 密钥
+ (NSString *)aes128DecryptionReturnString:(NSString *)content key:(NSString *)key
{
    //解密出来的data
    NSData * decryptionData = [self aes128DecryptionReturnData:content key:key];
    
    //把解密后的data转成字符串
    NSString * string = [[NSString alloc] initWithData:decryptionData encoding:NSUTF8StringEncoding];;
    
    return string;
}

@end
