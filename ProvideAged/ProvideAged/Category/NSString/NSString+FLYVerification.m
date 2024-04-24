//
//  NSString+FLYVerification.m
//  FLYKit
//
//  Created by fly on 2021/8/12.
//

#import "NSString+FLYVerification.h"

@implementation NSString (FLYVerification)


/// 判断密码复杂度是否符合要求 (至少包括字母、数字、特殊字符中任意2种)
/// @param minLength 最小长度
/// @param maxLength 最大长度
- (BOOL)passwordComplexityWithMinLength:(NSUInteger)minLength maxLength:(NSUInteger)maxLength
{
    if ( self.length < minLength || self.length > maxLength )
    {
        return NO;
    }
    
    
    NSArray * array1 = @[ @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z" ];
    
    NSArray * array2 = @[ @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z" ];
    
    NSArray * array3 = @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0" ];

    NSArray * array4 = @[ @"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、" ];

    
    //是否包含小写字母
    __block BOOL smallLetter = NO;
    //是否包含大写字母
    __block BOOL bigLetter = NO;
    //是否包含数字
    __block BOOL number = NO;
    //是否包含特殊符号
    __block BOOL symbol = NO;
    
    __block NSString * tempString = self.copy;

    [array1 enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [self containsString:obj] )
        {
            smallLetter = YES;
                        
            tempString = [tempString stringByReplacingOccurrencesOfString:obj withString:@""];
        }
    }];
    
    [array2 enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [self containsString:obj] )
        {
            bigLetter = YES;
            
            tempString = [tempString stringByReplacingOccurrencesOfString:obj withString:@""];
        }
    }];
    
    [array3 enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [self containsString:obj] )
        {
            number = YES;
            
            tempString = [tempString stringByReplacingOccurrencesOfString:obj withString:@""];
        }
    }];
    
    [array4 enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [self containsString:obj] )
        {
            symbol = YES;
            
            tempString = [tempString stringByReplacingOccurrencesOfString:obj withString:@""];
        }
    }];


    //把小写字母、大写字符、数字、特殊符号全部移除后，如果还存在字符，则直接返回NO
    if ( tempString.length > 0 )
    {
        NSLog(@"存在不合法的特殊字符：%@", tempString);
        return NO;
    }
    
    
    /***************************
     符合的条件小于2个，则返回NO
     ***************************/
    
    NSUInteger i = 0;
    
    if ( smallLetter == YES || bigLetter == YES )
    {
        i += 1;
    }
    
    if ( number == YES )
    {
        i += 1;
    }
    
    if ( symbol == YES )
    {
        i += 1;
    }
    
    
    return i < 2 ? NO : YES;
}


/// 判断密码复杂度是否符合要求
/// @param smallLetterType 小写字母的条件
/// @param bigLetterType 大写字母的条件
/// @param numberType 数字的条件
/// @param symbolType 特殊字符的条件
/// @param minLength 最小长度
/// @param maxLength 最大长度
- (BOOL)passwordComplexityWithSmallLetterType:(FLYConditionType)smallLetterType
    bigLetterType:(FLYConditionType)bigLetterType
    numberType:(FLYConditionType)numberType
    symbolType:(FLYConditionType)symbolType
    minLength:(NSUInteger)minLength
    maxLength:(NSUInteger)maxLength
{
    NSArray * array = @[ @"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、" ];
    
    BOOL result = [self passwordComplexityWithSmallLetterType:smallLetterType bigLetterType:bigLetterType numberType:numberType symbolType:symbolType symbols:array minLength:minLength maxLength:maxLength];
    
    return result;
}


