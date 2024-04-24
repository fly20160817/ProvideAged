//
//  FLYTempAuthorizeViewController.m
//  ProvideAged
//
//  Created by fly on 2021/12/24.
//

#import "FLYTempAuthorizeViewController.h"
#import "FLYLabel.h"
#import "FLYOptionCell.h"
#import "FLYSelectCell.h"
#import "FLYInputCell.h"
#import "FLYInputTipsCell.h"
#import "BRDatePickerView.h"
#import "FLYAuthorizeModel.h"
#import "NSString+FLYExtension.h"

@interface FLYTempAuthorizeViewController ()

@property (nonatomic, strong) FLYLabel * titleLabel;
@property (nonatomic, strong) FLYButton * confirmBtn;

@property (nonatomic, strong) NSMutableArray * dataList;
@property (nonatomic, strong) FLYOptionModel * optionModel;
@property (nonatomic, strong) FLYInputTipsModel * passwordModel;
@property (nonatomic, strong) FLYInputModel * icModel;

@property (nonatomic, strong) FLYAuthorizeModel * authorizeModel;

@end

@implementation FLYTempAuthorizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
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



#pragma mark - DATA

- (void)loadData
{
    [self.tableView reloadData];
}



#pragma mark - NETWORK

- (void)addTempAuthNetwork
{
    NSDictionary * params = @{ @"deviceInfoId" : self.deviceInfoId, @"openTypeList" : self.authorizeModel.openTypeList, @"purpose" : self.authorizeModel.purpose, @"name" : self.authorizeModel.name, @"phone" : self.authorizeModel.phone, @"icCardNo" : self.authorizeModel.icCardNo, @"startTime" : self.authorizeModel.startTime, @"endTime" : self.authorizeModel.endTime };
    
    [FLYNetworkTool postRawWithPath:API_ADDTEMPAUTH params:params success:^(id  _Nonnull json) {
        
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAuthorizationListNotification" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
        
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"临时授权";
    
    [self.view addSubview:self.confirmBtn];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.titleLabel;
    [self.tableView registerClass:[FLYOptionCell class] forCellReuseIdentifier:@"FLYOptionCell"];
    [self.tableView registerClass:[FLYSelectCell class] forCellReuseIdentifier:@"FLYSelectCell"];
    [self.tableView registerClass:[FLYInputCell class] forCellReuseIdentifier:@"FLYInputCell"];
    [self.tableView registerClass:[FLYInputTipsCell class] forCellReuseIdentifier:@"FLYInputTipsCell"];
}



#pragma mark - event handler

- (void)confirmClick:(UIButton *)button
{
    if ( [self.authorizeModel.openTypeList containsObject:@(1)] == NO && [self.authorizeModel.openTypeList containsObject:@(3)] == NO )
    {
        [SVProgressHUD showImage:nil status:@"最少选择一种开门方式"];
        return;
    }
    
    if( [self.authorizeModel.openTypeList containsObject:@(3)] && self.authorizeModel.icCardNo.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入IC卡号"];
        return;
    }
    
    if( [self.authorizeModel.openTypeList containsObject:@(3)] && self.authorizeModel.icCardNo.length != 8 )
    {
        [SVProgressHUD showImage:nil status:@"请输入正确的卡号"];
        return;
    }
    
    if( [self.authorizeModel.openTypeList containsObject:@(1)] && self.authorizeModel.phone.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
        return;
    }
    
    if( [self.authorizeModel.openTypeList containsObject:@(1)] && self.authorizeModel.phone.length != 11 )
    {
        [SVProgressHUD showImage:nil status:@"请输入正确的手机号"];
        return;
    }
    
    if( self.authorizeModel.purpose.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入用途"];
        return;
    }
    
    if( self.authorizeModel.purpose.length > 8 )
    {
        [SVProgressHUD showImage:nil status:@"用途最多输入8个字"];
        return;
    }
    
    if( self.authorizeModel.name.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请填写授权人"];
        return;
    }
    
    if( self.authorizeModel.name.length > 8 )
    {
        [SVProgressHUD showImage:nil status:@"授权人最多输入8个字"];
        return;
    }
    
    if( self.authorizeModel.startTime.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请选择开始日期"];
        return;
    }
    
    if( self.authorizeModel.endTime.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请选择结束日期"];
        return;
    }
    
    [self addTempAuthNetwork];
}

- (void)optionClick:(FLYOptionModel *)optionModel
{
    NSMutableArray * openTypeList = [NSMutableArray array];
    
    if ( optionModel.option1Select == YES )
    {
        [openTypeList addObject:@(3)];
    }
    
    if ( optionModel.option2Select == YES )
    {
        [openTypeList addObject:@(1)];
    }
     
    self.authorizeModel.openTypeList = openTypeList;
    
    [self.tableView reloadData];
}

- (void)selectClick:(FLYSelectModel *)selectModel
{
    if ( [selectModel.title isEqualToString:@"选择开始日期"] )
    {
        [BRDatePickerView showDatePickerWithMode:(BRDatePickerModeYMD) title:@"选择开始日期" selectValue:nil minDate:[NSDate date] maxDate:nil isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            
            selectModel.selectTitle = selectValue;
            self.authorizeModel.startTime = [NSString stringWithFormat:@"%@ 00:00:00", selectValue];
            [self.tableView reloadData];
        }];
    }
    else if ( [selectModel.title isEqualToString:@"选择结束日期"] )
    {
        [BRDatePickerView showDatePickerWithMode:(BRDatePickerModeYMD) title:@"选择结束日期" selectValue:nil minDate:[NSDate date] maxDate:nil isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            
            selectModel.selectTitle = selectValue;
            self.authorizeModel.endTime = [NSString stringWithFormat:@"%@ 23:59:59", selectValue];
            [self.tableView reloadData];
        }];
    }
}

