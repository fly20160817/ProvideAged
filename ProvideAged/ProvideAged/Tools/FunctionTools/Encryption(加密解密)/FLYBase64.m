//
//  FLYBase64.m
//  FLYKit
//
//  Created by fly on 2021/10/25.
//

#import "FLYBase64.h"

@implementation FLYBase64

/// base64编码
/// @param string 需要编码的字符串
+ (NSString *)base64Encode:(NSString *)string
{
    if ( string == nil )
    {
        return nil;
    }

    //把字符串转成二进制
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];

    //进行base64加密,得到加密后的字符串
    NSString * str = [self base64EncodeWithData:data];

    return str;
}

/// base64解码
/// @param string 需要解码的字符串
+ (NSString *)base64Decode:(NSString *)string
{
    if ( string == nil )
    {
        return nil;
    }

    //对加密的字符串进行解密
    NSData * data = [self base64DecodeReturnData:string];

    //把解密后的二进制转成字符串
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return str;
}


/// base64编码 （传入data）
/// @param data 需要编码的字符串
+ (NSString *)base64EncodeWithData:(NSData *)data
{
    //进行base64加密,得到加密后的字符串
    NSString * str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    return str;
}

/// base64解码 (返回data)
/// @param string 需要解码的字符串
+ (NSData *)base64DecodeReturnData:(NSString *)string
{
    //对加密的字符串进行解密
    NSData * data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return data;
}

@end
