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
    NIMCustomInputTypeeEmotion   = 2,
    NIMCustomInputTypeAudio      = 3,
    NIMCustomInputTypeMedia      = 4,
    NIMCustomInputTypeGift       = 5,
    NIMCustomInputTypeTruth      = 6,
};

@protocol NIMInputDelegate <NSObject>

@optional

- (void)didChangeInputHeight:(CGFloat)inputHeight;

@end

@interface NIMInputView : UIView
@property (nonatomic, strong) NIMSession             *session;
@property (nonatomic, assign) NSInteger              maxTextLength;
@property (assign, nonatomic, getter=isRecording)    BOOL recording;
@property (strong, nonatomic)  WLInputToolBar *toolBar;
@property (nonatomic, strong)   NIMReplyContentView *replyedContent;

@property (nonatomic, assign) NIMCustomInputType type;
@property (nonatomic, strong) NIMInputAtCache *atCache;

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<NIMSessionConfig>)config;

- (void)reset;
- (void)setInputDelegate:(id<NIMInputDelegate>)delegate;

//外部设置
- (void)setInputActionDelegate:(id<NIMInputActionDelegate>)actionDelegate;

- (void)setInputTextPlaceHolder:(NSString*)placeHolder;
- (void)updateAudioRecordTime:(NSTimeInterval)time;
- (void)updateVoicePower:(float)power;
- (void)addAtItems:(NSArray *)contacts;

- (void)refreshReplyedContent:(NIMMessage *)message;
- (void)dismissReplyedContent;

@end
