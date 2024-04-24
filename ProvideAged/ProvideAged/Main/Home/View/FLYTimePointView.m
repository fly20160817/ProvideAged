//
//  FLYTimePointView.m
//  ProvideAged
//
//  Created by fly on 2022/12/22.
//

#import "FLYTimePointView.h"

@interface FLYTimePointView ()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) NSMutableArray * btnArray;

@end

@implementation FLYTimePointView

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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(self).offset(80);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,3);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 12;
    self.layer.cornerRadius = 10;
    
    
    [self addSubview:self.titleLabel];
    
}

- (void)addButtons
{
    //边距
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(11, 120, 12, 30);
    //列数
    NSInteger column = 3;
    //按钮之间的间距
    CGFloat spacing = 18;
    //按钮上下之间的间距
    CGFloat upAndDownSpacing = 8;
    //按钮的高度
    CGFloat height = 20;
    //按钮宽度
    CGFloat width = ((SCREEN_WIDTH - 40) - spacing * (column - 1) - edgeInsets.left - edgeInsets.right ) / column;

    
    for ( int i = 0; i < self.dataList.count; i++ )
    {
        FLYButton * button = [FLYButton buttonWithTitle:self.dataList[i].arrangeTypeDesc titleColor:COLORHEX(@"#FFFFFF") font:FONT_R(10)];
        [button setBackgroundColor:COLORHEX(@"#D3D6DE") forState:(UIControlStateNormal)];
        [button setBackgroundColor:COLORHEX(@"#31BBA3") forState:(UIControlStateSelected)];
        button.layer.cornerRadius = 10;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        button.tag = i;
        [self addSubview:button];
        [self.btnArray addObject:button];
        
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        
            make.size.mas_equalTo(CGSizeMake(width, height));
            
            CGFloat x = (i % column) * width + (i % column) * spacing + edgeInsets.left;
            make.left.equalTo(self).with.offset(x);
            
            
            CGFloat y = (i / column) * (height + upAndDownSpacing) + edgeInsets.top;
            make.top.equalTo(self).with.offset(y);
            
        }];
    }
}



#pragma mark - event handler

- (void)buttonClick:(UIButton *)button
{
    NSInteger i = 0;
    for (UIButton * btn in self.btnArray)
    {
        if ( btn.selected == YES )
        {
            i += 1;
        }
    }
    
    if ( i >= 3 && button.selected == NO )
    {
        [SVProgressHUD showImage:nil status:@"最多只能选择三个"];
    }
    else
    {
        button.selected = !button.selected;
    }
}



#pragma mark - setters and getters

-(void)setDataList:(NSArray<FLYBoxTimeModel *> *)dataList
{
    _dataList = dataList;
    
    [self addButtons];
}

-(NSArray<FLYBoxTimeModel *> *)selectModels
{
    NSMutableArray * array = [NSMutableArray array];
    
    for (UIButton * btn in self.btnArray)
    {
        if ( btn.selected == YES )
        {
            [array addObject:self.dataList[btn.tag]];
        }
    }
    return array;
}

- (UILabel *)titleLabel
{
    if( _titleLabel == nil )
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = FONT_R(12);
        _titleLabel.textColor = COLORHEX(@"#333333");
        _titleLabel.text = @"服药时间点";
    }
    return _titleLabel;
}

-(NSMutableArray *)btnArray
{
    if ( _btnArray == nil )
    {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

@end
