//
//  FLYInputFaceViewController.m
//  ProvideAged
//
//  Created by fly on 2023/8/21.
//

#import "FLYInputFaceViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FLYInputFaceViewController () < AVCapturePhotoCaptureDelegate >

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;
 
//输入设备
@property (nonatomic, strong) AVCaptureDeviceInput * input;
 
//输出设备 （输出图片）
@property (nonatomic ,strong) AVCapturePhotoOutput * photoOutput;

//会话session  由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;
 
//图像预览层，实时显示捕获的图像 （特殊的layer）
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;


@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UILabel * tipsLabel;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) FLYButton * photographBtn;

@end

@implementation FLYInputFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initUI];
    
    [self cameraDistrict];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(67);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(405);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).with.offset(25);
        make.centerX.equalTo(self.bgView.mas_centerX);
    }];
    
    [self.photographBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView).with.offset(-25);
        make.left.equalTo(self.bgView).with.offset(15);
        make.right.equalTo(self.bgView).with.offset(-15);
        make.height.mas_equalTo(49);
    }];
}



#pragma mark - NETWORK

// 上传图片，返回图片的base64
- (void)uploadImage:(UIImage *)image
{
    [FLYNetworkTool uploadImageWithPath:@"sys/layerFile/singleUpload" params:nil thumbName:@"file" images:@[image] success:^(id  _Nonnull json) {
        
        //NSLog(@"成功：%@", json);
        [self addFaceAuthNetwork:json[@"content"][@"baseImage"]];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
    } progress:^(double progress) {
        
    }];
}

// 人脸授权
- (void)addFaceAuthNetwork:(NSString *)base64String
{
    NSDictionary * params = @{ @"deviceInfoId" : self.deviceInfoId, @"openTypeList" : @[@(5)], @"purpose" : @"家属授权", @"name" : [FLYUser sharedUser].userName, @"phone" : [FLYUser sharedUser].phone, @"startTime" : @"1970-01-01 00:00:00", @"endTime" : @"2099-01-01 00:00:00", @"faceRaw" : base64String };
    
    [FLYNetworkTool postRawWithPath:API_ADDTEMPAUTH params:params success:^(id  _Nonnull json) {
        
        [SVProgressHUD showSuccessWithStatus:@"脸授权成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
        
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"人脸录入";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.tipsLabel];
    [self.bgView addSubview:self.photographBtn];
}



- (void)cameraDistrict
{
    
    //1.输入设备 (用来获取外界信息) 摄像头、麦克风、键盘等
    
    // 创建一个用于查找设备的会话
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];

    // 获取找到的所有前置摄像头设备
    NSArray *frontCameraDevices = discoverySession.devices;

    // 选取第一个前置摄像头设备（你可以根据需要进行更多筛选）
    self.device = frontCameraDevices.firstObject;

    // 创建 AVCaptureDeviceInput 并将前置摄像头设备设置为输入
    NSError *inputError = nil;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&inputError];

    
    //1.输入设备 (用来获取外界信息) 摄像头、麦克风、键盘等
//    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
 
    
    // 2.输出设备 (将收集到的信息做解析，来获取收到的内容)
    self.photoOutput = [[AVCapturePhotoOutput alloc] init];
 
    
    // 3.会话session (用来连接输入和输出设备)
    self.session = [[AVCaptureSession alloc] init];
    //     拿到的图像的大小可以自行设定
    //    AVCaptureSessionPreset320x240
    //    AVCaptureSessionPreset352x288
    //    AVCaptureSessionPreset640x480
    //    AVCaptureSessionPreset960x540
    //    AVCaptureSessionPreset1280x720
    //    AVCaptureSessionPreset1920x1080
    //    AVCaptureSessionPreset3840x2160
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    //会话跟输入和输出设备关联
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.photoOutput])
    {
        [self.session addOutput:self.photoOutput];
    }
    
    
    
    // 4.特殊的layer (展示输入设备所采集的信息)
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(70, 130, [[UIScreen mainScreen] bounds].size.width - (70*2), [[UIScreen mainScreen] bounds].size.width - (70*2));
    self.previewLayer.cornerRadius = self.previewLayer.frame.size.width / 2.0;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 5.启动会话
        [self.session startRunning];
    });

  
}




#pragma mark AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    
    if (error)
    {
        NSLog(@"获取图片错误 --- %@",error.localizedDescription);
        return;
    }
    
    if (photo)
    {
        CGImageRef cgImage = [photo CGImageRepresentation];
        UIImage * image = [UIImage imageWithCGImage:cgImage];
        NSLog(@"获取图片成功 --- %@",image);
        
        
        // 调整图片方向 (默认会旋转90度)
        image = [self rotateImage:image degrees:90];
        
        // 翻转图片（前置摄像头拍出来是镜像的）
        image = [self flipImageHorizontally:image];
       
        self.imageView.image = image;
        [self.view addSubview:self.imageView];
        
        
        
        [self uploadImage:image];
    }
}




#pragma mark - event handler

//拍照
- (void)photoClick:(UIButton *)sender
{
    //settings不能重复使用，每次拍照都新建一个
    AVCapturePhotoSettings * settings = [AVCapturePhotoSettings photoSettings];
    
    [self.photoOutput capturePhotoWithSettings:settings delegate:self];
}



#pragma mark - private methods

// 翻转照片 (前置摄像头捕捉到的图像是镜像的)
- (UIImage *)flipImageHorizontally:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, image.size.width, 0);
    CGContextScaleCTM(context, -1.0, 1.0);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *flippedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return flippedImage;
}


// 调整图片方向的方法
- (UIImage *)rotateImage:(UIImage *)image degrees:(CGFloat)degrees {
    // Convert degrees to radians
    CGFloat radians = degrees * M_PI / 180;
    
    // Calculate the size of the rotated image's bounding box
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Move the origin to the center of the image so it will rotate around the center
    CGContextTranslateCTM(context, rotatedSize.width / 2, rotatedSize.height / 2);
    CGContextRotateCTM(context, radians);
    
    // Draw the rotated image into the context
    CGContextScaleCTM(context, 1.0, -1.0); // Flips the image right side up
    CGContextDrawImage(context, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    // Get the rotated image from the context and end the context
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rotatedImage;
}



#pragma setters and getters

- (UIView *)bgView
{
    if ( _bgView == nil )
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _bgView.layer.shadowColor = [UIColor colorWithRed:169/255.0 green:188/255.0 blue:216/255.0 alpha:0.3].CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0,0);
        _bgView.layer.shadowOpacity = 1;
        _bgView.layer.shadowRadius = 20;
        _bgView.layer.cornerRadius = 8;
    }
    return _bgView;
}

-(UILabel *)tipsLabel
{
    if ( _tipsLabel == nil )
    {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = FONT_M(14);
        _tipsLabel.textColor = COLORHEX(@"#333333");
        _tipsLabel.text = @"拍摄您本人人脸，请保证正对手机、光线充足";
    }
    return _tipsLabel;
}

-(UIImageView *)imageView
{
    if ( _imageView == nil )
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.previewLayer.frame;
        _imageView.layer.cornerRadius = self.previewLayer.cornerRadius;
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

-(FLYButton *)photographBtn
{
    if ( _photographBtn == nil )
    {
        _photographBtn = [FLYButton buttonWithTitle:@"采集本人人脸" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        _photographBtn.backgroundColor = [UIColor colorWithRed:81/255.0 green:136/255.0 blue:250/255.0 alpha:1.0];
        _photographBtn.layer.cornerRadius = 6;
        [_photographBtn addTarget:self action:@selector(photoClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _photographBtn;
}



@end
