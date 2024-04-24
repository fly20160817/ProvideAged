//
//  FLYFingerprintViewController.m
//  ProvideAged
//
//  Created by fly on 2023/9/9.
//

#import "FLYFingerprintViewController.h"
#import "FLYZiGuangManager.h"
#import "FLYLabel.h"
#import "FLYFingerprintModel.h"
#import "FLYFingerprintTipsViewController.h"

@interface FLYFingerprintViewController ()

@property (nonatomic, strong) FLYButton * noDataView;
@property (nonatomic, strong) FLYLabel * fingerprintLabel;
@property (nonatomic, strong) FLYButton * addBtn;
@property (nonatomic, strong) FLYButton * deleteBtn;

@property (nonatomic, strong) FLYFingerprintModel * fingerprintModel;

@end

@implementation FLYFingerprintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self initUI];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [self getFingerprintNetwork];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.fingerprintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(13);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
        make.size.mas_equalTo(CGSizeMake(105, 125));
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-([FLYTools safeAreaInsets].bottom + 15));
        make.height.mas_equalTo(44);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-([FLYTools safeAreaInsets].bottom + 15));
        make.height.mas_equalTo(44);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    
}



#pragma mark - NETWORK

//查询
- (void)getFingerprintNetwork
{
    NSDictionary * params = @{ @"id" : self.lockModel.idField };
    
    [FLYNetworkTool postRawWithPath:API_GETFINGER params:params success:^(id  _Nonnull json) {
        
        self.fingerprintModel = [FLYFingerprintModel mj_objectWithKeyValues:json[@"content"]];
        
        if ( self.fingerprintModel.batchId != nil )
        {
            self.fingerprintLabel.hidden = NO;
            self.deleteBtn.hidden = NO;
            
            self.noDataView.hidden = YES;
            self.addBtn.hidden = YES;
            
            self.fingerprintLabel.text = [NSString stringWithFormat:@"%@ %@", self.fingerprintModel.createTime, self.fingerprintModel.remark];
        }
        else
        {
            self.fingerprintLabel.hidden = YES;
            self.deleteBtn.hidden = YES;
            
            self.noDataView.hidden = NO;
            self.addBtn.hidden = NO;
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        self.fingerprintLabel.hidden = YES;
        self.deleteBtn.hidden = YES;
        
        self.noDataView.hidden = NO;
        self.addBtn.hidden = NO;
    }];
    
}

//删除
- (void)deleteFingerprintNetwork
{
    NSDictionary * params = @{ @"batchId" : self.fingerprintModel.batchId, @"deviceInfoId" : self.fingerprintModel.deviceInfoId };
    
    [FLYZiGuangManager deleteFingerPrint:self.lockModel.imei userID:self.fingerprintModel.lockUserId fingerprintNo:[self.fingerprintModel.lockPawId integerValue] otherParams:params disconnect:NO success:^(NSString * _Nonnull lockId) {

        self.fingerprintLabel.hidden = YES;
        self.deleteBtn.hidden = YES;
        
        self.noDataView.hidden = NO;
        self.addBtn.hidden = NO;

    } failure:^(NSString * _Nonnull reason) {

        NSLog(@"删除失败：%@", reason);

    }];
}



#pragma mark - UI

- (void)initUI
{
    self.title = @"指纹";
    
    self.view.backgroundColor = COLORHEX(@"#F9F9F9");
    
    [self.view addSubview:self.noDataView];
    [self.view addSubview:self.fingerprintLabel];
    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.deleteBtn];
}



#pragma mark - ebent handler

- (void)addClick:(UIButton *)button
{
    FLYFingerprintTipsViewController * vc = [[FLYFingerprintTipsViewController alloc] init];
    vc.lockModel = self.lockModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteClick:(UIButton *)button
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"删除指纹" message:@"确定删除吗？删除成功后，该指纹将无法用于开锁！" preferredStyle:(UIAlertControllerStyleAlert) titles:@[@"取消", @"确定"] alertAction:^(NSInteger index) {
        
        if ( index == 1 )
        {
            [self deleteFingerprintNetwork];
        }
        
    }];
    
    [alertController show];
}



#pragma mark - setters and getters

-(FLYButton *)noDataView
{
    if ( _noDataView == nil )
    {
        _noDataView = [FLYButton buttonWithImage:IMAGENAME(@"wuzhiwen") title:@"暂无指纹数据" titleColor:COLORHEX(@"#B0BBB8") font:FONT_R(13)];
        [_noDataView setImagePosition:(FLYImagePositionTop) spacing:22];
        _noDataView.hidden = YES;
    }
    return _noDataView;
}

-(FLYLabel *)fingerprintLabel
{
    if ( _fingerprintLabel == nil )
    {
        _fingerprintLabel = [[FLYLabel alloc] init];
        _fingerprintLabel.backgroundColor = COLORHEX(@"#FFFFFF");
        _fingerprintLabel.textColor = COLORHEX(@"#333333");
        _fingerprintLabel.font = FONT_M(14);
        _fingerprintLabel.textEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _fingerprintLabel.hidden = YES;
    }
    return _fingerprintLabel;
}

-(FLYButton *)addBtn
{
    if ( _addBtn == nil )
    {
        _addBtn = [FLYButton buttonWithTitle:@"录入指纹" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        _addBtn.backgroundColor = [UIColor colorWithRed:43/255.0 green:185/255.0 blue:160/255.0 alpha:1.0];
        _addBtn.layer.cornerRadius = 4;
        _addBtn.hidden = YES;
        [_addBtn addTarget:self action:@selector(addClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addBtn;
}

-(FLYButton *)deleteBtn
{
    if ( _deleteBtn == nil )
    {
        _deleteBtn = [FLYButton buttonWithTitle:@"删除指纹" titleColor:COLORHEX(@"#2BB9A0") font:FONT_M(16)];
        _deleteBtn.backgroundColor = COLORHEX(@"#F9F9F9");
        _deleteBtn.layer.cornerRadius = 4;
        _deleteBtn.layer.borderWidth = 1;
        _deleteBtn.layer.borderColor = COLORHEX(@"#2BB9A0").CGColor;
        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _deleteBtn;
}

@end
