//
//  FLYAddMemberViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "FLYAddMemberViewController.h"
#import "UIAlertController+FLYExtension.h"
#import "FLYMemberModel.h"
#import "FLYLabel.h"
#import "FLYTools.h"
#import "UICollectionView+FLYRefresh.h"
#import "FLYMemberLockCell.h"
#import "FLYHouseLockModel.h"
#import "FLYLockAuthorizeViewController.h"
#import "UIView+FLYExtension.h"

@interface FLYAddMemberViewController () < UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) FLYLabel * title1Label;
@property (nonatomic, strong) UILabel * phoneNumLabel;
@property (nonatomic, strong) UITextField * phoneNumTF;
@property (nonatomic, strong) UIView * line1View;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UITextField * nameTF;
@property (nonatomic, strong) UIView * line2View;
@property (nonatomic, strong) UILabel * relationshipLabel;
@property (nonatomic, strong) UITextField * relationshipTF;
@property (nonatomic, strong) FLYLabel * title2Label;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * addBtn;

@end

@implementation FLYAddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(240);
    }];
    
    [self.title1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.headerView).with.offset(0);
        make.height.mas_equalTo(48);
    }];
    
    
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).with.offset(95);
        make.left.equalTo(self.headerView).with.offset(20);
        make.right.equalTo(self.headerView).with.offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).with.offset(25);
        make.bottom.equalTo(self.line1View.mas_top).with.offset(-13);
        make.width.mas_equalTo(100);
    }];
    
    [self.phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneNumLabel.mas_right).with.offset(20);
        make.right.equalTo(self.headerView).with.offset(-25);
        make.centerY.equalTo(self.phoneNumLabel);
    }];
    
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1View.mas_bottom).with.offset(45);
        make.left.equalTo(self.headerView).with.offset(20);
        make.right.equalTo(self.headerView).with.offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).with.offset(25);
        make.bottom.equalTo(self.line2View.mas_top).with.offset(-13);
        make.width.mas_equalTo(100);
    }];
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(20);
        make.right.equalTo(self.headerView).with.offset(-25);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self.relationshipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).with.offset(25);
        make.top.equalTo(self.line2View.mas_bottom).with.offset(20);
        make.width.mas_equalTo(100);
    }];
    
    [self.relationshipTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.relationshipLabel.mas_right).with.offset(20);
        make.right.equalTo(self.headerView).with.offset(-25);
        make.centerY.equalTo(self.relationshipLabel);
    }];
    
    [self.title2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.relationshipLabel.mas_bottom).with.offset(16);
        make.left.bottom.right.equalTo(self.headerView).with.offset(0);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(44);
        CGFloat bottom = [FLYTools safeAreaInsets].bottom == 0 ? 16 : [FLYTools safeAreaInsets].bottom;
        make.bottom.equalTo(self.view).with.offset(-bottom);
    }];
    
}



#pragma mark - DATA

- (void)loadData
{
    if( self.isAdmin )
    {
        self.relationshipTF.text = @"主管理员";
        self.relationshipTF.enabled = NO;
    }
    
    if ( self.familyModel.isBindLock == 2 )
    {
        [self.title2Label removeAllSubviews];
        self.title2Label.text = @"";
        self.collectionView.hidden = YES;
    }
    else
    {
        [self.collectionView.mj_header beginRefreshing];
    }
}



#pragma makr - NETWORK

- (void)getMemberInfoNetwork
{
    NSDictionary * params = @{ @"phone" : self.phoneNumTF.text };
    
    [FLYNetworkTool postRawWithPath:API_MEMBERINFO params:params success:^(id json) {
        
        FLYMemberModel * memberModel = [FLYMemberModel mj_objectWithKeyValues:json[SERVER_DATA]];
        
        if ( memberModel.idField.length != 0 )
        {
            self.phoneNumTF.text = memberModel.phone;
            self.nameTF.text = memberModel.name;
            if ( self.isAdmin == NO )
            {
                self.relationshipTF.text = memberModel.relationship;
            }
            
            self.nameTF.enabled = NO;
        }
        else
        {
            self.nameTF.enabled = YES;
        }
        
    } failure:^(id obj) {
        
        FLYLog(@"失败：%@", obj);
    }];
}

