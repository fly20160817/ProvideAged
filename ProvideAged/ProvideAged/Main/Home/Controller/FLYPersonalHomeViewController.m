//
//  FLYPersonalHomeViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYPersonalHomeViewController.h"
#import "FLYElderlyBaseInfoView.h"
#import "FLYElderlyMenuView.h"
#import "FLYDeviceStatusView.h"
#import "FLYHealthRecordViewController.h"
#import "FLYServiceRecordViewController.h"
#import "FLYDeviceManager.h"
#import "FLYMapViewController.h"
#import "FLYElderModel.h"
#import "UIView+FLYLayer.h"
#import "FLYMotionView.h"
#import "MJRefresh.h"
#import "FLYDeviceClassificationViewController.h"
#import "FLYSendMessageViewController.h"
#import "FLYHealthModel.h"
#import "FLYPhysiologicalChartViewController.h"
#import "FLYVideoListViewController.h"
#import "FLYMedicineBoxView.h"
#import "FLYMedicineBoxMenuViewController.h"
#import "FLYBoxInfoModel.h"

@interface FLYPersonalHomeViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) FLYElderlyBaseInfoView * baseInfoView;
@property (nonatomic, strong) FLYElderlyMenuView * menuView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) FLYDeviceStatusView * deviceStatusView;
@property (nonatomic, strong) FLYMotionView * motionView;
@property (nonatomic, strong) FLYMedicineBoxView * medicineBoxView;

@property (nonatomic, strong) FLYElderModel * elderModel;

@end

@implementation FLYPersonalHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view).with.offset(0);
    }];
    
    [self.baseInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).with.offset(44);
        make.left.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(88);
    }];
    
    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseInfoView.mas_bottom).with.offset(38);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(95);
    }];
   
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).with.offset(18);
        make.left.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(500);
    }];
    
    [self.bottomView roundCorner:20 rectCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    [self.deviceStatusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).with.offset(24);
        make.left.equalTo(self.bottomView).with.offset(20);
        make.right.equalTo(self.bottomView).with.offset(-20);
        make.height.mas_equalTo(107);
    }];
    
    [self.motionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceStatusView.mas_bottom).with.offset(14);
        make.left.equalTo(self.bottomView).with.offset(20);
        make.right.equalTo(self.bottomView).with.offset(-20);
        make.height.mas_equalTo(107);
    }];
        
    [self.medicineBoxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.motionView.mas_bottom).with.offset(14);
        make.left.equalTo(self.bottomView).with.offset(20);
        make.right.equalTo(self.bottomView).with.offset(-20);
        make.height.mas_equalTo(112);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-20);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    //获取生理数据
    [self getPhysiologicalInfoNetwork];
    
    [self getElderInfoNetwork];
    
    [self getMedicineBoxInfoNetwork];
}


#pragma mark - NETWORK

