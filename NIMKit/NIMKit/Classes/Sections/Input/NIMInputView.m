//
//  NIMInputView.m
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMInputView.h"
#import <AVFoundation/AVFoundation.h>
#import "NIMInputMoreContainerView.h"
#import "NIMInputEmoticonContainerView.h"
#import "NIMInputAudioRecordIndicatorView.h"
#import "UIView+NIM.h"
#import "NIMInputEmoticonDefine.h"
#import "NIMInputEmoticonManager.h"
#import "NIMInputToolBar.h"
#import "UIImage+NIMKit.h"
#import "NIMGlobalMacro.h"
#import "NIMContactSelectViewController.h"
#import "NIMKit.h"
#import "NIMKitInfoFetchOption.h"
#import "NIMKitKeyboardInfo.h"
#import "NSString+NIMKit.h"
#import "NIMReplyContentView.h"
#import "M80AttributedLabel+NIMKit.h"
#import "WLInputSendAudioContainerView.h"
#import "WLInputSendGiftContainerView.h"
#import "WLInputSendTruthContainerView.h"
#import "NIMUIConfig.h"
#import <DongtuStoreSDK/DongtuStoreSDK.h>
@interface NIMInputView()<WLInputToolBarDelegate,NIMInputEmoticonProtocol,NIMContactSelectDelegate,NIMReplyContentViewDelegate,DongtuStoreDelegate>
{
    UIView  *_emoticonView;
}
@property (nonatomic, assign) NIMAudioRecordPhase recordPhase;
@property (nonatomic, weak) id<NIMSessionConfig> inputConfig;
@property (nonatomic, weak) id<NIMInputDelegate> inputDelegate;
@property (nonatomic, weak) id<NIMInputActionDelegate> actionDelegate;

@property (nonatomic, assign) CGFloat keyBoardFrameTop; //键盘的frame的top值，屏幕高度 - 键盘高度，由于有旋转的可能，这个值只有当 键盘弹出时才有意义。
@property (nonatomic, strong) NIMInputMoreContainerView *moreContainerView;
@property (nonatomic, strong) WLInputSendAudioContainerView *sendAudioContainerView;
@property (nonatomic, strong) WLInputSendGiftContainerView *sendGiftContainerView;
@property (nonatomic, strong) WLInputSendTruthContainerView *sendTruthContainerView;

@end


@implementation NIMInputView
- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<NIMSessionConfig>)config
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _recording = NO;
        _recordPhase = AudioRecordPhaseEnd;
        _atCache = [[NIMInputAtCache alloc] init];
        _inputConfig = config;
        self.moreContainerView.config = config;
        self.backgroundColor = [UIColor whiteColor];
        [self configDongtuTheme];
    }
    return self;
}

- (void)didMoveToWindow
{
    [self setup];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    //这里不做.语法 get 操作，会提前初始化组件导致卡顿
    CGFloat replyedContentHeight = _replyedContent.hidden ? 0 : _replyedContent.nim_height;
    CGFloat toolBarHeight = _toolBar.nim_height;
    CGFloat containerHeight = 0;
    switch (self.type)
    {
        case NIMCustomInputTypeEmotion:
        case NIMCustomInputTypeAudio:
        case NIMCustomInputTypeMedia:
        case NIMCustomInputTypeGift:
        case NIMCustomInputTypeTruth:
        case NIMCustomInputTypeMore:
        {
            containerHeight = [NIMUIConfig bottomInputViewHeight];
            break;
        }
        default:
        {
            UIEdgeInsets safeArea = UIEdgeInsetsZero;
            if (@available(iOS 11.0, *))
            {
                safeArea = self.superview.safeAreaInsets;
            }
            //键盘是从最底下弹起的，需要减去安全区域底部的高度
            CGFloat keyboardDelta = [NIMKitKeyboardInfo instance].keyboardHeight - safeArea.bottom;
            
            //如果键盘还没有安全区域高，容器的初始值为0；否则则为键盘和安全区域的高度差值，这样可以保证 toolBar 始终在键盘上面
            containerHeight = keyboardDelta>0 ? keyboardDelta : 0;
        }
           break;
    }
    CGFloat height = replyedContentHeight + toolBarHeight + containerHeight;
    CGFloat width = self.superview? self.superview.nim_width : self.nim_width;
    return CGSizeMake(width, height);
}

