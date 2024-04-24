//
//  FLYLoginViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYLoginViewController.h"
#import "UIBarButtonItem+FLYExtension.h"
#import "FLYLeftTextField.h"
#import "FLYCountdownButton.h"
#import "FLYUserModel.h"
#import "FLYUserAction.h"
#import "FLYTabBarController.h"
#import "JPUSHService.h"

@interface FLYLoginViewController () < UITextFieldDelegate >

@property (nonatomic, strong) UIImageView * logoView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) FLYLeftTextField * phoneNumTF;
@property (nonatomic, strong) FLYLeftTextField * codeTF;
@property (nonatomic, strong) UIButton * loginBtn;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) FLYCountdownButton * codeBtn;

@end

@implementation FLYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(100);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.equalTo(self.view);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).with.offset(13);
        make.centerX.equalTo(self.view);
    }];
    
    [self.phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).with.offset(88);
        make.left.equalTo(self.view).with.offset(30);
        make.right.equalTo(self.view).with.offset(-30);
        make.height.mas_equalTo(48);
    }];
    
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumTF.mas_bottom).with.offset(16);
        make.left.equalTo(self.view).with.offset(30);
        make.right.equalTo(self.view).with.offset(-30);
        make.height.mas_equalTo(48);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeTF);
        make.right.equalTo(self.codeTF).with.offset(-91);
        make.size.mas_equalTo(CGSizeMake(1, 28));
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTF).with.offset(0);
        make.left.equalTo(self.lineView.mas_right).with.offset(0);
        make.bottom.equalTo(self.codeTF).with.offset(0);
        make.right.equalTo(self.codeTF).with.offset(0);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTF.mas_bottom).with.offset(80);
        make.left.equalTo(self.view).with.offset(30);
        make.right.equalTo(self.view).with.offset(-30);
        make.height.mas_equalTo(48);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    //蔡13402040153 峰13917028054 康18221699062 徐江18896917159
    //self.phoneNumTF.text = @"18221699062";
}



#pragma makr - NETWORK

- (void)getCodeNetwork
{
    NSDictionary * params = @{ @"type" : @"3", @"phone" : self.phoneNumTF.text };
    
    [FLYNetworkTool postRawWithPath:API_GETVITIFICATION params:params success:^(id json) {
        
        [self.codeBtn startCountdown:60];
        
        self.codeTF.text = json[@"content"];

    } failure:^(id obj) {

        NSLog(@"失败：%@", obj);
    }];
   
}

- (void)loginNetwork
{
    [SVProgressHUD showWithStatus:@"登录中"];
    NSDictionary * params = @{ @"loginType" : @"3", @"username" : self.phoneNumTF.text, @"captcha" : self.codeTF.text, @"registrationId" : [JPUSHService registrationID] == nil ? @"" : [JPUSHService registrationID] };
    
    [FLYNetworkTool postRawWithPath:API_LOGIN params:params success:^(id json) {
        
        [SVProgressHUD dismiss];
        
        FLYUserModel * model = [FLYUserModel mj_objectWithKeyValues:json[SERVER_DATA]];
        
        [FLYUserAction loginAction:model];
        
        FLYTabBarController * tabVC = [[FLYTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
        
    } failure:^(id obj) {

        NSLog(@"失败：%@", obj);
    }];
}



#pragma mark - UI

- (void)initUI
{
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneNumTF];
    [self.view addSubview:self.codeTF];
    [self.codeTF addSubview:self.lineView];
    [self.codeTF addSubview:self.codeBtn];
    [self.view addSubview:self.loginBtn];
}



#pragma mark - event handler

- (void)loginClick:(UIButton *)button
{
    if ( self.phoneNumTF.text.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
        return;
    }
    
    if ( self.codeTF.text.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入验证码"];
        return;
    }
    
    [self loginNetwork];
}

- (void)codeClick:(UIButton *)button
{
    if ( self.phoneNumTF.text.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
        return;
    }
    
    if ( self.phoneNumTF.text.length != 11 )
    {
        [SVProgressHUD showImage:nil status:@"手机号码格式不正确"];
        return;
    }
    
    [self getCodeNetwork];
}



#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = COLORHEX(@"#2BB9A0").CGColor;
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    return YES;
}



