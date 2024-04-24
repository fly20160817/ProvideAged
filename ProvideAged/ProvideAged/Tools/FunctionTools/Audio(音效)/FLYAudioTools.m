//
//  FLYAudioTools.m
//  02-音效封装工具类
//
//  Created by fly on 2019/4/29.
//  Copyright © 2019 fly. All rights reserved.
//

#import "FLYAudioTools.h"
#import <AVFoundation/AVFoundation.h>

//缓存字典 (soundID重复创建，soundID每次创建，就会有对应的URL地址产生。可以对创建后的 soundID 及 对应的URL 进行缓存处理）
static NSMutableDictionary * _soundIDDict;

@implementation FLYAudioTools

+(void)initialize
{
    _soundIDDict = [NSMutableDictionary new];
}

+ (void)playSystemSoundWithURL:(NSURL *)url
{
    SystemSoundID soundID = [self loadSoundIDWithURL:url];
    
    //播放音效文件 (如果手机被设置为静音，用户什么也听不到)
    AudioServicesPlaySystemSound(soundID);
}


+ (void)playAlertSoundWithURL:(NSURL *)url
{
    SystemSoundID soundID = [self loadSoundIDWithURL:url];
    
    //播放音效文件 (如果手机被设置为静音或震动，将通过震动提醒用户)
    AudioServicesPlayAlertSound(soundID);
}


//创建音效文件的公用方法
+ (SystemSoundID)loadSoundIDWithURL:(NSURL *)url
{
    //1.获取URL的字符串
    NSString * urlString = url.absoluteString;
    
    //2.从缓存字典中根据URL来取soundID系统音效文件
    SystemSoundID soundID = [_soundIDDict[urlString] intValue];
    
    //3.判断soundID是否为0，如果为0说明没有找到，需要创建
    if ( soundID == 0 )
    {
        //3.1 创建音效文件 (把url的内存地址赋值给soundID)
        AudioServicesCreateSystemSoundID(CFBridgingRetain(url), &soundID);
        //3.2 添加到缓存字典中
        _soundIDDict[url.absoluteString] = @(soundID);
    }
    
    return soundID;
}


+ (void)clearMemory
{
    //1.遍历缓存字典
    [_soundIDDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        //2.释放声音对象 (如果不需要播放了，需要释放音效所占用的内存)
        SystemSoundID soundID = [obj intValue];
        AudioServicesDisposeSystemSoundID(soundID);
    }];
}

@end


