//
//  FLYAddFingerprintViewController.m
//  ProvideAged
//
//  Created by fly on 2023/9/12.
//

#import "FLYAddFingerprintViewController.h"
#import "FLYLabel.h"
#import "FLYZiGuangManager.h"
#import "FLYFingerprintNameViewController.h"

@interface FLYAddFingerprintViewController ()

@property (nonatomic, strong) FLYLabel * tipsLabel;
@property (nonatomic, strong) UIImageView * fingerprintView;
@property (nonatomic, strong) FLYLabel * finishLabel;
@property (nonatomic, strong) FLYButton * nextBtn;

@end

@implementation FLYAddFingerprintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initUI];
    
    [self addFingerPrint];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(33);
        make.centerX.equalTo(self);
    }];
    
    
    [self.fingerprintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(82);
        make.centerX.equalTo(self);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-([FLYTools safeAreaInsets].bottom + 15));
        make.height.mas_equalTo(44);
    }];
    
    [self.finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nextBtn.mas_top).offset(-28);
        make.centerX.equalTo(self);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.title = @"录入指纹";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.fingerprintView];
    [self.view addSubview:self.finishLabel];
    [self.view addSubview:self.nextBtn];
}



#pragma mark - event handler

//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    static int i = 1;
//
//    NSLog(@"i = %d", i);
//    NSString * imageName = [NSString stringWithFormat:@"zhiwen%ld", (long)i];
//    self.fingerprintView.image = IMAGENAME(imageName);
//
//    if ( i == 4 )
//    {
//        self.finishLabel.hidden = NO;
//        self.nextBtn.enabled = YES;
//    }
//    i++;
//}

- (void)nextClick:(UIButton *)button
{
    FLYFingerprintNameViewController * vc = [[FLYFingerprintNameViewController alloc] init];
    vc.lockModel = self.lockModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addFingerPrint
{
    // 录入
    NSDictionary * params = @{ @"deviceInfoId" : self.lockModel.idField, @"remark" : @"我的大拇指" };

    [FLYZiGuangManager addFingerPrint:self.lockModel.imei otherParams:params disconnect:NO progress:^(NSInteger progress) {

        NSLog(@"progress = %ld",(long)progress );
        
        NSString * imageName = [NSString stringWithFormat:@"zhiwen%ld", (long)progress];
        self.fingerprintView.image = IMAGENAME(imageName);

    } success:^(NSString * _Nonnull lockId) {

        NSLog(@"录入成功");
        self.finishLabel.hidden = NO;
        self.nextBtn.enabled = YES;

    } failure:^(NSString * _Nonnull reason) {

        NSLog(@"录入失败 = %@", reason);
    }];
}



#pragma mark - setters and getters

-(FLYLabel *)tipsLabel
{
    if( _tipsLabel == nil )
    {
        _tipsLabel = [[FLYLabel alloc] init];
        _tipsLabel.textColor = COLORHEX(@"#666666");
        _tipsLabel.font = FONT_M(22);
        _tipsLabel.text = @"请您在7秒内录入指纹";
    }
    return _tipsLabel;
}

-(UIImageView *)fingerprintView
{
    if( _fingerprintView == nil )
    {
        _fingerprintView = [[UIImageView alloc] init];
        _fingerprintView.image = IMAGENAME(@"zhiwen0");
    }
    return _fingerprintView;
}

-(FLYLabel *)finishLabel
{
    if ( _finishLabel == nil )
    {
        _finishLabel = [[FLYLabel alloc] init];
        _finishLabel.textColor = COLORHEX(@"#2BB9A0");
        _finishLabel.font = FONT_S(14);
        _finishLabel.text = @"录入成功，请点击下一步";
        _finishLabel.hidden = YES;
    }
    return _finishLabel;
}

-(FLYButton *)nextBtn
{
    if ( _nextBtn == nil )
    {
        _nextBtn = [FLYButton buttonWithTitle:@"下一步" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        [_nextBtn setTitleColor:COLORHEX(@"#999999") forState:UIControlStateDisabled];
        [_nextBtn setBackgroundColor:COLORHEX(@"#2BB9A0") forState:(UIControlStateNormal)];
        [_nextBtn setBackgroundColor:COLORHEX(@"#F0F0F0") forState:(UIControlStateDisabled)];
        _nextBtn.layer.cornerRadius = 4;
        [_nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _nextBtn.enabled = NO;
    }
    return _nextBtn;
}


@end
