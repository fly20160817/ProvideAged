//
//  FLYFingerprintNameViewController.m
//  ProvideAged
//
//  Created by fly on 2023/9/12.
//

#import "FLYFingerprintNameViewController.h"
#import "FLYLabel.h"
#import "FLYTextField.h"
#import "FLYFingerprintViewController.h"

@interface FLYFingerprintNameViewController ()

@property (nonatomic, strong) FLYLabel * nameLabel;
@property (nonatomic, strong) FLYTextField * nameTF;
@property (nonatomic, strong) FLYButton * completeBtn;

@end

@implementation FLYFingerprintNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTF.mas_left).offset(15);
        make.centerY.equalTo(self.nameTF.mas_centerY);
    }];
    
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-([FLYTools safeAreaInsets].bottom + 15));
        make.height.mas_equalTo(44);
    }];
}



#pragma mark - NETWORK

// 更新指纹名称
- (void)modifFingerprintNetwork
{
    NSDictionary * params = @{ @"deviceInfoId" : self.lockModel.idField, @"remark" : self.nameTF.text };
    
    [FLYNetworkTool postRawWithPath:API_MODIFYFINGER params:params success:^(id  _Nonnull json) {
        
        NSLog(@"添加成功:%@", json);
        
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        
        for (UIViewController *viewController in self.navigationController.viewControllers)
        {
            if ( [viewController isKindOfClass:[FLYFingerprintViewController class]] )
            {
                [self.navigationController popToViewController:viewController animated:YES];
                break;
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
    }];
    
}


#pragma mark - UI

- (void)initUI
{
    self.title = @"录入指纹名称";
    self.view.backgroundColor = COLORHEX(@"#F9F9F9");
    
    [self.view addSubview:self.nameTF];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.completeBtn];
}



#pragma mark - event handler

- (void)completeClick:(UIButton *)button
{
    if ( self.nameTF.text.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入指纹名称"];
        return;
    }
    
    [self modifFingerprintNetwork];
}



#pragma mark - setters and getters

-(FLYLabel *)nameLabel
{
    if( _nameLabel == nil )
    {
        _nameLabel = [[FLYLabel alloc] init];
        _nameLabel.textColor = COLORHEX(@"#999999");
        _nameLabel.font = FONT_M(14);
        _nameLabel.text = @"指纹名称";
    }
    return _nameLabel;
}

-(FLYTextField *)nameTF
{
    if ( _nameTF == nil )
    {
        _nameTF = [[FLYTextField alloc] init];
        _nameTF.textLeftMargin = 100;
        _nameTF.font = FONT_M(14);
        _nameTF.placeholder = @"请输入指纹名称";
        _nameTF.backgroundColor = COLORHEX(@"#FFFFFF");
    }
    return _nameTF;
}

-(FLYButton *)completeBtn
{
    if ( _completeBtn == nil )
    {
        _completeBtn = [FLYButton buttonWithTitle:@"完成添加" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        _completeBtn.backgroundColor = [UIColor colorWithRed:43/255.0 green:185/255.0 blue:160/255.0 alpha:1.0];
        _completeBtn.layer.cornerRadius = 4;
        [_completeBtn addTarget:self action:@selector(completeClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _completeBtn;
}


@end
