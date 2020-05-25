//
//  WLInputToolBar.m
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/24.
//

#import "WLInputToolBar.h"
#import "NIMGlobalMacro.h"
#import "UIView+NIM.h"
#import "NIMUIConfig.h"
@interface WLInputToolBar ()<NIMGrowingTextViewDelegate>

@property (nonatomic, strong) UIView *btnContentView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemsArray;
@end

@implementation WLInputToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    NSArray *imageArr = [self imageNameArray];
    [self insertSubview:self.btnContentView atIndex:0];
    [imageArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *normalName = [NSString stringWithFormat:@"%@nor",obj];
        NSString *selectName = [NSString stringWithFormat:@"%@sel",obj];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1200 + idx;
        [btn setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectName] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemsArray addObject:btn];
        [self addSubview:btn];
        CGFloat btnWidth = 52 * NIMKit_ScaleX;
        CGFloat itemWith = NIMKit_UIScreenWidth/imageArr.count;
        CGFloat leftMagin = (itemWith - btnWidth)/2;

        btn.nim_width = btnWidth;
        btn.nim_height = btnWidth;
        btn.nim_left = (leftMagin + itemWith * idx);
        btn.nim_top = [NIMUIConfig inputTextViewHeight] + 5 * NIMKit_ScaleX;
        if (idx == 0) {
            self.btnContentView.nim_left = 0;
            self.btnContentView.nim_width = self.nim_width;
            self.btnContentView.nim_top = btn.nim_top;
            self.btnContentView.nim_height = btn.nim_height;
        }
    }];
    [self addSubview:self.inputTextView];
    self.inputTextView.nim_left = 16 * NIMKit_ScaleX;
    self.inputTextView.nim_width = self.nim_width - 32 * NIMKit_ScaleX;
    self.inputTextView.nim_top = 5 * NIMKit_ScaleX;
    self.inputTextView.nim_height = [NIMUIConfig inputTextViewHeight];
    
}

- (void)itemClick:(UIButton *)sender{
    NSInteger index = sender.tag - 1200;
    
    
}

- (BOOL)showsKeyboard
{
    return [self.inputTextView isFirstResponder];
}

- (void)setShowsKeyboard:(BOOL)showsKeyboard
{
    if (showsKeyboard)
    {
        [self.inputTextView becomeFirstResponder];
    }
    else
    {
        [self.inputTextView resignFirstResponder];
    }
}

- (NSString *)contentText
{
    return self.inputTextView.text;
}

- (void)setContentText:(NSString *)contentText
{
    self.inputTextView.text = contentText;
}


- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat viewHeight = [NIMUIConfig topInputViewHeight];
    // TextView 自适应高度
    [self.inputTextView layoutIfNeeded];
    CGFloat inputHeight = (int)self.inputTextView.frame.size.height;
    //得到 ToolBar 自身高度
    inputHeight = MAX(inputHeight, [NIMUIConfig inputTextViewHeight]);
    viewHeight = viewHeight + inputHeight - [NIMUIConfig inputTextViewHeight];
    return CGSizeMake(size.width,viewHeight);
}





#pragma mark - <NIMGrowingTextViewDelegate>
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText
{
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
        should = [self.delegate shouldChangeTextInRange:range replacementText:replacementText];
    }
    return should;
}


- (BOOL)textViewShouldBeginEditing:(NIMGrowingTextView *)growingTextView
{
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing)]) {
        should = [self.delegate textViewShouldBeginEditing];
    }
    return should;
}

- (void)textViewDidEndEditing:(NIMGrowingTextView *)growingTextView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing)]) {
        [self.delegate textViewDidEndEditing];
    }
}


- (void)textViewDidChange:(NIMGrowingTextView *)growingTextView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidChange)]) {
        [self.delegate textViewDidChange];
    }
}

- (void)willChangeHeight:(CGFloat)height
{
//    CGFloat toolBarHeight = height + 2 * self.spacing;
//    if ([self.delegate respondsToSelector:@selector(toolBarWillChangeHeight:)]) {
//        [self.delegate toolBarWillChangeHeight:toolBarHeight];
//    }
}

- (void)didChangeHeight:(CGFloat)height
{
//    self.nim_height = height + 2 * self.spacing + 2 * self.textViewPadding;
//    if ([self.delegate respondsToSelector:@selector(toolBarDidChangeHeight:)]) {
//        [self.delegate toolBarDidChangeHeight:self.nim_height];
//    }
}


#pragma mark - setter、getter

- (NSArray<NSString *> *)imageNameArray{
    return @[@"WL_inputBar_emj_",
             @"WL_inputBar_voice_",
             @"WL_inputBar_gift_",
             @"WL_inputBar_truth_",
             @"WL_inputBar_more_" ];
}

- (NSMutableArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (UIView *)btnContentView {
    if (!_btnContentView) {
        _btnContentView = [[UIView alloc] init];
        _btnContentView.backgroundColor = UIColor.whiteColor;
    }
    return _btnContentView;
}

- (NIMGrowingTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[NIMGrowingTextView alloc] initWithFrame:CGRectZero];
        _inputTextView.font = [UIFont systemFontOfSize:14.0f];
        _inputTextView.maxNumberOfLines = 4;
        _inputTextView.minNumberOfLines = 1;
        _inputTextView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:@"想和Ta说点什么？".nim_localized attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],NSForegroundColorAttributeName : UIColor.lightGrayColor}];
        _inputTextView.textColor = [UIColor blackColor];
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.nim_size = [_inputTextView intrinsicContentSize];
        _inputTextView.textViewDelegate = self;
        _inputTextView.returnKeyType = UIReturnKeySend;
    }
    return _inputTextView;
}
@end

@implementation WLInputToolBar(InputText)

- (NSRange)selectedRange
{
    return self.inputTextView.selectedRange;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    self.inputTextView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
}

- (void)insertText:(NSString *)text
{
    NSRange range = self.inputTextView.selectedRange;
    NSString *replaceText = [self.inputTextView.text stringByReplacingCharactersInRange:range withString:text];
    range = NSMakeRange(range.location + text.length, 0);
    self.inputTextView.text = replaceText;
    self.inputTextView.selectedRange = range;
}

- (void)deleteText:(NSRange)range
{
    NSString *text = self.contentText;
    if (range.location + range.length <= [text length]
        && range.location != NSNotFound && range.length != 0)
    {
        NSString *newText = [text stringByReplacingCharactersInRange:range withString:@""];
        NSRange newSelectRange = NSMakeRange(range.location, 0);
        [self.inputTextView setText:newText];
        self.inputTextView.selectedRange = newSelectRange;
    }
}

@end
