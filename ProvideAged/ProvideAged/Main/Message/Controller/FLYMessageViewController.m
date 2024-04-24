//
//  FLYMessageViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYMessageViewController.h"
#import "FLYFilterBar.h"
#import "FLYFilterItemView.h"
#import "FLYPopupView.h"
#import "FLYFilterTimeView.h"
#import "UIView+FLYExtension.h"
#import "UITableView+FLYRefresh.h"
#import "FLYMessageCell.h"
#import "UIAlertController+FLYExtension.h"
#import "FLYDeviceManager.h"
#import "FLYMessageModel.h"

@interface FLYMessageViewController () < FLYFilterBarDelegate, UITableViewDelegate, UITableViewDataSource >
{
    NSString * _startTime;
    NSString * _endTime;
    NSString * _type;
}
@property (nonatomic, strong) FLYFilterBar * filterBar;

@property (nonatomic, strong) FLYFilterItemView * itemView;
@property (nonatomic, strong) FLYFilterTimeView * timeView;
@property (nonatomic, strong) FLYPopupView * popupView;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation FLYMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initVariable];
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.filterBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(32);
    }];
    
    CGFloat y = STATUSADDNAV_HEIGHT + self.filterBar.height;
    self.popupView.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}



#pragma mark - DATA

- (void)initVariable
{
    _startTime = @"";
    _endTime = @"";
    _type = @"";
}

- (void)loadData
{
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark - NETWORK

- (void)getMessageListNetwork
{
    NSDictionary * params = @{ @"pageNo" : @(self.tableView.pageNum), @"pageSize" : @(self.tableView.pageSize), @"startDate" : _startTime, @"endDate" : _endTime, @"type" : _type };
    
    [FLYNetworkTool postRawWithPath:API_MESSAGELIST params:params success:^(id json) {
        
        NSArray * array = [FLYMessageModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA][@"list"]];
        
        NSInteger total = [json[SERVER_DATA][@"total"] integerValue];
        [self.tableView loadDataSuccess:array total:total];
        
    } failure:^(id obj) {
        
        [self.tableView loadDataFailed:obj];
    }];
}

//标记消息已读
- (void)readMessageNetwork:(NSString *)idField
{
    NSDictionary * params = @{ @"ids" : @[idField] };
    
    [FLYNetworkTool postRawWithPath:API_READMESSAGE params:params success:^(id json) {
        
        FLYLog(@"已读成功：%@", json);
        
    } failure:^(id obj) {
        
        FLYLog(@"失败：%@", obj);
    }];
}


#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"消息";
    
    [self.view addSubview:self.filterBar];
    [self.view addSubview:self.tableView];
}



#pragma mark - event handler

- (void)callAlert:(FLYMessageModel *)messageModel
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet) titles:@[@"联系服务医生", @"拨打110", @"拨打120", @"拨打119", @"呼叫老人"] alertAction:^(NSInteger index) {
        
        NSString * string = @"";
        
        switch (index)
        {
            case 0:
                string = messageModel.doctorPhone;
                break;
                
            case 1:
                string = @"110";
                break;
                
            case 2:
                string = @"120";
                break;
                
            case 3:
                string = @"119";
                break;
                
            case 4:
                string = messageModel.oldManPhone;
                break;
                
            default:
                break;
        }
        
        [FLYDeviceManager callPhone:string];
        
    }];
    
    UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertController addAction:alertAction];
    
    [alertController show];
}



#pragma mark - FLYFilterBarDelegate

-(void)filterBar:(FLYFilterBar *)filterBar didSelectIndex:(NSInteger)index selectStatus:(BOOL)selectStatus
{
    if ( index == 0 )
    {
        if ( selectStatus )
        {
            [self.popupView.contentView removeAllSubviews];
            [self.popupView.contentView addSubview:self.itemView];
            [self.popupView show];
        }
        else
        {
            [self.popupView dissmiss];
        }
    }
    else if ( index == 1 )
    {
        if ( selectStatus )
        {
            [self.popupView.contentView removeAllSubviews];
            [self.popupView.contentView addSubview:self.timeView];
            [self.popupView show];
        }
        else
        {
            [self.popupView dissmiss];
        }
    }
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableView.dataList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    FLYMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:self.tableView.cellReuseIdentifier forIndexPath:indexPath];
    cell.messageModel = self.tableView.dataList[indexPath.section];
    cell.callBlock = ^(FLYMessageModel * _Nonnull messageModel) {
        
        [weakSelf callAlert:messageModel];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 16 : 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLYMessageModel * messageModel = self.tableView.dataList[indexPath.section];
    messageModel.isRead = 1;
    [self.tableView reloadData];
    
    [self readMessageNetwork:messageModel.idField];
}



