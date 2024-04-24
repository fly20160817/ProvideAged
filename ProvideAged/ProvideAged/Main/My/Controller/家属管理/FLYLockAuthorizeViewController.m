//
//  FLYLockAuthorizeViewController.m
//  ProvideAged
//
//  Created by fly on 2021/12/24.
//

#import "FLYLockAuthorizeViewController.h"
#import "FLYOptionCell.h"
#import "FLYInputCell.h"
#import "FLYSwitchCell.h"
#import "FLYFamilyMemberListViewController.h"

@interface FLYLockAuthorizeViewController ()

@property (nonatomic, strong) FLYButton * confirmBtn;
@property (nonatomic, strong) NSMutableArray * dataList;

@property (nonatomic, strong) FLYSwitchModel * switchModel;
@property (nonatomic, strong) FLYOptionModel * optionModel;
@property (nonatomic, strong) FLYInputModel * passwordModel;
@property (nonatomic, strong) FLYInputModel * icModel;

@end

@implementation FLYLockAuthorizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.view).with.offset(SAFE_BOTTOM == 0 ? -20 : -SAFE_BOTTOM);
    }];
}



#pragma mark - NETWORK




#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"门锁授权";
    
    [self.view addSubview:self.confirmBtn];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    [self.tableView registerClass:[FLYSwitchCell class] forCellReuseIdentifier:@"FLYSwitchCell"];
    [self.tableView registerClass:[FLYOptionCell class] forCellReuseIdentifier:@"FLYOptionCell"];
    [self.tableView registerClass:[FLYInputCell class] forCellReuseIdentifier:@"FLYInputCell"];
}



#pragma mark - event handler