/// 判断密码复杂度是否符合要求 (可以自定义特殊字符，比如特殊字符只允许有下划线，symbols参数传@[@"_"] )
/// @param smallLetterType 小写字母的条件
/// @param bigLetterType 大写字母的条件
/// @param numberType 数字的条件
/// @param symbolType 特殊字符的条件
/// @param symbols 允许存在的特殊字符
/// @param minLength 最小长度
/// @param maxLength 最大长度
- (BOOL)passwordComplexityWithSmallLetterType:(FLYConditionType)smallLetterType
    bigLetterType:(FLYConditionType)bigLetterType
    numberType:(FLYConditionType)numberType
    symbolType:(FLYConditionType)symbolType
    symbols:(NSArray *)symbols
    minLength:(NSUInteger)minLength
    maxLength:(NSUInteger)maxLength
{
    if ( self.length < minLength || self.length > maxLength )
    {
        return NO;
    }
    
    
    NSArray * array1 = @[ @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z" ];
    
    NSArray * array2 = @[ @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z" ];
    
    NSArray * array3 = @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0" ];

    NSArray * array4 = symbols.copy;

    
    //是否包含小写字母
    __block BOOL smallLetter = NO;
    //是否包含大写字母
    __block BOOL bigLetter = NO;
    //是否包含数字
    __block BOOL number = NO;
    //是否包含特殊符号
    __block BOOL symbol = NO;
    
    __block NSString * tempString = self.copy;

    [array1 enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [self containsString:obj] )
        {
            smallLetter = YES;
                        
            tempString = [tempString stringByReplacingOccurrencesOfString:obj withString:@""];
        }
    }];
    
    [array2 enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [self containsString:obj] )
        {
            bigLetter = YES;
            
            tempString = [tempString stringByReplacingOccurrencesOfString:obj withString:@""];
        }
    }];
    
    [array3 enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [self containsString:obj] )
        {
            number = YES;
            
            tempString = [tempString stringByReplacingOccurrencesOfString:obj withString:@""];
        }
    }];
    
    [array4 enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [self containsString:obj] )
        {
            symbol = YES;
            
            tempString = [tempString stringByReplacingOccurrencesOfString:obj withString:@""];
        }
    }];


    //把小写字母、大写字符、数字、特殊符号全部移除后，如果还存在字符，则直接返回NO
    if ( tempString.length > 0 )
    {
        NSLog(@"存在不合法的特殊字符：%@", tempString);
        return NO;
    }
    
    
    /***************************
     1.不包含 的时候 包含了
     2.必需包含 的时候 没包含
     排除上面两种错的，其他都是符合要求的。
     ***************************/
    
    if ( smallLetterType == FLYConditionTypeNot && smallLetter == YES )
    {
        return NO;
    }
    
    if ( smallLetterType == FLYConditionTypeMust && smallLetter == NO )
    {
        return NO;
    }
    
    if ( bigLetterType == FLYConditionTypeNot && bigLetter == YES )
    {
        return NO;
    }
    
    if ( bigLetterType == FLYConditionTypeMust && bigLetter == NO )
    {
        return NO;
    }
    
    if ( numberType == FLYConditionTypeNot && number == YES )
    {
        return NO;
    }
    
    if ( numberType == FLYConditionTypeMust && number == NO )
    {
        return NO;
    }
    
    if ( symbolType == FLYConditionTypeNot && symbol == YES )
    {
        return NO;
    }
    
    if ( symbolType == FLYConditionTypeMust && symbol == NO )
    {
        return NO;
    }
    
    return YES;
}


/** 判断邮箱合法性 */
- (BOOL)verificationEmail
{
    NSString *emailRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/** 判断身份证号合法性 */
- (BOOL)verificationIDCard
{
    //长度不为18的都排除掉
    if ( self.length != 18 )
    {
        return NO;
    }
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:self];
    
    if (!flag)
    {
        return flag;    //格式错误
    }
    
    
    //格式正确再判断是否合法
    
    //将前17位加权因子保存在数组里
    NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++)
    {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        
        idCardWiSum += subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    
    //得到最后一位身份证号码
    NSString * idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
    
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if( idCardMod == 2 )
    {
        if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

@end
