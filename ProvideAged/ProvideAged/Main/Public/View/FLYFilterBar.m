//
//  FLYFilterBar.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYFilterBar.h"
#import "FLYButton.h"

@interface FLYFilterBar ()

@property (nonatomic, strong) NSMutableArray * buttons;

@end

@implementation FLYFilterBar


-(instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titleNames
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleNames = titleNames;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}


#pragma mark - UI

- (void)initUI
{
    
}


#pragma mark - event handler

- (void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ( btn != button )
        {
            btn.selected = NO;
        }
    }];
        
    
    if ( [self.delegate respondsToSelector:@selector(filterBar:didSelectIndex:selectStatus:)])
    {
        [self.delegate filterBar:self didSelectIndex:button.tag selectStatus:button.selected];
    }
}



#pragma mark - public methods

/// 刷新按钮的选中状态 (设置为全部未选中)
- (void)refreshButtonStatus
{
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        btn.selected = NO;
    }];
}

/// 改变按钮的title (选中状态的那个按钮)
- (void)changeButtonTitle:(NSString *)title
{
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ( btn.selected )
        {
            [btn setTitle:title forState:(UIControlStateNormal)];
        }
    }];
}



#pragma mark - setters and getters

-(void)setTitleNames:(NSArray *)titleNames
{
    _titleNames = titleNames;
    
    for ( int i = 0; i < titleNames.count; i++ )
    {
        FLYButton * button = [FLYButton buttonWithImage:IMAGENAME(@"shaixuan_xia") title:titleNames[i] titleColor:COLORHEX(@"#333333") font:FONT_M(13)];
        [button setTitleColor:COLORHEX(@"#2BB9A0") forState:(UIControlStateSelected)];
        [button setImage:IMAGENAME(@"shaixuan_shang") forState:UIControlStateSelected];
        [button setImagePosition:(FLYImagePositionRight) spacing:4];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        button.tag = i;
        [self addSubview:button];
        [self.buttons addObject:button];
        
        CGFloat w = SCREEN_WIDTH / titleNames.count;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(w);
            make.left.equalTo(self).with.offset(w * i);
        }];
    }
}

-(NSMutableArray *)buttons
{
    if ( _buttons == nil )
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
