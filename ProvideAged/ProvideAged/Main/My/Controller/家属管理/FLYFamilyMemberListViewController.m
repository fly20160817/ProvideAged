//
//  FLYFamilyMemberListViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYFamilyMemberListViewController.h"
#import "UITableView+FLYRefresh.h"
#import "FLYFamilyMemberCell.h"
#import "FLYButton.h"
#import "FLYTools.h"
#import "FLYAddMemberViewController.h"
#import "FLYMemberDetailViewController.h"
#import "FLYLabel.h"

@interface FLYFamilyMemberListViewController () < UITableViewDelegate, UITableViewDataSource >

@property (nonatomic, strong) FLYLabel * headerView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) FLYButton * addMemberBtn;

@end

@implementation FLYFamilyMemberListViewController

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
    
    if ( self.addMemberBtn.superview != nil )
    {
        [self.addMemberBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(20);
            make.right.equalTo(self.view).with.offset(-20);
            CGFloat bottom = ([FLYTools safeAreaInsets].bottom) > 0 ? -([FLYTools safeAreaInsets].bottom) : -16;
            make.bottom.equalTo(self.view).with.offset(bottom);
            make.height.mas_equalTo(44);
        }];
    }
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        
        if ( self.addMemberBtn.superview != nil )
        {
            make.bottom.equalTo(self.addMemberBtn.mas_top);
        }
        else
        {
            make.bottom.equalTo(self.view);
        }
    }];
}



#pragma mark - DATA

- (void)loadData
{
   
}



#pragma makr - NETWORK

- (void)getMemberListNetwork
{
    NSDictionary * params = @{ @"oldManInfoId" : self.familyModel.idField };
    
    [FLYNetworkTool postRawWithPath:API_MEMBERLIST params:params success:^(id json) {
        
        NSArray * array = [FLYMemberModel mj_objectArrayWithKeyValuesArray:json[SERVER_DATA]];
        [self.tableView loadDataSuccess:array];
        
    } failure:^(id obj) {
        
        [self.tableView loadDataFailed:obj];
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"家庭列表";
    
    [self.view addSubview:self.tableView];
    
    if ( self.familyModel.type == 1 || self.familyModel.type == 2 )
    {
        [self.view addSubview:self.addMemberBtn];
    }
}



#pragma mark - event handler

- (void)addClick:(UIButton *)button
{
    FLYAddMemberViewController * vc = [[FLYAddMemberViewController alloc] init];
    vc.familyModel = self.familyModel;
    //当列表只有老人一个的时候，新建的第一个必须是管理员
    if ( self.tableView.dataList.count <= 1 )
    {
        vc.isAdmin = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
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
    FLYFamilyMemberCell * cell = [tableView dequeueReusableCellWithIdentifier:_tableView.cellReuseIdentifier forIndexPath:indexPath];
    cell.memberModel = self.tableView.dataList[indexPath.section];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.familyModel.type != 1 && self.familyModel.type != 2 )
    {
        return;
    }
    
    FLYMemberModel * memberModel = self.tableView.dataList[indexPath.section];
    
    if ( memberModel.type == 1 && [memberModel.name isEqualToString:[FLYUser sharedUser].name] == NO )
    {
        [SVProgressHUD showImage:nil status:@"管理员不能修改老人信息"];
        return;
    }
    
    
    FLYMemberDetailViewController * vc = [[FLYMemberDetailViewController alloc] init];
    vc.memberModel = self.tableView.dataList[indexPath.section];
    vc.familyModel = self.familyModel;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - setters and getters

-(UITableView *)tableView
{
    if ( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.backgroundColor = COLORHEX(@"#F9F9F9");
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 112;
        _tableView.sectionHeaderHeight = 15;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[FLYFamilyMemberCell class] forCellReuseIdentifier:_tableView.cellReuseIdentifier];
        [_tableView addRefreshingTarget:self action:@selector(getMemberListNetwork)];
    }
    return _tableView;
}

-(FLYLabel *)headerView
{
    if ( _headerView == nil )
    {
        _headerView = [[FLYLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 33)];
        _headerView.textColor = COLORHEX(@"#2DB9A0");
        _headerView.font = FONT_M(15);
        _headerView.text = [NSString stringWithFormat:@"%@的家庭", self.familyModel.name];
        _headerView.textEdgeInset = UIEdgeInsetsMake(17, 20, 0, 0);
        
        UIView * colorView = [[UIView alloc] init];
        colorView.backgroundColor = COLORHEX(@"#2BB9A0");
        [_headerView addSubview:colorView];
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView);
            make.top.equalTo(_headerView).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(2, 13));
        }];
        
    }
    return _headerView;
}

-(FLYButton *)addMemberBtn
{
    if ( _addMemberBtn == nil )
    {
        _addMemberBtn = [FLYButton buttonWithTitle:@"新增家属" titleColor:[UIColor whiteColor] font:FONT_M(16)];
        _addMemberBtn.backgroundColor = COLORHEX(@"#2BB9A0");
        _addMemberBtn.layer.cornerRadius = 4;
        [_addMemberBtn addTarget:self action:@selector(addClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addMemberBtn;
}

@end