- (void)getHouseLockNetwork
{
    NSDictionary * params = @{ @"id" : self.familyModel.houseInfoId};
    
    [FLYNetworkTool postRawWithPath:API_HOUSELOCK params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:YES success:^(id  _Nonnull json) {
        
        NSArray * array = [FLYHouseLockModel mj_objectArrayWithKeyValuesArray:json[@"content"]];
        [self.collectionView loadDataSuccess:array];
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

- (void)submitNetwork
{
    NSArray * familyAuthArgList = [FLYHouseLockModel mj_keyValuesArrayWithObjectArray:self.collectionView.dataList];
    
    
    NSDictionary * params = @{ @"name" : self.nameTF.text, @"phone" : self.phoneNumTF.text, @"relationship" : self.relationshipTF.text, @"oldManInfoId" : self.familyModel.idField, @"familyAuthArgList" : familyAuthArgList };
    
    [FLYNetworkTool postRawWithPath:API_MEMBERADD params:params success:^(id json) {
        
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(id obj) {
        
        FLYLog(@"添加失败:%@", obj);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"新增家属";
    
    self.view.backgroundColor = COLORHEX(@"#F9F9F9");
    
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.title1Label];
    [self.headerView addSubview:self.phoneNumLabel];
    [self.headerView addSubview:self.phoneNumTF];
    [self.headerView addSubview:self.line1View];
    [self.headerView addSubview:self.nameLabel];
    [self.headerView addSubview:self.nameTF];
    [self.headerView addSubview:self.line2View];
    [self.headerView addSubview:self.relationshipLabel];
    [self.headerView addSubview:self.relationshipTF];
    [self.headerView addSubview:self.title2Label];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.addBtn];
}



#pragma mark - event hander

- (void)addClick:(UIButton *)button
{
    if ( self.phoneNumTF.text.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
        return;
    }
    
    if ( self.phoneNumTF.text.length != 11 )
    {
        [SVProgressHUD showImage:nil status:@"手机号格式不正确"];
        return;
    }
    
    if ( self.nameTF.text.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入家属姓名"];
        return;
    }
    
    if ( self.nameTF.text.length > 6 )
    {
        [SVProgressHUD showImage:nil status:@"家属姓名最多6个字"];
        return;
    }
    
    if ( self.relationshipTF.text.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入家属关系"];
        return;
    }
    
    if ( self.relationshipTF.text.length > 8 )
    {
        [SVProgressHUD showImage:nil status:@"家属关系最多8个字"];
        return;
    }
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定添加该家属" preferredStyle:(UIAlertControllerStyleAlert) titles:@[@"取消", @"确定"] alertAction:^(NSInteger index) {
        
        if( index == 1)
        {
            [self submitNetwork];
        }
    }];
    
    [alertController show];
}



#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( textField == self.phoneNumTF )
    {
        [self getMemberInfoNetwork];
    }
}



#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionView.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYMemberLockCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionView.cellReuseIdentifier forIndexPath:indexPath];
    cell.houseLockModel = self.collectionView.dataList[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYLockAuthorizeViewController * vc = [[FLYLockAuthorizeViewController alloc] init];
    vc.houseLockModel = self.collectionView.dataList[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - setters and getters

-(UICollectionView *)collectionView
{
    if ( _collectionView == nil )
    {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 12;
        flow.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 60);
        flow.sectionInset = UIEdgeInsetsMake(0, 20, 15, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FLYMemberLockCell class] forCellWithReuseIdentifier:_collectionView.cellReuseIdentifier];
        [_collectionView addRefreshingTarget:self action:@selector(getHouseLockNetwork)];
    }
    return _collectionView;
}


-(FLYLabel *)title1Label
{
    if ( _title1Label == nil )
    {
        _title1Label = [[FLYLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
        _title1Label.backgroundColor = COLORHEX(@"#F9F9F9");
        _title1Label.textColor = COLORHEX(@"#2DB9A0");
        _title1Label.font = FONT_M(15);
        _title1Label.text = @"家属信息";
        _title1Label.textEdgeInset = UIEdgeInsetsMake(0, 20, 0, 0);
        
        UIView * colorView = [[UIView alloc] init];
        colorView.backgroundColor = COLORHEX(@"#2BB9A0");
        [_title1Label addSubview:colorView];
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_title1Label);
            make.centerY.equalTo(_title1Label);
            make.size.mas_equalTo(CGSizeMake(2, 13));
        }];
        
    }
    return _title1Label;
}