#pragma mark - setters and getters

-(FLYFilterBar *)filterBar
{
    if ( _filterBar == nil )
    {
        _filterBar = [[FLYFilterBar alloc] initWithFrame:CGRectZero titleNames:@[@"设备类型", @"告警时间"]];
        _filterBar.delegate = self;
    }
    return _filterBar;
}

-(FLYFilterItemView *)itemView
{
    if ( _itemView == nil )
    {
        FLYKeyValueModel * model1 = [[FLYKeyValueModel alloc] init];
        model1.key = @"";
        model1.value = @"全部";
        
        FLYKeyValueModel * model2 = [[FLYKeyValueModel alloc] init];
        model2.key = @"1";
        model2.value = @"紧急按钮";
        
        FLYKeyValueModel * model3 = [[FLYKeyValueModel alloc] init];
        model3.key = @"2";
        model3.value = @"门磁设备";
        
        FLYKeyValueModel * model4 = [[FLYKeyValueModel alloc] init];
        model4.key = @"3";
        model4.value = @"烟感设备";
        
        FLYKeyValueModel * model5 = [[FLYKeyValueModel alloc] init];
        model5.key = @"4";
        model5.value = @"燃气设备";
        
        FLYKeyValueModel * model6 = [[FLYKeyValueModel alloc] init];
        model6.key = @"5";
        model6.value = @"水浸设备";
        
        FLYKeyValueModel * model7 = [[FLYKeyValueModel alloc] init];
        model7.key = @"6";
        model7.value = @"红外设备";
        
        FLYKeyValueModel * model8 = [[FLYKeyValueModel alloc] init];
        model8.key = @"7";
        model8.value = @"手环设备";
        
        FLYKeyValueModel * model9 = [[FLYKeyValueModel alloc] init];
        model9.key = @"8";
        model9.value = @"床垫设备";
        
        FLYKeyValueModel * model10 = [[FLYKeyValueModel alloc] init];
        model10.key = @"9";
        model10.value = @"血糖仪";
        
        FLYKeyValueModel * model11 = [[FLYKeyValueModel alloc] init];
        model11.key = @"10";
        model11.value = @"颐养卡";
        
        FLYKeyValueModel * model12 = [[FLYKeyValueModel alloc] init];
        model12.key = @"11";
        model12.value = @"血压计";
        
        FLYKeyValueModel * model13 = [[FLYKeyValueModel alloc] init];
        model13.key = @"12";
        model13.value = @"门锁";
        
        FLYKeyValueModel * model14 = [[FLYKeyValueModel alloc] init];
        model14.key = @"13";
        model14.value = @"摄像头";
        
        
        WeakSelf
        StrongSelf
        _itemView = [[FLYFilterItemView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 169)];
        _itemView.itemModels = @[model1, model2, model3, model4, model5, model6, model7, model8, model9, model10, model11, model12, model13, model14];
        _itemView.confirmBlock = ^(NSArray * _Nonnull selectModels) {
            
            FLYKeyValueModel * model = selectModels.lastObject;
            strongSelf -> _type = model.key;
            
            NSString * string = [model.value isEqualToString:@"全部"] ? @"设备类型" : model.value;
            [weakSelf.filterBar changeButtonTitle:string];
            [weakSelf.filterBar refreshButtonStatus];
            [weakSelf.popupView dissmiss];
            
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _itemView;
}

-(FLYFilterTimeView *)timeView
{
    if ( _timeView == nil )
    {
        WeakSelf
        StrongSelf
        _timeView = [[FLYFilterTimeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 152)];
        _timeView.title = @"选择设备告警时间段";
        _timeView.confirmBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime) {
            
            strongSelf -> _startTime = startTime;
            strongSelf -> _endTime = endTime;
            
            [weakSelf.filterBar refreshButtonStatus];
            [weakSelf.popupView dissmiss];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _timeView;
}

-(FLYPopupView *)popupView
{
    if ( _popupView == nil )
    {
        WeakSelf
        _popupView = [FLYPopupView popupView];
        _popupView.animationType = FLYPopupAnimationTypeTop;
        _popupView.maskType = FLYPopupMaskTypeBlack;
        _popupView.noDissmissViews = @[self.filterBar];
        _popupView.dissmissBlock = ^{
            
            [weakSelf.filterBar refreshButtonStatus];
        };
    }
    return _popupView;
}

-(UITableView *)tableView
{
    if ( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = COLORHEX(@"#F9F9F9");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.estimatedRowHeight = 65;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[FLYMessageCell class] forCellReuseIdentifier:_tableView.cellReuseIdentifier];
        [_tableView addRefreshingTarget:self action:@selector(getMessageListNetwork)];
    }
    return _tableView;
}

@end