- (void)configDongtuTheme{
    NSLog(@"[DongtuStoreSDK] version:%@",[DongtuStore sharedInstance].version);
    [DongtuStore sharedInstance].delegate = self;

    
    
}


- (void)setInputDelegate:(id<NIMInputDelegate>)delegate
{
    _inputDelegate = delegate;
}

- (void)setInputActionDelegate:(id<NIMInputActionDelegate>)actionDelegate
{
    _actionDelegate = actionDelegate;
    self.moreContainerView.actionDelegate = actionDelegate;
}

- (void)reset
{
    self.nim_width = self.superview.nim_width;
    self.type = NIMCustomInputTypeText;
    [self sizeToFit];
}



- (void)setRecordPhase:(NIMAudioRecordPhase)recordPhase {
    NIMAudioRecordPhase prevPhase = _recordPhase;
    _recordPhase = recordPhase;
    if(prevPhase == AudioRecordPhaseEnd) {
        if(AudioRecordPhaseStart == _recordPhase) {
            if ([_actionDelegate respondsToSelector:@selector(onStartRecording)]) {
                [_actionDelegate onStartRecording];
            }
        }
    } else if (prevPhase == AudioRecordPhaseStart || prevPhase == AudioRecordPhaseRecording) {
        if (AudioRecordPhaseEnd == _recordPhase) {
            if ([_actionDelegate respondsToSelector:@selector(onStopRecording)]) {
                [_actionDelegate onStopRecording];
            }
        }
    } else if (prevPhase == AudioRecordPhaseCancelling) {
        if(AudioRecordPhaseEnd == _recordPhase) {
            if ([_actionDelegate respondsToSelector:@selector(onCancelRecording)]) {
                [_actionDelegate onCancelRecording];
            }
        }
    }
}

- (void)setup
{
    if (!_toolBar)
    {
        _toolBar = [[WLInputToolBar alloc] initWithFrame:CGRectMake(0, 0, self.nim_width, 0)];
        __weak typeof(self) weakSelf = self;
        _toolBar.clickToolBarItemBlock = ^(NSInteger event) {
            [weakSelf clickToolBarEvent:event];
        };
    }
    [self addSubview:_toolBar];
   

    _toolBar.delegate = self;
    _toolBar.nim_size = [_toolBar sizeThatFits:CGSizeMake(self.nim_width, CGFLOAT_MAX)];
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    //设置最大输入字数
    NSInteger textInputLength = [NIMKit sharedKit].config.inputMaxLength;
    self.maxTextLength = textInputLength;
    self.type = NIMCustomInputTypeText;
    [self sizeToFit];
}

- (void)setRecording:(BOOL)recording
{
    if(recording)
    {
       
        self.recordPhase = AudioRecordPhaseRecording;
    }
    else
    {
        self.recordPhase = AudioRecordPhaseEnd;
    }
    _recording = recording;
}

