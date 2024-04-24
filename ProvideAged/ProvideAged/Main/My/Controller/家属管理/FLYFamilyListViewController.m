//
//  FLYFamilyListViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYFamilyListViewController.h"
#import "UITableView+FLYRefresh.h"
#import "FLYFamilyCell.h"
#import "FLYFamilyMemberListViewController.h"
#import "FLYFamilyModel.h"

@interface FLYFamilyListViewController () < UITableViewDelegate, UITableViewDataSource >

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation FLYFamilyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    
}



#pragma mark - NETWORK

- (void)getFamilyListNetwork
{
    [FLYNetworkTool postRawWithPath:API_FAMILYLIST params:nil success:^(id json) {
        
        NSArray * array = [FLYFamilyModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        [self.tableView loadDataSuccess:array];
        
    } failure:^(id obj) {
        
        [self.tableView loadDataFailed:obj];
    }];
}


#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"选择家庭";
    
    [self.view addSubview:self.tableView];
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
    FLYFamilyCell * cell = [tableView dequeueReusableCellWithIdentifier:self.tableView.cellReuseIdentifier forIndexPath:indexPath];
    cell.familyModel = self.tableView.dataList[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 15 : 12;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLYFamilyModel * familyModel = self.tableView.dataList[indexPath.section];
    
    FLYFamilyMemberListViewController * vc = [[FLYFamilyMemberListViewController alloc] init];
    vc.familyModel = familyModel;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - setters and getters

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
        _tableView.rowHeight = 77;
        [_tableView registerClass:[FLYFamilyCell class] forCellReuseIdentifier:_tableView.cellReuseIdentifier];
        [_tableView addRefreshingTarget:self action:@selector(getFamilyListNetwork)];
    }
    return _tableView;
}

@end
