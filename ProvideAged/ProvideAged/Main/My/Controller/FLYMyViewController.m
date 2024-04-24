//
//  FLYMyViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYMyViewController.h"
#import "FLYMyCell.h"
#import "UITableView+FLYRefresh.h"
#import "FLYMyModel.h"
#import "FLYMyHeaderView.h"
#import "FLYFamilyListViewController.h"
#import "FLYOpinionViewController.h"
#import "UIAlertController+FLYExtension.h"
#import "FLYUserAction.h"

@interface FLYMyViewController () < UITableViewDelegate, UITableViewDataSource >

@property (nonatomic, strong) FLYMyHeaderView * headerView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) FLYButton * logoutBtn;

@property (nonatomic, strong) NSArray * dataList;

@end

@implementation FLYMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    [self.logoutBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.bottom.equalTo(self.view).with.offset(-25);
        make.height.mas_equalTo(44);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    self.headerView.name = [FLYUser sharedUser].name;
    self.headerView.phoneNum = [FLYUser sharedUser].phone;
}



#pragma makr - NETWORK

//退出登录
- (void)logoutNetwork
{
    [FLYUserAction exitAction];
    
    [FLYNetworkTool postRawWithPath:API_LOGOUT params:nil success:^(id json) {
        
        FLYLog(@"退出成功：%@",  json);
        
    } failure:^(id obj) {
        
        FLYLog(@"退出失败：%@", obj);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"我的";
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.logoutBtn];
}


#pragma mark - event handler

- (void)logoutClick
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定退出登录" preferredStyle:(UIAlertControllerStyleAlert) titles:@[@"取消", @"确定"] alertAction:^(NSInteger index) {
        
        if ( index == 1 )
        {
            [self logoutNetwork];
        }
    }];
    
    [alertController show];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLYMyCell * cell = [tableView dequeueReusableCellWithIdentifier:_tableView.cellReuseIdentifier forIndexPath:indexPath];
    
    cell.myModel = self.dataList[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 )
    {
        FLYFamilyListViewController * vc = [[FLYFamilyListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ( indexPath.row == 1 )
    {
        FLYOpinionViewController * vc = [[FLYOpinionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



#pragma mark - setters and getters

-(UITableView *)tableView
{
    if ( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.backgroundColor = COLORHEX(@"#FFFFFF");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.rowHeight = 45;
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.tableHeaderView = self.headerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FLYMyCell class] forCellReuseIdentifier:_tableView.cellReuseIdentifier];
    }
    return _tableView;
}

-(FLYMyHeaderView *)headerView
{
    if ( _headerView == nil )
    {
        _headerView = [[FLYMyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 122)];
    }
    return _headerView;
}

-(FLYButton *)logoutBtn
{
    if ( _logoutBtn == nil )
    {
        _logoutBtn = [FLYButton buttonWithTitle:@"退出登录" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        _logoutBtn.backgroundColor = [UIColor colorWithRed:43/255.0 green:185/255.0 blue:160/255.0 alpha:1.0];
        _logoutBtn.layer.cornerRadius = 4;
        [_logoutBtn addTarget:self action:@selector(logoutClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _logoutBtn;
}

-(NSArray *)dataList
{
    if ( _dataList == nil )
    {
        FLYMyModel * model1 = [[FLYMyModel alloc] init];
        model1.iconName = @"jiashuguanli";
        model1.title = @"家属信息";
        model1.isLine = YES;
        model1.isArrow = YES;
        
        FLYMyModel * model2 = [[FLYMyModel alloc] init];
        model2.iconName = @"yijianfankui";
        model2.title = @"意见反馈";
        model2.isLine = YES;
        model2.isArrow = YES;
        
        FLYMyModel * model3 = [[FLYMyModel alloc] init];
        model3.iconName = @"guanyuwomen";
        model3.title = @"关于我们";
        model3.isLine = YES;
        model3.isArrow = YES;
        
        _dataList = @[model1, model2/*, model3*/];
    }
    return _dataList;
}

@end