- (UIView *)headerView
{
    if( _headerView == nil )
    {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UILabel *)phoneNumLabel
{
    if( _phoneNumLabel == nil )
    {
        _phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneNumLabel.font = FONT_R(12);
        _phoneNumLabel.textColor = COLORHEX(@"#999999");
        _phoneNumLabel.text = @"手机号";
    }
    return _phoneNumLabel;
}

- (UITextField *)phoneNumTF
{
    if( _phoneNumTF == nil )
    {
        _phoneNumTF = [[UITextField alloc] init];
        _phoneNumTF.placeholder = @"授权人将通过手机号登入本软件";
        _phoneNumTF.font = FONT_R(12);
        _phoneNumTF.textColor = COLORHEX(@"#333333");
        _phoneNumTF.textAlignment = NSTextAlignmentRight;
        _phoneNumTF.delegate = self;
    }
    return _phoneNumTF;
}

-(UIView *)line1View
{
    if ( _line1View == nil )
    {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = COLORHEX(@"#EAEAEA");
    }
    return _line1View;
}

- (UILabel *)nameLabel
{
    if( _nameLabel == nil )
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT_R(12);
        _nameLabel.textColor = COLORHEX(@"#999999");
        _nameLabel.text = @"家属姓名";
    }
    return _nameLabel;
}

- (UITextField *)nameTF
{
    if( _nameTF == nil )
    {
        _nameTF = [[UITextField alloc] init];
        _nameTF.placeholder = @"请输入";
        _nameTF.font = FONT_R(12);
        _nameTF.textColor = COLORHEX(@"#333333");
        _nameTF.textAlignment = NSTextAlignmentRight;
    }
    return _nameTF;
}

-(UIView *)line2View
{
    if ( _line2View == nil )
    {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = COLORHEX(@"#EAEAEA");
    }
    return _line2View;
}

- (UILabel *)relationshipLabel
{
    if( _relationshipLabel == nil )
    {
        _relationshipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _relationshipLabel.font = FONT_R(12);
        _relationshipLabel.textColor = COLORHEX(@"#999999");
        _relationshipLabel.text = @"家属关系";
    }
    return _relationshipLabel;
}

- (UITextField *)relationshipTF
{
    if( _relationshipTF == nil )
    {
        _relationshipTF = [[UITextField alloc] init];
        _relationshipTF.placeholder = @"请输入";
        _relationshipTF.font = FONT_R(12);
        _relationshipTF.textColor = COLORHEX(@"#333333");
        _relationshipTF.textAlignment = NSTextAlignmentRight;
    }
    return _relationshipTF;
}

-(FLYLabel *)title2Label
{
    if ( _title2Label == nil )
    {
        _title2Label = [[FLYLabel alloc] init];
        _title2Label.backgroundColor = COLORHEX(@"#F9F9F9");
        _title2Label.textColor = COLORHEX(@"#2DB9A0");
        _title2Label.font = FONT_M(15);
        _title2Label.text = @"门锁授权";
        _title2Label.textEdgeInset = UIEdgeInsetsMake(0, 20, 0, 0);
        
        UIView * colorView = [[UIView alloc] init];
        colorView.backgroundColor = COLORHEX(@"#2BB9A0");
        [_title2Label addSubview:colorView];
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_title2Label);
            make.centerY.equalTo(_title2Label);
            make.size.mas_equalTo(CGSizeMake(2, 13));
        }];
        
    }
    return _title2Label;
}

- (UIButton *)addBtn
{
    if( _addBtn == nil )
    {
        _addBtn = [UIButton buttonWithTitle:@"完成" titleColor:[UIColor whiteColor] font:FONT_M(16)];
        [_addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.layer.cornerRadius = 4;
        _addBtn.backgroundColor = COLORHEX(@"#2BB9A0");
    }
    return _addBtn;
}

@end
