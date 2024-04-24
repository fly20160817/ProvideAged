//
//  FLYFileManager.m
//  BuDeJie
//
//  Created by fly on 2019/1/25.
//  Copyright © 2019年 fly. All rights reserved.
//

#import "FLYFileManager.h"

@implementation FLYFileManager


/** 获取Documents文件夹路径 */
+ (NSString *)documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/** 获取Cache文件夹路径 */
+ (NSString *)cachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/** 获取tmp文件夹路径 */
+ (NSString *)tmpPath
{
    return NSTemporaryDirectory();
}


/// 创建文件夹
/// @param name 文件夹名
/// @param path 创建在哪个路径下
/// @return 是否创建成功 (已存在同名文件夹也会返回成功，不会覆盖)
+ (BOOL)createDirectory:(NSString *)name path:(NSString *)path
{
    //在指定目录下拼接新建的文件夹名
    NSString * directoryPath = [path stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //判断是否是文件夹
    BOOL isDirectory = NO;
    
    //返回文件是否存在和是否是文件夹
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
        
    //路径存在，并且是一个文件夹
    if(  existed == YES && isDirectory == YES )
    {
        NSLog(@"文件夹已存在：%@", name);
        return YES;
    }
    
    
    
    NSError *error = nil;
    //创建文件夹 withIntermediateDirectories: 传NO，如果文件夹已存在，则创建失败error会返回错误；传YES，如果文件夹已存在，不会返回错误，也不会重新创建覆盖
    [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if( error )
    {
        NSLog(@"文件夹 %@ 创建失败：%@", name, error);
    }
    else
    {
        NSLog(@"文件夹 %@ 创建成功！", name);
    }
    
    return error ? NO : YES;
}


/// 从路径获取文件
/// @param filePath 路径
+ (NSData *)readDataWithPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //读取文件
    NSData *data = [fileManager contentsAtPath:filePath];
    
    return data;
}


/// 保存文件到指定路径 （同名文件会直接覆盖）
/// @param data 文件
/// @param fileName 文件名
/// @param path 路径
+ (BOOL)saveData:(NSData *)data fileName:(NSString *)fileName path:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString * dataPath = [path stringByAppendingPathComponent:fileName];
    
    BOOL result = [fileManager createFileAtPath:dataPath contents:data attributes:nil];
    
    /** writeToFile方法和上面一样，暂时没有发现有和不同 */
    //NSError * error;
    //BOOL result = [data writeToFile:dataPath options:0 error:&error];
    
    return result;
}


/// 删除文件或文件夹
/// @param filePath 路径
+ (BOOL)removeFileWithPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError * error;
    BOOL result = [fileManager removeItemAtPath:filePath error:&error];
    
    if ( error )
    {
        NSLog(@"删除失败：%@, error = %@", filePath, error);
    }
    
    return result;
}


/** 清理缓存 (清空沙盒的Cache文件夹) */
+ (void)cleanCache
{
    /***
     模拟器可以直接删除Cache文件夹，然后创建一个新的Cache文件夹； 真机没有权限删除Cache文件夹，只能遍历Cache文件夹里面，一个一个删除
     ****/
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取文件夹所有子路径数组 (获取多级目录下文件路径)
    NSArray * subpaths = [fileManager subpathsAtPath:[self cachePath]];
    
    for (NSString * subpath in subpaths)
    {
        //拼接完整文件路径
        NSString * filePath = [[self cachePath] stringByAppendingPathComponent:subpath];
        
        //删除文件
        [fileManager removeItemAtPath:filePath error:nil];
    }
}


/// 判断文件或文件夹是否存在
/// @param filePath 路径
+ (BOOL)fileExistsWithPath:(NSString *)filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}


/// 移动文件位置
/// @param fromPath 从哪个路径
/// @param toPath 到哪个路径
+ (BOOL)moveFileWithFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    NSError * error;
    
    BOOL result = [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:&error];
    
    if ( error )
    {
        NSLog(@"移动文件失败：%@, error = %@", fromPath, error);
    }
    
    return result;
}


