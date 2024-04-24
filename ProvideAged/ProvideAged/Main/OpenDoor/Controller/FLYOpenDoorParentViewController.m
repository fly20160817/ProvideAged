//
//  FLYOpenDoorParentViewController.m
//  ProvideAged
//
//  Created by fly on 2022/1/4.
//

#import "FLYOpenDoorParentViewController.h"
#import "FLYPageScrollView.h"
#import "FLYDoorLockModel.h"
#import "FLYOpenDoorViewController.h"
#import "UIView+FLYExtension.h"
#import "BRStringPickerView.h"

@interface FLYOpenDoorParentViewController ()
{
    //选中的地址index
    NSInteger _selectAddressIndex;
    
    //保存上一次的数据
    NSDictionary * _json;
}

@property (nonatomic, strong) FLYButton * addressBtn;
@property (nonatomic, strong) FLYButton * addressArrowBtn;
@property (nonatomic, strong) FLYButton * leftBtn;
@property (nonatomic, strong) FLYButton * rightBtn;
@property (nonatomic, strong) FLYPageScrollView * pageScrollView;

@property (nonatomic, strong) NSArray<FLYDoorLockModel *> * dataList;
@property (nonatomic, strong) NSArray<BRResultModel *> * addressList;

@end

@implementation FLYOpenDoorParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self doorLockListNetwork];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    if ( self.dataList.count != 0 )
    {
        [self.addressBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(32);
            make.centerX.equalTo(self);
        }];
        
        [self.addressArrowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.addressBtn.mas_centerY);
            make.left.equalTo(self.addressBtn.mas_right).with.offset(5);
        }];
        
        [self.pageScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view);
        }];
        
        [self.leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(175);
            make.left.equalTo(self.view).with.offset(25);
        }];
        
        [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(175);
            make.right.equalTo(self.view).with.offset(-25);
        }];
    }
}



#pragma mark - DATA

- (void)loadData
{
    
}



#pragma mark - NETWORK

- (void)doorLockListNetwork
{
    WeakSelf
    StrongSelf
    
    [FLYNetworkTool postRawWithPath:API_DOORLOCKLIST params:@{} loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:YES success:^(id  _Nonnull json) {
        
        if ( [strongSelf->_json isEqualToDictionary:json] )
        {
            return;
        }
        
        strongSelf->_json = json;
        
        self.dataList = [FLYDoorLockModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"门锁";
}

- (void)updateUI
{
    [self.view removeAllSubviews];
    self.pageScrollView = nil;
    
    [self.view addSubview:self.pageScrollView];
    [self.view addSubview:self.addressBtn];
    [self.view addSubview:self.addressArrowBtn];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    
    
    FLYDoorLockModel * doorLockModel = self.dataList[_selectAddressIndex];
    
    [self.addressBtn setTitle:doorLockModel.houseName forState:(UIControlStateNormal)];
    
    if ( doorLockModel.houseLockVoList.count <= 1 )
    {
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }
    else
    {
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
    }
}



#pragma mark - event handler

- (void)addressClick:(UIButton *)button
{
    WeakSelf
    StrongSelf
    [BRStringPickerView showPickerWithTitle:@"选择地址" dataSourceArr:self.addressList selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
        
        strongSelf->_selectAddressIndex = resultModel.index;
        [self updateUI];
    }];
}

- (void)leftClick:(UIButton *)button
{
    NSInteger page = self.pageScrollView.currentSelectIndex - 1;
    
    if ( page < 0 )
    {
        return;
    }
    
    [self.pageScrollView selectIndex:page animated:YES];
    
    self.leftBtn.hidden = page == 0 ? YES : NO;
    self.rightBtn.hidden = NO;
}

- (void)rightClick:(UIButton *)button
{
    NSInteger page = self.pageScrollView.currentSelectIndex + 1;
    
    FLYDoorLockModel * doorLockModel = self.dataList[_selectAddressIndex];
    
    if ( page >= doorLockModel.houseLockVoList.count )
    {
        return;
    }
    
    [self.pageScrollView selectIndex:page animated:YES];
    self.leftBtn.hidden = NO;
    self.rightBtn.hidden = page == doorLockModel.houseLockVoList.count - 1 ? YES : NO;
}



#pragma mark - setters and getters

-(void)setDataList:(NSArray<FLYDoorLockModel *> *)dataList
{
    _dataList = dataList;
    
    if ( dataList.count == 0 )
    {
        [self.view removeAllSubviews];
        self.pageScrollView = nil;
        
        UILabel * label = [[UILabel alloc] init];
        label.font = FONT_M(12);
        label.textColor = [UIColor colorWithHexString:@"#A09C9C"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无数据";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
        return;
    }
    
    
    [self updateUI];
    
    NSMutableArray * addressList = [NSMutableArray array];
    for ( int i = 0; i < dataList.count; i++ )
    {
        FLYDoorLockModel * doorLockModel = dataList[i];
        
        BRResultModel * resultModel = [[BRResultModel alloc] init];
        resultModel.index = i;
        resultModel.key = doorLockModel.idField;
        resultModel.value = doorLockModel.houseName;
        [addressList addObject:resultModel];
    }
    self.addressList = addressList.copy;
}

-(FLYPageScrollView *)pageScrollView
{
    if ( _pageScrollView == nil )
    {
        NSMutableArray * vcArray = [NSMutableArray array];
        
        FLYDoorLockModel * doorLockModel = self.dataList[_selectAddressIndex];
        
        for ( int i = 0; i < doorLockModel.houseLockVoList.count; i++ )
        {
            FLYOpenDoorViewController * vc = [[FLYOpenDoorViewController alloc] init];
            vc.lockModel = doorLockModel.houseLockVoList[i];
            [vcArray addObject:vc];
        }
        
        _pageScrollView = [FLYPageScrollView pageScrollViewWithFrame:CGRectZero parentVC:self childVCs:vcArray];
        _pageScrollView.scrollEnabled = NO;
        [_pageScrollView selectIndex:0 animated:YES];
    }
    return _pageScrollView;
}

-(FLYButton *)addressBtn
{
    if ( _addressBtn == nil )
    {
        _addressBtn = [FLYButton buttonWithImage:IMAGENAME(@"daohangdingwei") title:@"地址" titleColor:COLORHEX(@"#333333") font:FONT_R(13)];
        [_addressBtn setImagePosition:(FLYImagePositionLeft) spacing:6];
        [_addressBtn addTarget:self action:@selector(addressClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addressBtn;
}

-(FLYButton *)addressArrowBtn
{
    if ( _addressArrowBtn == nil )
    {
        _addressArrowBtn = [FLYButton buttonWithImage:IMAGENAME(@"dizhi_shangjiantou")];
        [_addressArrowBtn addTarget:self action:@selector(addressClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addressArrowBtn;
}

-(FLYButton *)leftBtn
{
    if ( _leftBtn == nil )
    {
        _leftBtn = [FLYButton buttonWithImage:IMAGENAME(@"zuojiantou")];
        [_leftBtn addTarget:self action:@selector(leftClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftBtn;
}

-(FLYButton *)rightBtn
{
    if ( _rightBtn == nil )
    {
        _rightBtn = [FLYButton buttonWithImage:IMAGENAME(@"youjiantou")];
        [_rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightBtn;
}


@end