#pragma mark - setters and getters

- (UIImageView *)logoView
{
    if( _logoView == nil )
    {
        _logoView = [[UIImageView alloc] init];
        _logoView.backgroundColor = COLORHEX(@"#2BB9A0");
        _logoView.layer.cornerRadius = 6;
        _logoView.layer.masksToBounds = YES;
        _logoView.image = IMAGENAME(@"logo_80");
    }
    return _logoView;
}

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_M(16);
        _titleLabel.textColor = COLORHEX(@"#2BB9A0");
        _titleLabel.text = @"智爱云看护";
    }
    return _titleLabel;
}

- (FLYLeftTextField *)phoneNumTF
{
    if( _phoneNumTF == nil )
    {
        _phoneNumTF = [[FLYLeftTextField alloc] init];
        _phoneNumTF.leftImgName = @"denglu_shouji";
        _phoneNumTF.delegate = self;
        _phoneNumTF.placeholder = @"请输入手机号";
        _phoneNumTF.textColor = COLORHEX(@"#333333");
        _phoneNumTF.font = FONT_M(15);
        _phoneNumTF.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _phoneNumTF.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
        _phoneNumTF.layer.shadowOffset = CGSizeMake(0,3);
        _phoneNumTF.layer.shadowOpacity = 1;
        _phoneNumTF.layer.shadowRadius = 9;
        _phoneNumTF.layer.cornerRadius = 4;
        _phoneNumTF.layer.borderWidth = 1;
        _phoneNumTF.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _phoneNumTF;
}

- (FLYLeftTextField *)codeTF
{
    if( _codeTF == nil )
    {
        _codeTF = [[FLYLeftTextField alloc] init];
        _codeTF.delegate = self;
        _codeTF.leftImgName = @"denglu_yanzhengma";
        _codeTF.placeholder = @"请输入验证码";
        _codeTF.textColor = COLORHEX(@"#333333");
        _codeTF.font = FONT_M(15);
        _codeTF.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _codeTF.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
        _codeTF.layer.shadowOffset = CGSizeMake(0,3);
        _codeTF.layer.shadowOpacity = 1;
        _codeTF.layer.shadowRadius = 9;
        _codeTF.layer.cornerRadius = 4;
        _codeTF.layer.borderWidth = 1;
        _codeTF.layer.borderColor = [UIColor clearColor].CGColor;
        _codeTF.clearButtonMode = UITextFieldViewModeNever;
    }
    return _codeTF;
}

- (UIButton *)loginBtn
{
    if( _loginBtn == nil )
    {
        _loginBtn = [UIButton buttonWithTitle:@"登录" titleColor:[UIColor whiteColor] font:FONT_M(16)];
        _loginBtn.backgroundColor = [UIColor colorWithRed:43/255.0 green:185/255.0 blue:160/255.0 alpha:1.0];
        _loginBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
        _loginBtn.layer.shadowOffset = CGSizeMake(0,3);
        _loginBtn.layer.shadowOpacity = 1;
        _loginBtn.layer.shadowRadius = 8;
        _loginBtn.layer.cornerRadius = 6;
        [_loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIView *)lineView
{
    if( _lineView == nil )
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORHEX(@"#EEEEEE");
    }
    return _lineView;
}

-(FLYCountdownButton *)codeBtn
{
    if( _codeBtn == nil )
    {
        _codeBtn = [FLYCountdownButton countdownButton];
        [_codeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [_codeBtn setTitleColor:COLORHEX(@"#2BB9A0") forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = FONT_R(12);
        [_codeBtn addTarget:self action:@selector(codeClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _codeBtn;
}



@end
