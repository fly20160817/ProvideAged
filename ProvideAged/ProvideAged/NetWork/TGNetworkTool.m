//
//  TGNetworkTool.m
//  FLYKit
//
//  Created by fly on 2021/10/9.
//

#import "TGNetworkTool.h"
#import "AFNetworking.h"
#import "NSDate+FLYExtension.h"
#import "FLYBase64.h"
#import "FLYHash.h"

static NSString * kBaseUrl = TGBASE_API;

@interface TGHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end

@implementation TGHTTPSessionManager

+ (instancetype)sharedManager {
    
    static TGHTTPSessionManager * sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //配置超时时长 (默认60s)
        config.timeoutIntervalForRequest = 15;
        
        sessionManager = [[TGHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] sessionConfiguration:config];
        //接收参数类型
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif",nil];
 
    });
    
    return sessionManager;
}

@end

@implementation TGNetworkTool

/// get网络请求
/// @param path url地址
/// @param params 参数
/// @param success 请求成功回调
/// @param failure 请求失败回调
+ (void)getWithPath:(NSString *)path
            params:(NSDictionary *)params
            success:(SuccessBlock)success
            failure:(FailureBlock)failure
{
    FLYNetworkLoadingType loadingType = FLYNetworkLoadingTypeInteraction;
    NSString * loadingTitle = @"请稍后";
    BOOL isHandle = YES;
    
    [self getWithPath:path params:params loadingType:loadingType loadingTitle:loadingTitle isHandle:isHandle success:success failure:failure];
}

/// get网络请求
/// @param path url地址
/// @param params 参数
/// @param loadingType loading类型
/// @param loadingTitle loading文字
/// @param isHandle 返回结果是否需要内部处理（YES 只返回200的情况，其他状态码或请求失败都show出错误信息；NO  任何状态都直接返回出来给外界处理，不show任何信息）
/// @param success 请求成功回调
/// @param failure 请求失败回调
+ (void)getWithPath:(NSString *)path
            params:(NSDictionary *)params
            loadingType:(FLYNetworkLoadingType)loadingType
            loadingTitle:(nullable NSString *)loadingTitle
            isHandle:(BOOL)isHandle
            success:(SuccessBlock)success
            failure:(FailureBlock)failure
{
    [self setupLoadingType:loadingType title:loadingTitle showProgress:NO];
    
    
    /** 添加四个固定的参数 */
    
    
    NSMutableDictionary * dic = params.mutableCopy;
    [dic setValue:TGACCESSKEY forKey:@"access_key"];
    [dic setValue:TGAPPID forKey:@"appid"];
    [dic setValue:[NSDate currentTimeStamp] forKey:@"timestamp"];
    
    //sign一定要最后设置，等其他参数都放进字典了，才开始签名算法
    NSString * sign = [self getSign:dic];
    [dic setValue:sign forKey:@"sign"];
    
    params = dic.copy;
    
        
    [[TGHTTPSessionManager sharedManager] GET:path parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self successHandle:isHandle loadingType:loadingType json:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self failureHandle:isHandle loadingType:loadingType error:error failure:failure];
        
    }];
}



#pragma mark - private methods

///  设置Loading
/// @param type 类型
/// @param title 文字
/// @param showProgress 是否显示进度 (上传和下载传YES)
+ (void)setupLoadingType:(FLYNetworkLoadingType)type
                   title:(nullable NSString *)title showProgress:(BOOL)showProgress
{
    if ( type != FLYNetworkLoadingTypeNone )
    {
        showProgress == YES ? [SVProgressHUD showProgress:0 status:title] : [SVProgressHUD showWithStatus:title];
    }
    
    if ( type == FLYNetworkLoadingTypeInteraction )
    {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    }
    else if ( type == FLYNetworkLoadingTypeNotInteractionClear )
    {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
    else if ( type == FLYNetworkLoadingTypeNotInteractionBlack )
    {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    }
}

/// 请求成功的处理
/// @param isHandle 返回结果是否需要内部处理
/// @param json 返回的数据
/// @param success 成功回调
/// @param failure 失败回调
+ (void)successHandle:(BOOL)isHandle loadingType:(FLYNetworkLoadingType)loadingType json:(id)json success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ( loadingType != FLYNetworkLoadingTypeNone )
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    }
    
    if ( [json[@"code"] integerValue] != 200 && isHandle )
    {
        [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        
        failure(json);
    }
    else
    {
        success(json);
    }
}

/// 请求失败的处理
/// @param isHandle 返回结果是否需要内部处理
/// @param error 错误
/// @param failure 失败回调
+ (void)failureHandle:(BOOL)isHandle loadingType:(FLYNetworkLoadingType)loadingType error:(NSError *)error failure:(FailureBlock)failure
{
    if ( loadingType != FLYNetworkLoadingTypeNone )
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    }
    
    if( isHandle )
    {
        [FLYNetwork getNetType:^(BOOL network) {
            
            [SVProgressHUD showInfoWithStatus:network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }];
    }
    
    failure(error);
}

+ (NSString *)getSign:(NSDictionary *)params
{
    NSMutableDictionary * dic = params.mutableCopy;
    //签名算法不需要access_key
    [dic removeObjectForKey:@"access_key"];
    
    
    //对字典的key进行生序排序
    NSArray * keyArray = [dic allKeys];
    NSArray * sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    
    //按照排序好的key，去取Value，并将Value按顺序放进数组
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray)
    {
        [valueArray addObject:[dic objectForKey:sortString]];
    }
    
    
    //排序后，按照从小到大的顺序，依次将每个键值对用=拼接起来，再使用&将所有键值对字符串拼接成一个字符串
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++)
    {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    
    NSString *sign = [signArray componentsJoinedByString:@"&"];
    
    //base64对sign进行编码
    sign = [FLYBase64 base64Encode:sign];
    
    //base64后的结果，使用access_key对应的secret_key作为密钥，调用hmac_sha1算法计算哈希值
    sign = [FLYHash hmacSHA1:sign key:TGSECRETKEY];
    
    
    return sign;
}


@end
