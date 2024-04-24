//
//  FLYForgetLockPasswordViewController.m
//  ProvideAged
//
//  Created by fly on 2021/12/28.
//

#import "FLYForgetLockPasswordViewController.h"
#import "FLYLabel.h"
#import "FLYTextField.h"

@interface FLYForgetLockPasswordViewController ()

@property (nonatomic, strong) FLYLabel * titleLabel;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) FLYTextField * nameTF;
@property (nonatomic, strong) UILabel * phoneLabel;
@property (nonatomic, strong) FLYTextField * phoneTF;
@property (nonatomic, strong) FLYButton * sendBtn;

@end

@implementation FLYForgetLockPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.nameTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTF.mas_left);
        make.centerY.equalTo(self.nameTF.mas_centerY);
    }];
    
    [self.phoneTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTF.mas_bottom).with.offset(0);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF.mas_left);
        make.centerY.equalTo(self.phoneTF.mas_centerY);
    }];
    
    [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTF.mas_bottom).with.offset(32);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(44);
    }];
}



#pragma mark - NETWORK

- (void)sendPasswordNetwork
{
    NSDictionary * params = @{ @"id" : self.deviceInfoId };
    
    [FLYNetworkTool postRawWithPath:API_FORGOTPASSWORD params:params success:^(id  _Nonnull json) {
        
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"忘记密码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.nameTF];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.phoneTF];
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.sendBtn];
}



#pragma mark - event handler

- (void)sendClick:(UIButton *)button
{
    if ( self.nameTF.text.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入授权人"];
        return;
    }
    
    if ( self.phoneTF.text.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
        return;
    }
    
    if ( self.phoneTF.text.length != 11 )
    {
        [SVProgressHUD showImage:nil status:@"手机号不合法"];
        return;
    }
    
    
    [self sendPasswordNetwork];
}



#pragma mark - setters and getters

-(FLYLabel *)titleLabel
{
    if ( _titleLabel == nil )
    {
        _titleLabel = [[FLYLabel alloc] init];
        _titleLabel.backgroundColor = COLORHEX(@"#F9F9F9");
        _titleLabel.font = FONT_R(13);
        _titleLabel.textColor = COLORHEX(@"#333333");
        _titleLabel.textEdgeInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _titleLabel.text = @"密码将通过短信发送到您的手机号，从前的密码作废";
    }
    return _titleLabel;
}

-(UILabel *)nameLabel
{
    if ( _nameLabel == nil )
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT_R(13);
        _nameLabel.textColor = COLORHEX(@"#333333");
        _nameLabel.text = @"授权人";
    }
    return _nameLabel;
}

-(FLYTextField *)nameTF
{
    if ( _nameTF == nil )
    {
        _nameTF = [[FLYTextField alloc] init];
        _nameTF.font = FONT_R(13);
        _nameTF.textColor = COLORHEX(@"#333333");
        _nameTF.placeholder = @"请输入";
        _nameTF.showLine = YES;
        _nameTF.lineHeight = 1;
        _nameTF.lineColor = COLORHEX(@"#F1F1F1");
        _nameTF.textLeftMargin = 112;
        
        _nameTF.text = [FLYUser sharedUser].userName;
        _nameTF.enabled = NO;
    }
    return _nameTF;
}

-(UILabel *)phoneLabel
{
    if ( _phoneLabel == nil )
    {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = FONT_R(13);
        _phoneLabel.textColor = COLORHEX(@"#333333");
        _phoneLabel.text = @"手机号";
    }
    return _phoneLabel;
}

-(FLYTextField *)phoneTF
{
    if ( _phoneTF == nil )
    {
        _phoneTF = [[FLYTextField alloc] init];
        _phoneTF.font = FONT_R(13);
        _phoneTF.textColor = COLORHEX(@"#333333");
        _phoneTF.placeholder = @"请输入";
        _phoneTF.showLine = YES;
        _phoneTF.lineHeight = 1;
        _phoneTF.lineColor = COLORHEX(@"#F1F1F1");
        _phoneTF.textLeftMargin = 112;
        
        _phoneTF.text = [FLYUser sharedUser].phone;
        _phoneTF.enabled = NO;
    }
    return _phoneTF;
}

-(FLYButton *)sendBtn
{
    if ( _sendBtn == nil )
    {
        _sendBtn = [FLYButton buttonWithTitle:@"发送密码" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        _sendBtn.backgroundColor = [UIColor colorWithRed:43/255.0 green:185/255.0 blue:160/255.0 alpha:1.0];
        _sendBtn.layer.cornerRadius = 4;
        [_sendBtn addTarget:self action:@selector(sendClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sendBtn;
}

@end
