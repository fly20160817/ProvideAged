//
//  FLYTextView.m
//  FLYKit
//
//  Created by fly on 2021/9/1.
//

#import "FLYTextView.h"

@interface FLYTextView ()
{
    BOOL _autoWrap;//是否自动换行
    CGFloat _originalHeight;//最初的高度
    CGFloat _maxHeight;//自动换行的最大高度
}

@property (nonatomic, strong) UILabel * placeholderLabel;

//自动换行高度更新时的block
@property (nonatomic, copy) void(^heightChangeBlock)(CGFloat newHeight);

@end

@implementation FLYTextView

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
    
    
    [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(self.textContainerInset.top);
        make.left.equalTo(self).with.offset(self.textContainerInset.left + self.textContainer.lineFragmentPadding);
        make.bottom.equalTo(self).with.offset(-self.textContainerInset.bottom);
        make.right.equalTo(self).with.offset(-(self.textContainerInset.right + self.textContainer.lineFragmentPadding));
    }];
    
        
    if( self.height != 0 && _originalHeight == 0 )
    {
        _originalHeight = self.height;
    }

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChangeNotification];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChangeNotification];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    //提示文字的font默认和内容的一样
    if ( self.placeholderFont == nil )
    {
        self.placeholderFont = font;
    }
}



#pragma mark - UI

- (void)initUI
{
    [self addSubview:self.placeholderLabel];
    
    //使用通知而不是代理，因为代理是一对一，如果外界重新绑定了代理，这里面的就会失效。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification) name:UITextViewTextDidChangeNotification object:self];
}



#pragma mark - Notification

- (void)textDidChangeNotification
{
    self.placeholderLabel.hidden = self.hasText;
    
    
    //回车键结束编辑
    if ( self.enterEndEditing )
    {
        [self setupEnterEndEditing];
    }
    
    
    //限制字数
    if( self.limitWordNumber > 0 )
    {
        [self setupLimitWordNumber];
    }
    
    
    //自动换行
    if ( _autoWrap )
    {
        [self setupAutoWrap];
    }
}



#pragma mark - public methods

/// 设置自动换行
/// @param maxHeight 最大高度（设置0为无高度限制）
/// @param heightChangeBlock 高度改变时的回调blcok
- (void)autoWrapWithMaxHeight:(CGFloat)maxHeight heightDidChange:(void(^)(CGFloat newHeight))heightChangeBlock
{
    _autoWrap = YES;
    _maxHeight = maxHeight == 0 ? CGFLOAT_MAX : maxHeight;
    self.heightChangeBlock = heightChangeBlock;
}



#pragma mark - private methods

/// 设置回车键结束编辑
- (void)setupEnterEndEditing
{
    //判断每一个字符，是否是回车字符，如果是，先去掉回车字符，在辞去第一相应
    for ( int i = 0; i < self.text.length; i++)
    {
        NSString * string = [self.text substringWithRange:NSMakeRange(i, 1)];
        if ( [string isEqualToString:@"\n"] )
        {
            //去掉回车字符
            self.text = [self.text stringByReplacingOccurrencesOfString:string withString:@""];
            //辞去第一相应
            [self resignFirstResponder];
        }
    }
}

/// 设置限制字数
- (void)setupLimitWordNumber
{
    if( self.text.length > self.limitWordNumber )
    {
        self.text = [self.text substringWithRange:NSMakeRange(0, self.limitWordNumber)];
    }
}

/// 设置自动换行
- (void)setupAutoWrap
{
    /*
     (top + 内容 + botton) <  原始高度   原始高度不变
     
     (top + 内容 + botton) >  原始高度   新高度就是(top + 内容 + botton)
     */
    
  
    
    //左右留白
    CGFloat horizontalPadding = self.textContainer.lineFragmentPadding * 2 + self.textContainerInset.left + self.textContainerInset.right;
    
    //上下留白
    CGFloat verticalPadding = self.textContainerInset.top + self.textContainerInset.bottom;
    
    //获取文本高度
    CGFloat height = [self heightForText:self.text font:self.font width:self.width - horizontalPadding];
    
    CGFloat newHeight = verticalPadding + height;
    
    if ( newHeight > _originalHeight )
    {
        self.height = newHeight > _maxHeight ? _maxHeight : newHeight;
    }
    else
    {
        self.height = _originalHeight;
    }

    //最新高度通过Block传给外界
    !self.heightChangeBlock ?: self.heightChangeBlock(self.height);
}

/// 获取文字高度
/// @param text 文字内容
/// @param font 字体
/// @param width 宽度
- (float)heightForText:(NSString *)text font:(UIFont *)font width:(float)width
{
    NSDictionary * attribute = @{ NSFontAttributeName: font };
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    //将一个float类型的小数去掉，然后进一，
    return ceilf(size.height);
}



#pragma mark - setters and getters

-(void)setLimitWordNumber:(NSUInteger)limitWordNumber
{
    _limitWordNumber = limitWordNumber;
    
    [self textDidChangeNotification];
}

-(void)setTextEdgeInset:(UIEdgeInsets)textEdgeInset
{
    _textEdgeInset = textEdgeInset;
    
    //左右的留白(默认5，左右各5)
    self.textContainer.lineFragmentPadding = 0;
    //设置边距 (默认 {8, 0, 8, 0} )
    self.textContainerInset = textEdgeInset;
    
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderLabel.text = placeholder;
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

-(void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderFont = placeholderFont;
    
    self.placeholderLabel.font = placeholderFont;
}

- (UILabel *)placeholderLabel
{
    if( _placeholderLabel == nil )
    {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _placeholderLabel;
}



@end
