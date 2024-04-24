//
//  FLYAuthorizeDetailViewController.m
//  ProvideAged
//
//  Created by fly on 2021/12/24.
//

#import "FLYAuthorizeDetailViewController.h"
#import "FLYLabel.h"
#import "FLYOptionCell.h"
#import "FLYSelectCell.h"
#import "FLYInputCell.h"
#import "FLYInputTipsCell.h"

@interface FLYAuthorizeDetailViewController ()

@property (nonatomic, strong) FLYLabel * titleLabel;
@property (nonatomic, strong) FLYButton * deleteBtn;

@property (nonatomic, strong) NSArray * dataList;

@end

@implementation FLYAuthorizeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.view).with.offset(SAFE_BOTTOM == 0 ? -20 : -SAFE_BOTTOM);
    }];
}



#pragma mark - DATA

- (void)loadData
{
    self.tableView.dataList = self.dataList.mutableCopy;
    [self.tableView reloadData];
}



#pragma mark - NETWORK

- (void)deleteAuthorizeNetwork
{
    NSDictionary * params = @{ @"batchId" : self.authorizeModel.batchId, @"deviceInfoId" : self.authorizeModel.deviceInfoId };
    
    [FLYNetworkTool postRawWithPath:API_DELETEAUTH params:params success:^(id  _Nonnull json) {
        
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAuthorizationListNotification" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败 = %@", error);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"查看授权";
    
    [self.view addSubview:self.deleteBtn];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.titleLabel;
    [self.tableView registerClass:[FLYOptionCell class] forCellReuseIdentifier:@"FLYOptionCell"];
    [self.tableView registerClass:[FLYSelectCell class] forCellReuseIdentifier:@"FLYSelectCell"];
    [self.tableView registerClass:[FLYInputCell class] forCellReuseIdentifier:@"FLYInputCell"];
    [self.tableView registerClass:[FLYInputTipsCell class] forCellReuseIdentifier:@"FLYInputTipsCell"];
}



#pragma mark - event handler

- (void)deleteBtnClick:(UIButton *)button
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"删除授权" message:@"解除授权后，将无法开启门锁？" preferredStyle:(UIAlertControllerStyleAlert) titles:@[@"取消", @"确认"] alertAction:^(NSInteger index) {
        
        if ( index == 1 )
        {
            [self deleteAuthorizeNetwork];
        }
    }];
    
    [alertController show];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [tableView.dataList[indexPath.row] isKindOfClass:[FLYOptionModel class]] )
    {
        FLYOptionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FLYOptionCell"];
        cell.optionModel = tableView.dataList[indexPath.row];
        return cell;
    }
    
    if ( [tableView.dataList[indexPath.row] isKindOfClass:[FLYSelectModel class]] )
    {
        FLYSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FLYSelectCell"];
        cell.selectModel = tableView.dataList[indexPath.row];
        return cell;
    }
    
    if ( [tableView.dataList[indexPath.row] isKindOfClass:[FLYInputModel class]] )
    {
        FLYInputCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FLYInputCell"];
        cell.inputModel = tableView.dataList[indexPath.row];
        return cell;
    }
    
    if ( [tableView.dataList[indexPath.row] isKindOfClass:[FLYInputTipsModel class]] )
    {
        FLYInputTipsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FLYInputTipsCell"];
        cell.inputTipsModel = tableView.dataList[indexPath.row];
        return cell;
    }
    
    
    return nil;
}



#pragma mark - setters and getters

-(FLYLabel *)titleLabel
{
    if ( _titleLabel == nil )
    {
        _titleLabel = [[FLYLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _titleLabel.textColor = COLORHEX(@"#333333");
        _titleLabel.font = FONT_R(13);
        _titleLabel.text = @"授权信息";
        _titleLabel.textEdgeInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _titleLabel.backgroundColor = COLORHEX(@"#F9F9F9");
    }
    return _titleLabel;
}

-(FLYButton *)deleteBtn
{
    if ( _deleteBtn == nil )
    {
        _deleteBtn = [FLYButton buttonWithTitle:@"删除" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        _deleteBtn.backgroundColor = [UIColor colorWithRed:43/255.0 green:185/255.0 blue:160/255.0 alpha:1.0];
        _deleteBtn.layer.cornerRadius = 4;
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _deleteBtn;
}

-(NSArray *)dataList
{
    if ( _dataList == nil )
    {
        FLYOptionModel * model1 = [[FLYOptionModel alloc] init];
        model1.title = @"开门方式";
        model1.option1Title = @"IC卡";
        model1.option2Title = @"密码";
        model1.option1Select = [self.authorizeModel.openTypeList containsObject:@(3)] ? YES : NO;
        model1.option2Select = [self.authorizeModel.openTypeList containsObject:@(1)] ? YES : NO;
        model1.showLine = YES;
        model1.isEdit = NO;
        
        FLYSelectModel * model2 = [[FLYSelectModel alloc] init];
        model2.title = @"用途*";
        model2.placeholder = @"请选择";
        model2.isEdit = NO;
        model2.selectTitle = self.authorizeModel.purpose;
        
        FLYInputModel * model3 = [[FLYInputModel alloc] init];
        model3.title = @"授权人";
        model3.placeholder = @"请输入授权人姓名";
        model3.isEdit = NO;
        model3.content = self.authorizeModel.name;
        
        FLYInputTipsModel * model4 = [[FLYInputTipsModel alloc] init];
        model4.title = @"手机号";
        model4.placeholder = @"请输入手机号";
        model4.tips = @"若开门方式为密码，则手机号必填，密码将会通过短信的方式发送到您的手机，请注意查收！";
        model4.isEdit = NO;
        model4.content = self.authorizeModel.phone;
        
        FLYInputModel * model5 = [[FLYInputModel alloc] init];
        model5.title = @"IC卡号";
        model5.placeholder = @"请输入卡号";
        model5.isEdit = NO;
        model5.content = self.authorizeModel.icCardNo;
        
        FLYSelectModel * model6 = [[FLYSelectModel alloc] init];
        model6.title = @"选择开始日期";
        model6.placeholder = @"请选择";
        model6.isEdit = NO;
        model6.selectTitle = self.authorizeModel.startTime;
        
        FLYSelectModel * model7 = [[FLYSelectModel alloc] init];
        model7.title = @"选择结束日期";
        model7.placeholder = @"请选择";
        model7.isEdit = NO;
        model7.selectTitle = self.authorizeModel.endTime;
        
        NSMutableArray * array = @[model1, model2, model3, model4, model5, model6, model7].mutableCopy;
        
        if ( [self.authorizeModel.openTypeList containsObject:@(3)] == NO )
        {
            [array removeObject:model5];
        }
        
        if ( [self.authorizeModel.openTypeList containsObject:@(1)] == NO )
        {
            [array removeObject:model4];
        }
        
        _dataList = array.copy;
        
    }
    return _dataList;
}


@end
