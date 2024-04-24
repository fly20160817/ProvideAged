//
//  FLYPhotoManager.m
//  BuDeJie
//
//  Created by fly on 2019/2/27.
//  Copyright © 2019年 fly. All rights reserved.
//

#import "FLYPhotoManager.h"
#import <Photos/Photos.h>

/*
 <Photos/Photos.h>里的常用类
 
 PHPhotoLibrary: 相簿 (所有相册的集合)
 PHAssetCollection: 相册 (所有图片的集合)
 PHAsset: 图片
 
 PHAssetCollectionChangeRequest: 创建、修改、删除相册
 PHAssetChangeRequest: 创建、修改、删除图片
 */

/*
 如何学习新的框架
 
 1.了解这个框架有哪些常用类
 2.查看苹果官方文档 (1看框架有哪些类，2看框架怎么用)
 
 想了解一个类怎么样，可以使用option键
 */

@implementation FLYPhotoManager

//保存图片到自己自定义的相册
+ (void)savePhoto:(UIImage *)image albumTitle:(NSString *)albumTitle completionHandler:(void (^)(BOOL, NSError * error))completionHandler
{
    //这个方法是异步的，还有一个和它很像的方法，那个方法是同步的
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //1.判断之前有没有相册，有则直接获取之前创建的相册
        PHAssetCollection * assetCollection = [self fetchAssetColletion:albumTitle];
        
        //相册操作类
        PHAssetCollectionChangeRequest * assetCollectionChangeRequest;
        
        //相册已经存在
        if ( assetCollection )
        {
            //2.获取已存在的相册后给相册操作类
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        }
        else
        {
            //2.创建自定义相册后给相册操作类
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumTitle];
        }
        
        //3.添加图片到系统相册
        PHAssetChangeRequest * assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        //4.拷贝系统相册图片到自定义相册 (不是真的拷贝，是把内存地址给它，让它有权限访问)
        PHObjectPlaceholder *placeholder =  [assetChangeRequest placeholderForCreatedAsset];
        [assetCollectionChangeRequest addAssets:@[placeholder]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if ( completionHandler )
        {
            completionHandler(success, error);
        }
    }];
}

//获取之前创建的相册
+ (PHAssetCollection *)fetchAssetColletion:(NSString *)albumTitle
{
    //获取之前的相册 (result里面放的是所有的自定义相册)
    PHFetchResult * result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    //遍历所有相册，找到名字是我们创建的相册
    for (PHAssetCollection * assetCollection in result)
    {
        if ( [assetCollection.localizedTitle isEqualToString:albumTitle] )
        {
            return assetCollection;
        }
    }
    
    return nil;
}

@end
