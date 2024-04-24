//
//  FLYAddDrugViewController.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYAddDrugViewController.h"
#import "FLYAddDrugCell.h"
#import "FLYAddDrugModel.h"
#import "UICollectionView+FLYRefresh.h"

@interface FLYAddDrugViewController () < UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * confirmBtn;

@property (nonatomic, strong) NSArray * dataList;

@end

@implementation FLYAddDrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(8);
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(50);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.left.bottom.right.equalTo(self.view).with.offset(0);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.view).with.offset(-([FLYTools safeAreaInsets].bottom + 17));
    }];
}



#pragma mark - DATA

- (void)loadData
{

    [self.collectionView reloadData];
}



#pragma mark - NETWORK

- (void)addDrugNetwork
{
    FLYAddDrugModel * nameModel = self.dataList[0];
    FLYAddDrugModel * brandModel = self.dataList[1];
    FLYAddDrugModel * specsModel = self.dataList[2];
    FLYAddDrugModel * numModel = self.dataList[3];
    FLYAddDrugModel * surplusNumModel = self.dataList[4];
    
    NSDictionary * params = @{ @"brand" : brandModel.content, @"deviceId" : self.deviceId, @"name" : nameModel.content, @"oldManInfoId" : self.oldManInfoId, @"specs" : [NSString stringWithFormat:@"%@*%@", specsModel.content, numModel.content], @"surplus" : surplusNumModel.content };
    
    [FLYNetworkTool postRawWithPath:API_ADDDRUG params:params success:^(id  _Nonnull json) {
        
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
    }];
}

- (void)updateDrugNetwork
{
    FLYAddDrugModel * surplusNumModel = self.dataList[4];
    
    NSDictionary * params = @{ @"brand" : self.drugModel.brand, @"deviceId" : self.deviceId, @"name" : self.drugModel.name, @"oldManInfoId" : self.oldManInfoId, @"specs" : self.drugModel.specs, @"supplement" : surplusNumModel.content, @"id" : self.drugModel.idField };
    
    [FLYNetworkTool postRawWithPath:API_UPDATEDRUG params:params success:^(id  _Nonnull json) {
        
        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
    }];
}


#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = self.type == 1 ? @"补充药品" : @"添加药品";
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.confirmBtn];
}



#pragma mark - event handler

- (void)confirmClick:(UIButton *)button
{
    FLYAddDrugModel * model1 = self.dataList[0];
    if ( model1.content.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入名称"];
        return;
    }
    
    FLYAddDrugModel * model2 = self.dataList[1];
    if ( model2.content.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入品牌"];
        return;
    }
    
    FLYAddDrugModel * model3 = self.dataList[2];
    if ( model3.content.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入含量"];
        return;
    }
    
    FLYAddDrugModel * model4 = self.dataList[3];
    if ( model4.content.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入数量"];
        return;
    }
    
    FLYAddDrugModel * model5 = self.dataList[4];
    if ( model5.content.length == 0 )
    {
        [SVProgressHUD showImage:nil status:@"请输入剩余数量"];
        return;
    }
    
    
    
    self.type == 1 ? [self updateDrugNetwork] : [self addDrugNetwork];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLYAddDrugCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionView.cellReuseIdentifier forIndexPath:indexPath];
    
    cell.model = self.dataList[indexPath.row];
    
    return cell;
}



#pragma mark - setters and getters

-(NSArray *)dataList
{
    if ( _dataList == nil )
    {
        FLYAddDrugModel * model1 = [[FLYAddDrugModel alloc] init];
        model1.title = @"药品名称";
        model1.content = self.drugModel.name;
        model1.placeholder = @"请输入名称";
        model1.isEditing = self.type == 0;
        
        FLYAddDrugModel * model2 = [[FLYAddDrugModel alloc] init];
        model2.title = @"药品品牌";
        model2.content = self.drugModel.brand;
        model2.placeholder = @"请输入品牌";
        model2.isEditing = self.type == 0;
        
        FLYAddDrugModel * model3 = [[FLYAddDrugModel alloc] init];
        model3.title = @"药品含量";
        model3.content = [self.drugModel.specs componentsSeparatedByString:@"*"].firstObject;
        model3.placeholder = @"请输入含量";
        model3.isEditing = self.type == 0;
        
        FLYAddDrugModel * model4 = [[FLYAddDrugModel alloc] init];
        model4.title = @"药品数量";
        model4.content = [self.drugModel.specs componentsSeparatedByString:@"*"].lastObject;
        model4.placeholder = @"请输入数量";
        model4.isEditing = self.type == 0;
        
        FLYAddDrugModel * model5 = [[FLYAddDrugModel alloc] init];
        model5.title = self.type == 0 ? @"剩余数量" : @"补充数量";
        model5.content = self.type == 0 ? self.drugModel.surplus : @"";
        model5.placeholder = @"请输入数量";
        model5.isEditing = YES;
        
        _dataList = @[ model1, model2, model3, model4, model5 ];
        
    }
    return _dataList;
}

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_R(16);
        _titleLabel.textColor = COLORHEX(@"#333333");
        _titleLabel.text = @"药品信息";
    }
    return _titleLabel;
}


-(UICollectionView *)collectionView
{
    if ( _collectionView == nil )
    {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumInteritemSpacing = 0;
        flow.minimumInteritemSpacing = 10;
        flow.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 45);
        flow.sectionInset = UIEdgeInsetsMake(0, 20, 20, 20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = COLORHEX(@"#F9F9F9");
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FLYAddDrugCell class] forCellWithReuseIdentifier:_collectionView.cellReuseIdentifier];
    }
    return _collectionView;
}

-(UIButton *)confirmBtn
{
    if ( _confirmBtn == nil )
    {
        _confirmBtn = [UIButton buttonWithTitle:@"确定" titleColor:COLORHEX(@"#FFFFFF") font:FONT_M(16)];
        _confirmBtn.backgroundColor = COLORHEX(@"#31BBA3");
        _confirmBtn.layer.cornerRadius = 4;
        [_confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmBtn;
}

@end