- (void)clickToolBarEvent:(NSInteger)event{
    switch (event) {
        case 0:
        {
            self.type = NIMCustomInputTypeEmotion;
        }
            break;
        case 1:
        {
            self.type = NIMCustomInputTypeAudio;
        }
            break;
        case 2:
        {
            self.type = NIMCustomInputTypeGift;
        }
            break;
        case 3:
        {
            self.type = NIMCustomInputTypeTruth;
        }
            break;
        case 4:
        {
            self.type = NIMCustomInputTypeMore;
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 外部接口


- (void)updateAudioRecordTime:(NSTimeInterval)time {
    
}

- (void)updateVoicePower:(float)power {
    
}

- (void)refreshReplyedContent:(NIMMessage *)message
{
    NSString *text = [NSString stringWithFormat:@"%@", [[NIMKit sharedKit] replyedContentWithMessage:message]];
    [self.replyedContent.label nim_setText:text];

    self.replyedContent.hidden = NO;
    [self.replyedContent setNeedsLayout];
}

- (void)dismissReplyedContent
{
    self.replyedContent.label.text = nil;
    self.replyedContent.hidden = YES;
    [self setNeedsLayout];
}

#pragma mark - private methods

- (void)setFrame:(CGRect)frame
{
    CGFloat height = self.frame.size.height;
    [super setFrame:frame];
    if (frame.size.height != height)
    {
        [self callDidChangeHeight];
    }
}

- (void)callDidChangeHeight
{
    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(didChangeInputHeight:)])
    {
        if (self.type == NIMCustomInputTypeEmotion ||
            self.type == NIMCustomInputTypeAudio ||
            self.type == NIMCustomInputTypeMedia ||
            self.type == NIMCustomInputTypeGift ||
            self.type == NIMCustomInputTypeTruth)
        {
            //这个时候需要一个动画来模拟键盘
            [UIView animateWithDuration:0.25 delay:0 options:7 animations:^{
                [_inputDelegate didChangeInputHeight:self.nim_height];
            } completion:nil];
        }
        else
        {
            [_inputDelegate didChangeInputHeight:self.nim_height];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //这里不做.语法 get 操作，会提前初始化组件导致卡顿
    if (!_replyedContent.hidden)
    {
        self.toolBar.nim_top = _replyedContent.nim_bottom;
    }
    else
    {
        self.toolBar.nim_top = 0.f;
    }
}

- (NIMReplyContentView *)replyedContent
{
    if (!_replyedContent)
    {
        _replyedContent = [[NIMReplyContentView alloc] initWithFrame:CGRectMake(0, 0, self.nim_width, 35)];
        _replyedContent.hidden = YES;
        _replyedContent.delegate = self;
        [self addSubview:_replyedContent];
    }
    return _replyedContent;
}

- (void)setType:(NIMCustomInputType)type {
    if (_type == type) {
        return;
    }
    _type = type;
    [self sizeToFit];
    switch (type) {
        case NIMCustomInputTypeEmotion:
            {
                [self.toolBar.inputTextView becomeFirstResponder];
                self.sendAudioContainerView.hidden = YES;
                self.sendTruthContainerView.hidden = YES;
                self.sendGiftContainerView.hidden = YES;
                self.moreContainerView.hidden = YES;
                [[DongtuStore sharedInstance] attachEmotionKeyboardToInput:_toolBar.inputTextView.textView];
               
            }
            break;
        case NIMCustomInputTypeAudio:
        {
            self.sendAudioContainerView.hidden = NO;
            self.sendTruthContainerView.hidden = YES;
            self.sendGiftContainerView.hidden = YES;
            self.moreContainerView.hidden = YES;
            [self bringSubviewToFront:self.sendAudioContainerView];
        }
        break;
        case NIMCustomInputTypeGift:
        {
            self.sendAudioContainerView.hidden = YES;
            self.sendTruthContainerView.hidden = YES;
            self.sendGiftContainerView.hidden = NO;
            self.moreContainerView.hidden = YES;
            [self bringSubviewToFront:self.sendGiftContainerView];
        }
        break;
        case NIMCustomInputTypeTruth:
        {
            self.sendAudioContainerView.hidden = YES;
            self.sendTruthContainerView.hidden = NO;
            self.sendGiftContainerView.hidden = YES;
            self.moreContainerView.hidden = YES;
            [self bringSubviewToFront:self.sendTruthContainerView];
        }
        break;
        case NIMCustomInputTypeText:
        {
            self.sendAudioContainerView.hidden = YES;
            self.sendTruthContainerView.hidden = YES;
            self.sendGiftContainerView.hidden = YES;
            self.moreContainerView.hidden = YES;
        }
        break;
        case NIMCustomInputTypeMore:
        {
            self.sendAudioContainerView.hidden = YES;
            self.sendTruthContainerView.hidden = YES;
            self.sendGiftContainerView.hidden = YES;
            self.moreContainerView.hidden = NO;
        }
        break;
        default:
            break;
    }
}

#pragma mark - button actions
- (void)onTouchVoiceBtn:(id)sender {
    
}

- (IBAction)onTouchRecordBtnDown:(id)sender {
    self.recordPhase = AudioRecordPhaseStart;
}
- (IBAction)onTouchRecordBtnUpInside:(id)sender {
    // finish Recording
    self.recordPhase = AudioRecordPhaseEnd;
}
- (IBAction)onTouchRecordBtnUpOutside:(id)sender {
    // cancel Recording
    self.recordPhase = AudioRecordPhaseEnd;
}

- (IBAction)onTouchRecordBtnDragInside:(id)sender {
    // "手指上滑，取消发送"
    self.recordPhase = AudioRecordPhaseRecording;
}
- (IBAction)onTouchRecordBtnDragOutside:(id)sender {
    // "松开手指，取消发送"
    self.recordPhase = AudioRecordPhaseCancelling;
}


- (void)onTouchEmoticonBtn:(id)sender
{
    
}

- (void)onTouchMoreBtn:(id)sender {
    
}

- (BOOL)endEditing:(BOOL)force
{
    BOOL endEditing = [super endEditing:force];
    if (!self.toolBar.showsKeyboard) {
        UIViewAnimationCurve curve = UIViewAnimationCurveEaseInOut;
        void(^animations)(void) = ^{
            self.type = NIMCustomInputTypeText;
            [self sizeToFit];
            if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(didChangeInputHeight:)]) {
                [self.inputDelegate didChangeInputHeight:self.nim_height];
            }
        };
        NSTimeInterval duration = 0.25;
        [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
    }
    return endEditing;
}


#pragma mark - NIMInputToolBarDelegate

- (BOOL)textViewShouldBeginEditing
{
    self.type = NIMCustomInputTypeText;
    return YES;
}

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self didPressSend:nil];
        return NO;
    }
    if ([text isEqualToString:@""] && range.length == 1 )
    {
        //非选择删除
        return [self onTextDelete];
    }
    if ([self shouldCheckAt])
    {
        // @ 功能
        [self checkAt:text];
    }
    NSString *str = [self.toolBar.contentText stringByAppendingString:text];
    if (str.length > self.maxTextLength)
    {
        return NO;
    }
    return YES;
}

