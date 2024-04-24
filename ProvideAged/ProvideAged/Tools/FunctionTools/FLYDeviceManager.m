//
//  FLYDeviceManager.m
//  FLYKit
//
//  Created by fly on 2021/9/6.
//

#import "FLYDeviceManager.h"
#import "FLYTools.h"

@interface FLYDeviceManager () < MFMessageComposeViewControllerDelegate >

//短信发送结果block
@property (nonatomic, assign) void(^resultBlock)(MessageComposeResult result);

@end

@implementation FLYDeviceManager


#pragma mark - 单利 （保证无论通过怎样的方式创建出来，都只有一个实例）

static FLYDeviceManager * _shareInstance;

+ (instancetype)shareInstance
{
    if ( _shareInstance == nil )
    {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

//分配内存地址的时候调用 (当执行alloc的时候，系统会自动调用分配内存地址的方法)
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if ( !_shareInstance )
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}


//保证copy这个对象的时候，返回的还是这个单利，不会生成新的 (这个方法需要在头部声明代理)
-(id)copyWithZone:(NSZone *)zone
{
    return _shareInstance;
}

//保证copy这个对象的时候，返回的还是这个单利，不会生成新的 (这个方法需要在头部声明代理)
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _shareInstance;
}





/// 打电话
/// @param phoneNumber 手机号
+ (void)callPhone:(NSString *)phoneNumber
{
    phoneNumber = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber] options:@{} completionHandler:^(BOOL success) {
        
        NSLog(@"打电话回调： %d", success);
    }];
}


/// 发短信 (跳转到信息app)
/// @param phoneNumber 手机号
+ (void)sendMessage:(NSString *)phoneNumber
{
    
    phoneNumber = [NSString stringWithFormat:@"sms:%@", phoneNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber] options:@{} completionHandler:^(BOOL success) {
        
        NSLog(@"发短信回调： %d", success);
    }];

}


/// 发短信 (app内部发送)
/// @param phoneNumbers 手机号数组（可以群发）
/// @param content 短信内容
/// @param resultBlock 发送完成的回调
- (void)sendMessage:(NSArray *)phoneNumbers content:(NSString *)content didFinishWithResult:(nullable void(^)(MessageComposeResult result))resultBlock
{
    self.resultBlock = resultBlock;

    MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
    controller.recipients = phoneNumbers;
    controller.body = content;
    controller.messageComposeDelegate = self;
    [[FLYTools currentViewController] presentViewController:controller animated:YES completion:nil];
}



#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(nonnull MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [[FLYTools currentViewController] dismissViewControllerAnimated:YES completion:nil];
    
    !self.resultBlock ?:self.resultBlock(result);
    
    switch (result)
    {
        case MessageComposeResultSent:
            
            NSLog(@"短信发送成功");
            
            break;
            
        case MessageComposeResultFailed:
            
            NSLog(@"短信发送失败");
            
            break;
            
        case MessageComposeResultCancelled:
            
            NSLog(@"用户取消发送");
            
            break;
            
        default:
            
            break;
    }
}

@end