/*
 
 获取文件夹 -> 遍历文件夹所有文件 -> 把文件尺寸累加
 
 1.创建文件管理者
 2.获取文件夹路径
 3.获取文件夹所有子路径
 4.遍历所有子路径
 5.拼接完整文件路径
 6.attributesOfItemAtPath: 指定文件全路径，就能获取文件属性
 7.获取文件大小
 8.累加
 */
/// 指定一个文件或文件夹路径，获取当前文件或文件夹的大小
/// @param filePath 路径
/// @param completion 大小
+ (void)fileSizeWithPath:(NSString *)filePath completion:(void(^)(long long size))completion
{
    //计算文件夹的大小是个耗时操作，需要开启子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        
        //创建文件管理者
        NSFileManager * fileManager = [NSFileManager defaultManager];
        
        
        //判断是否是文件夹 (后面的方法只能计算文件夹的大小，如果是文件，在执行获取文件夹所有子路径数组时，获取的数组没值，也就算不出来)
        BOOL isDirectory = NO;
        //返回文件是否存在和是否是文件夹
        BOOL isExists = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        //路径不存在
        if( !isExists )
        {
            //报错：抛异常
            NSException * excp = [NSException exceptionWithName:@"文件错误" reason:@"获取文件大小失败，传入的路径不存在" userInfo:nil];
            [excp raise];
        }
        
        //不是文件夹，是文件，不用遍历累加每个文件大小，直接获取返回即可
        if( !isDirectory )
        {
            //获取文件属性
            NSDictionary *attr = [fileManager attributesOfItemAtPath:filePath error:nil];
            //回到主线程去执行代码块
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if ( completion )
                {
                    completion([attr fileSize]);
                }
            });
            
            return;
        }
        
        
        
        
        //获取文件夹所有子路径数组 (获取多级目录下文件路径)
        NSArray * subpaths = [fileManager subpathsAtPath:filePath];
        
        //遍历
        int totalSize = 0;
        for (NSString * subpath in subpaths)
        {
            NSString * subFilePath = [filePath stringByAppendingPathComponent:subpath];
            
            //判断是否是隐藏文件 (隐藏文件是.DS开头的，我们判断是否路径里是否包含它)
            if ( [subFilePath containsString:@".DS"] )
            {
                continue;
            }
            
            //判断是否是文件夹 (文件夹也有大小，但不包括它里面文件的大小，仅仅是文件夹的大小)
            BOOL isDirectory = NO;
            //返回文件是否存在和是否是文件夹 (是否是文件夹传进去的是地址，会直接给它赋值)
            BOOL isExists = [fileManager fileExistsAtPath:subFilePath isDirectory:&isDirectory];
            //文件不存在或者是文件夹（这里不计算文件夹的大小，如果需要计算，可以去掉 “|| isDirectory”）
            if ( !isExists || isDirectory )
            {
                continue;
            }
            
            
            //获取文件属性
            NSDictionary *attr = [fileManager attributesOfItemAtPath:subFilePath error:nil];
            totalSize += [attr fileSize];
        }
        
        
        //回到主线程去执行代码块
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if ( completion )
            {
                completion(totalSize);
            }
        });
    });
}


/// 指定一个文件或文件夹路径，获取当前文件或文件夹的大小
/// @param filePath 路径
/// @param completion 大小
+ (void)fileSizeStringWithPath:(NSString *)filePath completion:(void(^)(NSString * sizeString))completion
{
    
    //获取Cache文件夹的大小
    [self fileSizeWithPath:filePath completion:^(long long totalSize){
        
        NSInteger size = totalSize;
        
        NSString * str = @"";
        
        //电脑是1024，手机是1000
        //MB
        if ( size > 1000 * 1000 )
        {
            CGFloat sizeF = size / 1000.0 / 1000.0;
            str = [NSString stringWithFormat:@"%.1fMB", sizeF];
        }
        //KB
        else if ( size > 1000 )
        {
            CGFloat sizeF = size / 1000.0;
            str = [NSString stringWithFormat:@"%.1fKB", sizeF];
        }
        //B
        else if ( size >= 0 )
        {
            str = [NSString stringWithFormat:@"%ldB", size];
        }
        
        //如果小数是0，直接去掉小数位
        str = [str stringByReplacingOccurrencesOfString:@".0" withString:@""];
        
        if ( completion )
        {
            completion(str);
        }
        
    }];
}


@end