- (BOOL)shouldCheckAt
{
    BOOL disable = NO;
    if ([self.inputConfig respondsToSelector:@selector(disableAt)])
    {
        disable = [self.inputConfig disableAt];
    }
    return !disable;
}

- (void)checkAt:(NSString *)text
{
    if ([text isEqualToString:NIMInputAtStartChar]) {
        switch (self.session.sessionType)
        {
            case NIMSessionTypeTeam:
            {
                NIMContactTeamMemberSelectConfig *config = [[NIMContactTeamMemberSelectConfig alloc] init];
                config.teamType = NIMKitTeamTypeNomal;
                config.needMutiSelected = NO;
                config.teamId = self.session.sessionId;
                config.session = self.session;
                config.filterIds = @[[NIMSDK sharedSDK].loginManager.currentAccount];
                NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
                vc.delegate = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [vc show];
                });
            }
                break;
            case NIMSessionTypeSuperTeam:
            {
                NIMContactTeamMemberSelectConfig *config = [[NIMContactTeamMemberSelectConfig alloc] init];
                config.teamType = NIMKitTeamTypeSuper;
                config.needMutiSelected = NO;
                config.teamId = self.session.sessionId;
                config.session = self.session;
                config.filterIds = @[[NIMSDK sharedSDK].loginManager.currentAccount];
                NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
                vc.delegate = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [vc show];
                });
            }
                break;
            case NIMSessionTypeP2P:
                break;
            case NIMSessionTypeChatroom:
                break;
            default:
                break;
        }
    }
}


- (void)textViewDidChange
{
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onTextChanged:)])
    {
        [self.actionDelegate onTextChanged:self];
    }
}


- (void)toolBarDidChangeHeight:(CGFloat)height
{
    [self sizeToFit];
}

- (void)addAtItems:(NSArray *)selectedContacts
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"@"];
    [self addContacts:selectedContacts prefix:str];
}

#pragma mark - NIMContactSelectDelegate
- (void)didFinishedSelect:(NSArray *)selectedContacts
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
    [self addContacts:selectedContacts prefix:str];
}

- (void)addContacts:(NSArray *)selectedContacts prefix:(NSMutableString *)str
{
    NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
    option.session = self.session;
    option.forbidaAlias = YES;
    for (NSString *uid in selectedContacts) {
        NSString *nick = [[NIMKit sharedKit].provider infoByUser:uid option:option].showName;
        [str appendString:nick];
        [str appendString:NIMInputAtEndChar];
        if (![selectedContacts.lastObject isEqualToString:uid]) {
            [str appendString:NIMInputAtStartChar];
        }
        NIMInputAtItem *item = [[NIMInputAtItem alloc] init];
        item.uid  = uid;
        item.name = nick;
        [self.atCache addAtItem:item];
    }
    [self.toolBar insertText:str];
}