- (void)confirmClick:(UIButton *)button
{
    if ( self.switchModel.isOpen == NO )
    {
        self.houseLockModel.isAuthorize = 2;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if ( self.optionModel.option1Select == NO && self.optionModel.option2Select == NO )
    {
        [SVProgressHUD showImage:nil status:@"最少选择一种开门方式"];
        return;
    }
    
    if( self.optionModel.option1Select == YES && self.icModel.content.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入IC卡号"];
        return;
    }
    
    if( self.optionModel.option1Select == YES && self.icModel.content.length != 8 )
    {
        [SVProgressHUD showImage:nil status:@"请输入正确的卡号"];
        return;
    }
    
    if( self.optionModel.option2Select == YES && self.passwordModel.content.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
        return;
    }
    
    if( self.optionModel.option2Select == YES && self.passwordModel.content.length != 6 )
    {
        [SVProgressHUD showImage:nil status:@"请输入正确的密码"];
        return;
    }
    
    
    self.houseLockModel.isAuthorize = 1;
    self.houseLockModel.passWord = self.passwordModel.content;
    self.houseLockModel.icCardNo = self.icModel.content;
    
    NSMutableArray * openTypeList = [NSMutableArray array];
    
    if ( self.optionModel.option1Select == YES )
    {
        [openTypeList addObject:@(3)];
    }
    
    if ( self.optionModel.option2Select == YES )
    {
        [openTypeList addObject:@(1)];
    }
     
    self.houseLockModel.openTypeList = openTypeList;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inputClick:(FLYInputModel *)inputModel inputContent:(NSString *)inputContent
{
    inputModel.content = inputContent;
    [self.tableView reloadData];
}

- (void)switchClick:(FLYSwitchModel *)switchModel
{
    switchModel.isOpen = !switchModel.isOpen;
    [self.tableView reloadData];
}

- (void)optionClick:(FLYOptionModel *)optionModel
{
    [self.tableView reloadData];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.switchModel.isOpen == NO )
    {
        return 1;
    }
    
    
    if ( self.optionModel.option2Select )
    {
        if( [self.dataList containsObject:self.passwordModel] == NO )
        {
            [self.dataList addObject:self.passwordModel];
        }
    }
    else
    {
        [self.dataList removeObject:self.passwordModel];
    }
    
    if ( self.optionModel.option1Select )
    {
        if( [self.dataList containsObject:self.icModel] == NO )
        {
            [self.dataList addObject:self.icModel];
        }
    }
    else
    {
        [self.dataList removeObject:self.icModel];
    }
    
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    
    if ( [self.dataList[indexPath.row] isKindOfClass:[FLYSwitchModel class]] )
    {
        FLYSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FLYSwitchCell"];
        cell.switchModel = self.dataList[indexPath.row];
        cell.switchBlock = ^(FLYSwitchModel * _Nonnull switchModel) {
            [weakSelf switchClick:switchModel];
        };
        return cell;
    }
    
    if ( [self.dataList[indexPath.row] isKindOfClass:[FLYOptionModel class]] )
    {
        FLYOptionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FLYOptionCell"];
        cell.optionModel = self.dataList[indexPath.row];
        cell.optionBlock = ^(FLYOptionModel * optionModel) {
            [weakSelf optionClick:optionModel];
        };
        return cell;
    }
    
    if ( [self.dataList[indexPath.row] isKindOfClass:[FLYInputModel class]] )
    {
        FLYInputCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FLYInputCell"];
        cell.inputModel = self.dataList[indexPath.row];
        cell.inputBlock = ^(FLYInputModel * inputModel, NSString *inputContent) {
             
            inputModel.content = inputContent;
            [weakSelf inputClick:inputModel inputContent:inputContent];
        };
        return cell;
    }
    
    return nil;
}



#pragma mark - setters and getters

-(FLYButton *)confirmBtn
{
    if ( _confirmBtn == nil )
    {
        _confirmBtn = [FLYButton buttonWithTitle:@"完成" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        _confirmBtn.backgroundColor = [UIColor colorWithRed:43/255.0 green:185/255.0 blue:160/255.0 alpha:1.0];
        _confirmBtn.layer.cornerRadius = 4;
        [_confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmBtn;
}

-(NSMutableArray *)dataList
{
    if ( _dataList == nil )
    {
        _dataList = @[self.switchModel, self.optionModel].mutableCopy;
    }
    return _dataList;
}

-(FLYSwitchModel *)switchModel
{
    if ( _switchModel == nil )
    {
        _switchModel = [[FLYSwitchModel alloc] init];
        _switchModel.title = @"是否授权门锁";
        _switchModel.isOpen = self.houseLockModel.isAuthorize == 1 ? YES : NO;
    }
    return _switchModel;
}

-(FLYOptionModel *)optionModel
{
    if ( _optionModel == nil )
    {
        _optionModel = [[FLYOptionModel alloc] init];
        _optionModel.title = @"开门方式";
        _optionModel.option1Title = @"IC卡";
        _optionModel.option2Title = @"密码";
        _optionModel.option1Select = [self.houseLockModel.openTypeList containsObject:@(3)];
        _optionModel.option2Select = [self.houseLockModel.openTypeList containsObject:@(1)];
        _optionModel.showLine = YES;
    }
    return _optionModel;
}

-(FLYInputModel *)passwordModel
{
    if ( _passwordModel == nil )
    {
        _passwordModel = [[FLYInputModel alloc] init];
        _passwordModel.title = @"密码";
        _passwordModel.placeholder = @"选择密码后，密码将发送到授权手机号";
        _passwordModel.content = self.houseLockModel.passWord;
        _passwordModel.secureTextEntry = YES;
        _passwordModel.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _passwordModel;
}

-(FLYInputModel *)icModel
{
    if ( _icModel == nil )
    {
        _icModel = [[FLYInputModel alloc] init];
        _icModel.title = @"IC卡号";
        _icModel.placeholder = @"请输入";
        _icModel.content = self.houseLockModel.icCardNo;
        _icModel.secureTextEntry = YES;
    }
    return _icModel;
}

@end
