//
//  FLYScreenListView.m
//  dorm
//
//  Created by fly on 2021/11/22.
//

#import "FLYScreenListView.h"
#import "UIView+FLYLayer.h"

@interface FLYScreenListView () < UIPickerViewDelegate, UIPickerViewDataSource >

@property (nonatomic, strong) UIView * line1View;
@property (nonatomic, strong) UIView * line2View;
@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) FLYButton * cancelBtn;
@property (nonatomic, strong) FLYButton * confirmBtn;

@end

@implementation FLYScreenListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(-68);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1View.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.line2View.mas_top).with.offset(0);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2View.mas_bottom).with.offset(15);
        make.right.equalTo(self.mas_centerX).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(95, 38));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2View.mas_bottom).with.offset(15);
        make.left.equalTo(self.mas_centerX).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(95, 38));
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.line1View];
    [self addSubview:self.line2View];
    [self addSubview:self.pickerView];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.confirmBtn];
}



#pragma mark - event handler


- (void)confirmClick:(UIButton *)button
{
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    
    if ( row < self.dataList.count )
    {
        FLYKeyValueModel * keyValueModel = self.dataList[row];
        !self.confirmBlock ?: self.confirmBlock(keyValueModel);
    }
    else
    {
        !self.confirmBlock ?: self.confirmBlock(nil);
    }
}

- (void)cancelClick:(UIButton *)button
{
    !self.cancelBlock ?: self.cancelBlock();
}



#pragma mark - UIPickerViewDataSource

//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//设置每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataList.count;
}



#pragma mark - UIPickerViewDelegate

//每一行显示的内容
- ( NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    FLYKeyValueModel * keyValueModel = self.dataList[row];
    return keyValueModel.value;
}

//设置列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH;
}

//设置行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 39;
}

////触发事件 (滑动停止时调用)
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    //获取第0列选中的是第几行
//    NSInteger first = [pickerView selectedRowInComponent:0];
//    NSInteger second = [pickerView selectedRowInComponent:1];
//
//    NSLog(@"%@ %@", self.dataList[first], self.dataList[second]);
//}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *lbl = (UILabel *)view;
    
    if (lbl == nil)
    {
        lbl = [[UILabel alloc] init];
        lbl.font = FONT_R(16);
        lbl.textColor = COLORHEX(@"#666666");
        lbl.textAlignment = NSTextAlignmentCenter;
    }
    
    lbl.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return lbl;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    UILabel *piketLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
    piketLabel.textColor = COLORHEX(@"#508AFA");
    
}



#pragma mark - setters and getters

-(void)setDataList:(NSArray<FLYKeyValueModel *> *)dataList
{
    _dataList = dataList;
        
    [self.pickerView reloadAllComponents];    
}

- (UIView *)line1View
{
    if( _line1View == nil )
    {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = COLORHEX(@"#EAEAEA");
    }
    return _line1View;
}

- (UIView *)line2View
{
    if( _line2View == nil )
    {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = COLORHEX(@"#EAEAEA");
    }
    return _line2View;
}

-(UIPickerView *)pickerView
{
    if ( _pickerView == nil )
    {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (FLYButton *)cancelBtn
{
    if( _cancelBtn == nil )
    {
        _cancelBtn = [FLYButton buttonWithTitle:@"取消" titleColor:COLORHEX(@"#333333") font:FONT_S(13)];
        _cancelBtn.backgroundColor = COLORHEX(@"#FFFFFF");
        [_cancelBtn roundCorner:19 borderWidth:0.5 borderColor:COLORHEX(@"#BABABA")];
        [_cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

- (FLYButton *)confirmBtn
{
    if( _confirmBtn == nil )
    {
        _confirmBtn = [FLYButton buttonWithTitle:@"确认" titleColor:COLORHEX(@"#FFFFFF") font:FONT_S(13)];
        _confirmBtn.backgroundColor = COLORHEX(@"#508AFA");
        [_confirmBtn roundCorner:19];
        [_confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmBtn;
}

@end
