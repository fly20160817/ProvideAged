//
//  FLYFingerprintTipsViewController.m
//  ProvideAged
//
//  Created by fly on 2023/9/12.
//

#import "FLYFingerprintTipsViewController.h"
#import "FLYLabel.h"
#import "FLYAddFingerprintViewController.h"

@interface FLYFingerprintTipsViewController ()

@property (nonatomic, strong) FLYLabel * tipsLabel;
@property (nonatomic, strong) UIImageView * tipsImageView;
@property (nonatomic, strong) FLYButton * fingerprintBtn;

@end

@implementation FLYFingerprintTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.centerX.equalTo(self);
    }];
    
    
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(83);
        make.centerX.equalTo(self);
    }];
    
    [self.fingerprintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-([FLYTools safeAreaInsets].bottom + 15));
        make.height.mas_equalTo(44);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.title = @"录入指纹";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.tipsImageView];
    [self.view addSubview:self.fingerprintBtn];
}



#pragma mark - event handler

- (void)startClick:(UIButton *)button
{
    FLYAddFingerprintViewController * vc = [[FLYAddFingerprintViewController alloc] init];
    vc.lockModel = self.lockModel;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - setters and getters

-(FLYLabel *)tipsLabel
{
    if( _tipsLabel == nil )
    {
        _tipsLabel = [[FLYLabel alloc] init];
        _tipsLabel.textColor = COLORHEX(@"#666666");
        _tipsLabel.font = FONT_M(18);
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.text = @"请采用日常握住门把手的姿\n势和开门时的手指按压力度";
    }
    return _tipsLabel;
}

-(UIImageView *)tipsImageView
{
    if( _tipsImageView == nil )
    {
        _tipsImageView = [[UIImageView alloc] init];
        _tipsImageView.image = IMAGENAME(@"zhiwentips");
    }
    return _tipsImageView;
}

-(FLYButton *)fingerprintBtn
{
    if ( _fingerprintBtn == nil )
    {
        _fingerprintBtn = [FLYButton buttonWithTitle:@"开始录入" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        _fingerprintBtn.backgroundColor = [UIColor colorWithRed:43/255.0 green:185/255.0 blue:160/255.0 alpha:1.0];
        _fingerprintBtn.layer.cornerRadius = 4;
        [_fingerprintBtn addTarget:self action:@selector(startClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _fingerprintBtn;
}


@end
