//
//  FLYNetwork.m
//  FLYKit
//
//  Created by fly on 2021/10/9.
//

#import "FLYNetwork.h"
#import "AFNetworking.h"

static NSString * kBaseUrl = BASE_API;

@interface FLYHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end

@implementation FLYHTTPSessionManager

+ (instancetype)sharedManager {
    
    static FLYHTTPSessionManager * sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //配置超时时长 (默认60s)
        config.timeoutIntervalForRequest = 15;
       
        sessionManager = [[FLYHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] sessionConfiguration:config];
        //接收参数类型
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif",nil];
        // 设置超时时间
        //sessionManager.requestSerializer.timeoutInterval = 15;
        // 设置token
        //[sessionManager.requestSerializer setValue:[FLYUser sharedUser].token forHTTPHeaderField:@"token"];
        
        //加这两句，适配raw类型的请求
        //设置请求体数据为json类型
        sessionManager.requestSerializer  = [AFJSONRequestSerializer serializer];
        //设置响应体数据为json类型
        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        if ( [FLYUser sharedUser].token )
        {
            [sessionManager.requestSerializer setValue:[FLYUser sharedUser].token forHTTPHeaderField:@"token"];
        }
        
        // 修改：1.修改token设置的方法。 2.加那两句，适配raw类型的请求 3.postRaw方法直接调用post

    });
    
    return sessionManager;
}

@end

@implementation FLYNetwork

/**
 *  get网络请求
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功 返回NSDictionary或NSArray
 *  @param failure 请求失败 返回NSError
 */
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(SuccessBlock)success
            failure:(FailureBlock)failure
{
    [[FLYHTTPSessionManager sharedManager] GET:path parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}

/**
 *  post网络请求
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功 返回NSDictionary或NSArray
 *  @param failure 请求失败 返回NSError
 */
+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(SuccessBlock)success
             failure:(FailureBlock)failure
{
    [[FLYHTTPSessionManager sharedManager] POST:path parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}

/**
 *  get网络请求（raw格式）
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功 返回NSDictionary或NSArray
 *  @param failure 请求失败 返回NSError
 */
+ (void)getRawWithPath:(NSString *)path
             params:(id)params
            success:(SuccessBlock)success
            failure:(FailureBlock)failure
{
    //转换成NSData对象
    NSData *data = [NSData data];
    if ( [params isKindOfClass:[NSDictionary class]] )
    {
        data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    }
    else if ( [params isKindOfClass:[NSString class]] )
    {
        data = [params dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSString * URLString = [[NSURL URLWithString:path relativeToURL:[FLYHTTPSessionManager sharedManager].baseURL] absoluteString];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    request.HTTPBody = data;
    
    [[[FLYHTTPSessionManager sharedManager] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            
            success(responseObject);
            
        } else {
            
            failure(error);
            
        }
    }] resume];
    
}

/**
 *  post网络请求（raw格式）
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功 返回NSDictionary或NSArray
 *  @param failure 请求失败 返回NSError
 */
+ (void)postRawWithPath:(NSString *)path
              params:(id)params
             success:(SuccessBlock)success
             failure:(FailureBlock)failure
{
    [FLYNetwork postWithPath:path params:params success:success failure:failure];
}

/**
 *  head网络请求
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功  返回NSURLResponse
 *  @param failure 请求失败  返回NSError
 */
+ (void)headWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(SuccessBlock)success
             failure:(FailureBlock)failure
{
    [[FLYHTTPSessionManager sharedManager] HEAD:path parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task) {
        
        success(task.response);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}

/**
 *  delete网络请求
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功  返回NSDictionary或NSArray
 *  @param failure 请求失败  返回NSError
 */
+ (void)deleteWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(SuccessBlock)success
             failure:(FailureBlock)failure
{
    [[FLYHTTPSessionManager sharedManager] DELETE:path parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}

/**
 *  下载文件
 *
 *  @param path     url路径
 *  @param success  下载成功  返回文件保存的路径
 *  @param failure  下载失败
 *  @param progress 下载进度
 */
+ (void)downloadWithPath:(NSString *)path
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure
                progress:(ProgressBlock)progress
{
    NSURL * url = [NSURL URLWithString:path relativeToURL:[FLYHTTPSessionManager sharedManager].baseURL];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [[FLYHTTPSessionManager sharedManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //获取沙盒的Caches路径,再拼上文件的名字
        NSString * path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        //本地的路径转URL不能使用URLWithString
        NSURL * url = [NSURL fileURLWithPath:path];
        
        //返回要保存文件的路径,不然下完在tmp文件中,不使用就自动删除了
        return url;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error)
        {
            failure(error);
        }
        else
        {
            success(filePath.path);
        }
        
    }];
    
    [downloadTask resume];
}

/**
 *  上传图片(多张)
 *
 *  @param path     url地址
 *  @param params   上传参数
 *  @param imagekey  后端接收文件的字段
 *  @param images   图片数组
 *  @param success  上传成功
 *  @param failure  上传失败
 *  @param progress 上传进度
 */
+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)imagekey
                 images:(NSArray *)images
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure
                   progress:(ProgressBlock)progress
{
    [[FLYHTTPSessionManager sharedManager] POST:path parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < images.count; i ++)
        {
            //上传的名字是当前的时间拼上i的值
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.jpg",str, i];
            
            UIImage *image = images[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            [formData appendPartWithFileData:imageData name:imagekey fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}

/**
 *  上传视频 (多个)
 *
 *  @param path     url地址
 *  @param params   上传参数
 *  @param videokey  后端接收文件的字段
 *  @param videos   视频路径数组
 *  @param success  上传成功
 *  @param failure  上传失败
 *  @param progress 上传进度
 */
+ (void)uploadVideoWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)videokey
                 videos:(NSArray *)videos
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure
                   progress:(ProgressBlock)progress
{
    [[FLYHTTPSessionManager sharedManager] POST:path parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < videos.count; i ++)
        {
            //上传的名字是当前的时间拼上i的值
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.mp4",str, i];

            NSData * videoData = [NSData dataWithContentsOfURL:videos[i]];
            [formData appendPartWithFileData:videoData name:videokey fileName:fileName mimeType:@"application/octet-stream"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}

/// 判断是否有网
/// @param networkBlock 是否有网的回调
+ (void)getNetType:(void(^)(BOOL network))networkBlock
{
    //创建监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //打开检测开始检测网络状态
    [manager startMonitoring];
    
    //监听网络状态的改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                //未知网络
                NSLog(@"未知网络");
                
                networkBlock(NO);
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                //无法联网
                NSLog(@"无法联网");
                
                networkBlock(NO);
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //手机自带网络
                NSLog(@"当前使用的是2g/3g/4g/5g网络");
                
                networkBlock(YES);
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                //WIFI
                NSLog(@"当前在WIFI网络下");
                
                networkBlock(YES);
            }
        }
    }];

}

/// 请求头添加token
/// @param token token
+ (void)setTokenHTTPHeaders:(nullable NSString *)token
{
    //在sharedClient单利里已经设置了Token，但如果执行时没登录，登录后不会再执行了，所以登录后要单独再设置
    [[FLYHTTPSessionManager sharedManager].requestSerializer setValue:token forHTTPHeaderField:@"token"];
}

@end
