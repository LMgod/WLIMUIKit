//
//  NIMInputView.h
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMInputProtocol.h"
#import "NIMSessionConfig.h"
#import "WLInputToolBar.h"
#import "NIMInputAtCache.h"
#import "WLInputSendAudioContainerView.h"
@class NIMInputMoreContainerView;
@class NIMInputEmoticonContainerView;
@class NIMReplyContentView;



typedef NS_ENUM(NSInteger, NIMAudioRecordPhase) {
    AudioRecordPhaseStart,
    AudioRecordPhaseRecording,
    AudioRecordPhaseCancelling,
    AudioRecordPhaseEnd
};

typedef NS_ENUM(NSInteger, NIMCustomInputType) {
    NIMCustomInputTypeText       = 1,
    NIMCustomInputTypeEmotion   = 2,
    NIMCustomInputTypeAudio      = 3,
    NIMCustomInputTypeMedia      = 4,
    NIMCustomInputTypeGift       = 5,
    NIMCustomInputTypeTruth      = 6,
    NIMCustomInputTypeMore       = 7,
};

@protocol NIMInputDelegate <NSObject>

@optional

- (void)didChangeInputHeight:(CGFloat)inputHeight;

@end

@interface NIMInputView : UIView
@property (nonatomic, strong) NIMSession             *session;
@property (nonatomic, assign) NSInteger              maxTextLength;
@property (strong, nonatomic)  WLInputToolBar *toolBar;
@property (nonatomic, strong)  NIMReplyContentView *replyedContent;
@property (nonatomic, strong)  WLInputSendAudioContainerView *sendAudioContainerView;
//礼物视图
@property (nonatomic, strong) UIView *sendGiftContainerView;
//真心话大冒险
@property (nonatomic, strong) UIView *sendTruthContainerView;
@property (nonatomic, assign) NIMCustomInputType type;
@property (nonatomic, strong) NIMInputAtCache *atCache;

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<NIMSessionConfig>)config;

- (void)reset;
- (void)setInputDelegate:(id<NIMInputDelegate>)delegate;

//外部设置
- (void)setInputActionDelegate:(id<NIMInputActionDelegate>)actionDelegate;

- (void)setInputTextPlaceHolder:(NSString*)placeHolder;
- (void)updateVoicePower:(float)power;
- (void)addAtItems:(NSArray *)contacts;

- (void)refreshReplyedContent:(NIMMessage *)message;
- (void)dismissReplyedContent;

@end