#pragma mark - InputEmoticonProtocol
- (void)selectedEmoticon:(NSString*)emoticonID catalog:(NSString*)emotCatalogID description:(NSString *)description{
    if (!emotCatalogID) { //删除键
        [self doButtonDeleteText];
    }else{
        if ([emotCatalogID isEqualToString:NIMKit_EmojiCatalog]) {
            [self.toolBar insertText:description];
        }else{
            //发送贴图消息
            if ([self.actionDelegate respondsToSelector:@selector(onSelectChartlet:catalog:)]) {
                [self.actionDelegate onSelectChartlet:emoticonID catalog:emotCatalogID];
            }
        }
    }
}

- (void)didPressSend:(id)sender{
    if ([self.actionDelegate respondsToSelector:@selector(onSendText:atUsers:)] && [self.toolBar.contentText length] > 0) {
        NSString *sendText = self.toolBar.contentText;
        [self.actionDelegate onSendText:sendText atUsers:[self.atCache allAtUid:sendText]];
        [self.atCache clean];
        self.toolBar.contentText = @"";
        [self.toolBar layoutIfNeeded];
    }
}



- (BOOL)onTextDelete
{
    NSRange range = [self delRangeForEmoticon];
    if (range.length == 1)
    {
        //删的不是表情，可能是@
        NIMInputAtItem *item = [self delRangeForAt];
        if (item) {
            range = item.range;
        }
    }
    if (range.length == 1) {
        //自动删除
        return YES;
    }
    [self.toolBar deleteText:range];
    return NO;
}

- (BOOL)doButtonDeleteText
{
    NSRange range = [self delRangeForLastComponent];
    if (range.length == 1)
    {
        //删的不是表情，可能是@
        NIMInputAtItem *item = [self delRangeForAt];
        if (item) {
            range = item.range;
        }
    }
    
    [self.toolBar deleteText:range];
    return NO;
}


- (NSRange)delRangeForEmoticon
{
    NSString *text = self.toolBar.contentText;
    NSRange selectedRange = [self.toolBar selectedRange];
    BOOL isEmoji = NO;
    if (selectedRange.location >= 2) {
        NSString *subStr = [text substringWithRange:NSMakeRange(selectedRange.location - 2, 2)];
        isEmoji = [subStr nim_containsEmoji];
    }
    
    NSRange range = NSMakeRange(selectedRange.location - 1, 1);
    if (isEmoji) {
        range = NSMakeRange(selectedRange.location-2, 2);
    } else {
        NSRange subRange = [self rangeForPrefix:@"[" suffix:@"]"];
        if (subRange.length > 1)
        {
            NSString *name = [text substringWithRange:subRange];
            NIMInputEmoticon *icon = [[NIMInputEmoticonManager sharedManager] emoticonByTag:name];
            range = icon? subRange : NSMakeRange(selectedRange.location - 1, 1);
        }
    }

    return range;
}

- (NSRange)delRangeForLastComponent
{
    NSString *text = self.toolBar.contentText;
    NSRange selectedRange = [self.toolBar selectedRange];
    if (selectedRange.location == 0)
    {
        return NSMakeRange(0, 0) ;
    }
    
    NSRange range = NSMakeRange(0, 0);
    NSRange subRange = [self rangeForPrefix:@"[" suffix:@"]"];
    
    if (text.length > 0 &&
        [[text substringFromIndex:text.length - 1] isEqualToString:@"]"] &&
        subRange.length > 1)
    {
        NSString *name = [text substringWithRange:subRange];
        NIMInputEmoticon *icon = [[NIMInputEmoticonManager sharedManager] emoticonByTag:name];
        range = icon? subRange : NSMakeRange(selectedRange.location - 1, 1);
    }
    else
    {
        range = [text nim_rangeOfLastUnicode];
    }

    return range;
}


- (NIMInputAtItem *)delRangeForAt
{
    NSString *text = self.toolBar.contentText;
    NSRange range = [self rangeForPrefix:NIMInputAtStartChar suffix:NIMInputAtEndChar];
    NSRange selectedRange = [self.toolBar selectedRange];
    NIMInputAtItem *item = nil;
    if (range.length > 1)
    {
        NSString *name = [text substringWithRange:range];
        NSString *set = [NIMInputAtStartChar stringByAppendingString:NIMInputAtEndChar];
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:set]];
        item = [self.atCache item:name];
        range = item? range : NSMakeRange(selectedRange.location - 1, 1);
    }
    item.range = range;
    return item;
}