//获取生理数据
- (void)getPhysiologicalInfoNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"sort" : @"2" };
    
    [FLYNetworkTool postRawWithPath:API_HEALTH params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:YES success:^(id  _Nonnull json) {
        
        NSArray * array = [FLYHealthModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        self.baseInfoView.healthList = array;
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

- (void)getElderInfoNetwork
{
    NSDictionary * params = @{ @"id" : self.oldManInfoId };
    
    [FLYNetworkTool postRawWithPath:API_ELDERDETAIL params:params success:^(id json) {
        
        self.elderModel = [FLYElderModel mj_objectWithKeyValues:json[SERVER_DATA]];
        
        self.deviceStatusView.total = [@(self.elderModel.deviceCount) stringValue];
        self.deviceStatusView.online = [@(self.elderModel.houseEquipmentCount) stringValue];
        self.deviceStatusView.alarm = [@(self.elderModel.personalEquipmentCount) stringValue];
        self.deviceStatusView.newStatus = (self.elderModel.houseEquipmentAlertCount == 0 && self.elderModel.personalEquipmentAlertCount == 0) ? NO : YES;
        self.motionView.step = [@(self.elderModel.pedometer) stringValue];
        self.motionView.distance = [@(self.elderModel.distance) stringValue];
        
    } failure:^(id obj) {
        
        NSLog(@"obj = %@", obj);
    }];
}

- (void)getMedicineBoxInfoNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.oldManInfoId, @"pageNo" : @"1", @"pageSize" : @"1" };
    
    [FLYNetworkTool postRawWithPath:API_NEWESTREMIND params:params success:^(id  _Nonnull json) {
        
        NSLog(@"成功：%@", json);
        FLYBoxInfoModel * model = [FLYBoxInfoModel mj_objectWithKeyValues:json[@"content"]];
        
        self.medicineBoxView.time = model.medicationDate;
        self.medicineBoxView.eatTime = model.arrangeTime;
        self.medicineBoxView.medicineName = model.drugsName;
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.view.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.baseInfoView];
    [self.scrollView addSubview:self.menuView];
    [self.scrollView addSubview:self.bottomView];
    [self.bottomView addSubview:self.deviceStatusView];
    [self.bottomView addSubview:self.motionView];
    [self.bottomView addSubview:self.medicineBoxView];
}



#pragma mark - event handler

- (void)menuClick:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            FLYHealthRecordViewController * vc = [[FLYHealthRecordViewController alloc] init];
            vc.oldManInfoId = self.oldManInfoId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1:
        {
            FLYVideoListViewController * vc = [[FLYVideoListViewController alloc] init];
            vc.oldManInfoId = self.oldManInfoId;
            vc.houseInfoId = self.elderModel.houseInfoId;
            [self.navigationController pushViewController:vc animated:YES];
            
//            FLYMapViewController * vc = [[FLYMapViewController alloc] init];
//            vc.oldManInfoId = self.oldManInfoId;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:
        {
            FLYServiceRecordViewController * vc = [[FLYServiceRecordViewController alloc] init];
            vc.elderModel = self.elderModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3:
        {
            FLYSendMessageViewController * vc = [[FLYSendMessageViewController alloc] init];
            vc.oldManInfoId = self.oldManInfoId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)refreshData
{
    !self.refreshBlock ?: self.refreshBlock();
}



#pragma mark - setters and getters

-(UIScrollView *)scrollView
{
    if ( _scrollView == nil )
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    }
    return _scrollView;
}

- (FLYElderlyBaseInfoView *)baseInfoView
{
    if( _baseInfoView == nil )
    {
        WeakSelf
        
        _baseInfoView = [[FLYElderlyBaseInfoView alloc] init];
        _baseInfoView.clickBlock = ^(FLYHealthModel * _Nonnull healthModel) {
            
            FLYPhysiologicalChartViewController * vc = [[FLYPhysiologicalChartViewController alloc] init];
            vc.healthModel = healthModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _baseInfoView;
}

- (FLYElderlyMenuView *)menuView
{
    if( _menuView == nil )
    {
        WeakSelf
        _menuView = [[FLYElderlyMenuView alloc] init];
        _menuView.selectBlock = ^(NSInteger index) {
            [weakSelf menuClick:index];
        };
    }
    return _menuView;
}

-(UIView *)bottomView
{
    if ( _bottomView == nil )
    {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = COLORHEX(@"#FBFAFD");
    }
    return _bottomView;
}

- (FLYDeviceStatusView *)deviceStatusView
{
    if( _deviceStatusView == nil )
    {
        WeakSelf
        _deviceStatusView = [[FLYDeviceStatusView alloc] init];
        _deviceStatusView.moreBlock = ^{
        
            FLYDeviceClassificationViewController * vc = [[FLYDeviceClassificationViewController alloc] init];
            vc.elderModel = weakSelf.elderModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _deviceStatusView;
}

-(FLYMotionView *)motionView
{
    if ( _motionView == nil )
    {
        WeakSelf
        _motionView = [[FLYMotionView alloc] init];
        _motionView.moreBlock = ^{
            
            FLYMapViewController * vc = [[FLYMapViewController alloc] init];
            vc.oldManInfoId = weakSelf.oldManInfoId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _motionView;
}

-(FLYMedicineBoxView *)medicineBoxView
{
    if ( _medicineBoxView == nil )
    {
        WeakSelf
        _medicineBoxView = [[FLYMedicineBoxView alloc] init];
        _medicineBoxView.moreBlock = ^{
            
            FLYMedicineBoxMenuViewController * vc = [[FLYMedicineBoxMenuViewController alloc] init];
            vc.oldManInfoId = weakSelf.oldManInfoId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _medicineBoxView;
}


@end