- (void)inputClick:(FLYInputModel *)inputModel
{
    
    if ( [inputModel.title isEqualToString:@"用途*"] )
    {
        self.authorizeModel.purpose = inputModel.content;
    }
    else if ( [inputModel.title isEqualToString:@"授权人"] )
    {
        self.authorizeModel.name = inputModel.content;
    }
    else if ( [inputModel.title isEqualToString:@"IC卡号"] )
    {
        self.authorizeModel.icCardNo = inputModel.content;
    }
}

- (void)inputTipsClick:(FLYInputTipsModel *)inputTipsModel
{
    if ( [inputTipsModel.title isEqualToString:@"手机号"] )
    {
        self.authorizeModel.phone = inputTipsModel.content;
    }
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.optionModel.option2Select )
    {
        if( [self.dataList containsObject:self.passwordModel] == NO )
        {
            [self.dataList insertObject:self.passwordModel atIndex:self.dataList.count - 2];
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
            [self.dataList insertObject:self.icModel atIndex:self.dataList.count - 2];
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
    
    if ( [self.dataList[indexPath.row] isKindOfClass:[FLYOptionModel class]] )
    {
        FLYOptionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FLYOptionCell"];
        cell.optionModel = self.dataList[indexPath.row];
        cell.optionBlock = ^(FLYOptionModel * _Nonnull optionModel) {
            
            [weakSelf optionClick:optionModel];
        };
        return cell;
    }
    
    if ( [self.dataList[indexPath.row] isKindOfClass:[FLYSelectModel class]] )
    {
        FLYSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FLYSelectCell"];
        cell.selectModel = self.dataList[indexPath.row];
        cell.selectBlock = ^(FLYSelectModel * _Nonnull selectModel) {
            
            [weakSelf selectClick:selectModel];
        };
        return cell;
    }
    
    if ( [self.dataList[indexPath.row] isKindOfClass:[FLYInputModel class]] )
    {
        FLYInputCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FLYInputCell"];
        cell.inputModel = self.dataList[indexPath.row];
        cell.inputBlock = ^(FLYInputModel * inputModel, NSString *inputContent) {
             
            inputModel.content = inputContent;
            [weakSelf inputClick:inputModel];
        };
        return cell;
    }
    
    if ( [self.dataList[indexPath.row] isKindOfClass:[FLYInputTipsModel class]] )
    {
        FLYInputTipsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FLYInputTipsCell"];
        cell.inputTipsModel = self.dataList[indexPath.row];
        cell.inputBlock = ^(FLYInputTipsModel * inputTipsModel, NSString *inputContent) {
            
            inputTipsModel.content = inputContent;
            [weakSelf inputTipsClick:inputTipsModel];
        };
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

-(NSArray *)dataList
{
    if ( _dataList == nil )
    {
        FLYInputModel * model2 = [[FLYInputModel alloc] init];
        model2.title = @"用途*";
        model2.placeholder = @"请输入";
        
        FLYInputModel * model3 = [[FLYInputModel alloc] init];
        model3.title = @"授权人";
        model3.placeholder = @"请输入授权人姓名";
        
        FLYSelectModel * model6 = [[FLYSelectModel alloc] init];
        model6.title = @"选择开始日期";
        model6.placeholder = @"请选择";
        
        FLYSelectModel * model7 = [[FLYSelectModel alloc] init];
        model7.title = @"选择结束日期";
        model7.placeholder = @"请选择";
        
        _dataList = @[self.optionModel, model2, model3, model6, model7].mutableCopy;
    }
    return _dataList;
}

-(FLYOptionModel *)optionModel
{
    if ( _optionModel == nil )
    {
        _optionModel = [[FLYOptionModel alloc] init];
        _optionModel.title = @"开门方式";
        _optionModel.option1Title = @"IC卡";
        _optionModel.option2Title = @"密码";
        _optionModel.option1Select = NO;
        _optionModel.option2Select = YES;
        _optionModel.showLine = YES;
    }
    return _optionModel;
}

-(FLYInputTipsModel *)passwordModel
{
    if ( _passwordModel == nil )
    {
        _passwordModel = [[FLYInputTipsModel alloc] init];
        _passwordModel.title = @"手机号";
        _passwordModel.placeholder = @"请输入手机号";
        _passwordModel.tips = @"若开门方式为密码，则手机号必填，密码将会通过短信的方式发送到您的手机，请注意查收！";
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
        _icModel.secureTextEntry = YES;
    }
    return _icModel;
}


-(FLYAuthorizeModel *)authorizeModel
{
    if ( _authorizeModel == nil )
    {
        _authorizeModel = [[FLYAuthorizeModel alloc] init];
        //默认选中一个密码
        _authorizeModel.openTypeList = @[@(1)];
        _authorizeModel.purpose = @"";
        _authorizeModel.name = @"";
        _authorizeModel.phone = @"";
        _authorizeModel.icCardNo = @"";
        _authorizeModel.startTime = @"";
        _authorizeModel.endTime = @"";
    }
    return _authorizeModel;
}

@end