- (NSRange)rangeForPrefix:(NSString *)prefix suffix:(NSString *)suffix
{
    NSString *text = self.toolBar.contentText;
    NSRange range = [self.toolBar selectedRange];
    NSString *selectedText = range.length ? [text substringWithRange:range] : text;
    NSInteger endLocation = range.location;
    if (endLocation <= 0)
    {
        return NSMakeRange(NSNotFound, 0);
    }
    NSInteger index = -1;
    if ([selectedText hasSuffix:suffix]) {
        //往前搜最多20个字符，一般来讲是够了...
        NSInteger p = 20;
        for (NSInteger i = endLocation; i >= endLocation - p && i-1 >= 0 ; i--)
        {
            NSRange subRange = NSMakeRange(i - 1, 1);
            NSString *subString = [text substringWithRange:subRange];
            if ([subString compare:prefix] == NSOrderedSame)
            {
                index = i - 1;
                break;
            }
        }
    }
    return index == -1? NSMakeRange(endLocation - 1, 1) : NSMakeRange(index, endLocation - index);
}

#pragma mark - NIMReplyContentViewDelegate

- (void)onClearReplyContent:(id)sender
{
    [self setNeedsLayout];
    self.toolBar.inputTextView.text = nil;
    if ([self.actionDelegate respondsToSelector:@selector(didReplyCancelled)])
    {
        [self.actionDelegate didReplyCancelled];
    }
}

#pragma mark - <DongtuStoreDelegate>😄
- (void)didSelectGif:(nonnull DTGif *)gif{
    if ([self.actionDelegate respondsToSelector:@selector(didSelectGif:)]) {
        [self.actionDelegate didSendGif:gif];
    }
}
- (void)didSelectEmoji:(nonnull DTEmoji *)emoji{
    if ([self.actionDelegate respondsToSelector:@selector(didSendEmoji:)]) {
        [self.actionDelegate didSendEmoji:emoji];
    }
}

- (void)didSendWithInput:(nonnull UIResponder<UITextInput> *)input{
    if ([self.actionDelegate respondsToSelector:@selector(didSendWithInput:)]) {
        [self.actionDelegate didSendWithInput:input];
    }
}

- (void)tapOverlay{
    
    
}
#pragma mark - setter、getter
- (WLInputSendAudioContainerView *)sendAudioContainerView {
    if (!_sendAudioContainerView) {
        _sendAudioContainerView = [[WLInputSendAudioContainerView alloc] initWithFrame:CGRectMake(0, [NIMUIConfig topInputViewHeight], self.nim_width, [NIMUIConfig bottomInputViewHeight])];
        _sendAudioContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _sendAudioContainerView.hidden = YES;
        [self addSubview:_sendAudioContainerView];
    }
    return _sendAudioContainerView;
}

- (WLInputSendGiftContainerView *)sendGiftContainerView {
    if (!_sendGiftContainerView) {
        _sendGiftContainerView = [[WLInputSendGiftContainerView alloc] initWithFrame:CGRectMake(0, [NIMUIConfig topInputViewHeight], self.nim_width, [NIMUIConfig bottomInputViewHeight])];
        _sendGiftContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _sendGiftContainerView.hidden = YES;
        [self addSubview:_sendGiftContainerView];
    }
    return _sendGiftContainerView;
}

- (WLInputSendTruthContainerView *)sendTruthContainerView {
    if (!_sendTruthContainerView) {
        _sendTruthContainerView = [[WLInputSendTruthContainerView alloc] initWithFrame:CGRectMake(0, [NIMUIConfig topInputViewHeight], self.nim_width, [NIMUIConfig bottomInputViewHeight])];
        _sendTruthContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _sendTruthContainerView.hidden = YES;
        [self addSubview:_sendTruthContainerView];
    }
    return _sendTruthContainerView;
}

- (NIMInputMoreContainerView *)moreContainerView {
    if (!_moreContainerView) {
        _moreContainerView = [[NIMInputMoreContainerView alloc] initWithFrame:CGRectZero];
        _moreContainerView.nim_size = [_moreContainerView sizeThatFits:CGSizeMake(self.nim_width, CGFLOAT_MAX)];
        _moreContainerView.nim_top = [NIMUIConfig topInputViewHeight];
        _moreContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _moreContainerView.hidden = YES;
        
        
        [self addSubview:_moreContainerView];
    }
    return _moreContainerView;
}



@end
