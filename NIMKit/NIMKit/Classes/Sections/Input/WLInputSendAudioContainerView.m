//
//  WLInputSendAudioContainerView.m
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/25.
//

#import "WLInputSendAudioContainerView.h"
#import "NIMInputAudioRecordIndicatorView.h"
#import "NIMInputView.h"
#import "NSString+NIMKit.h"
#import "UIColor+NIMKit.h"
#import "UIView+NIM.h"
#import "NIMGlobalMacro.h"
#import "NIMUITextHelper.h"
@interface WLInputSendAudioContainerView ()
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NIMInputAudioRecordIndicatorView *audioRecordIndicator;
@property (nonatomic, assign) NIMAudioRecordPhase recordPhase;
@end

@implementation WLInputSendAudioContainerView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _recording = NO;
        _recordPhase = AudioRecordPhaseEnd;
        [self setUI];
        [self setFrame];
    }
    return self;
}


- (void)setUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_sendButton];
    [_sendButton setImage:[UIImage imageNamed:@"WL_video_send_btn"] forState:UIControlStateNormal];
    [_sendButton setImage:[UIImage imageNamed:@"WL_video_send_btn_high"] forState:UIControlStateHighlighted];
    [_sendButton addTarget:self action:@selector(onTouchRecordBtnDown:) forControlEvents:UIControlEventTouchDown];
    [_sendButton addTarget:self action:@selector(onTouchRecordBtnUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton addTarget:self action:@selector(onTouchRecordBtnUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [_sendButton addTarget:self action:@selector(onTouchRecordBtnDragInside:) forControlEvents:UIControlEventTouchDragInside];
    [_sendButton addTarget:self action:@selector(onTouchRecordBtnDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
    
    self.alertLabel = [[UILabel alloc] init];
    [self addSubview:_alertLabel];
    _alertLabel.text = [NIMUITextHelper UITextMsgInputVoiceContainerAlert];
    
    _alertLabel.textColor = [UIColor colorWithHex:0x999999 alpha:1.0];
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    _alertLabel.font = [UIFont systemFontOfSize:15.0];
    
    
    self.lineView = [[UIView alloc] init];
    [self addSubview:_lineView];
    _lineView.backgroundColor = [UIColor colorWithHex:0xeeeeee alpha:1.0];
}

- (void)setFrame {
    
    self.lineView.frame = CGRectMake(0, 0, self.nim_width, 1);

    
    self.sendButton.nim_top = 50 * NIMKit_ScaleX;
    self.sendButton.nim_height = 110 * NIMKit_ScaleX;
    self.sendButton.nim_width = 110 * NIMKit_ScaleX;
    self.sendButton.nim_centerX = (self.nim_width * 0.5);
    
    self.alertLabel.nim_top = CGRectGetMaxY(self.sendButton.frame) + 13 * NIMKit_ScaleX;
    self.alertLabel.nim_height = 20 * NIMKit_ScaleX;
    self.alertLabel.nim_width = self.nim_width;
    self.alertLabel.nim_centerX = (self.nim_width * 0.5);

}

- (void)onTouchRecordBtnDown:(id)sender {
    self.recordPhase = AudioRecordPhaseStart;
    self.recording = YES;
}
- (void)onTouchRecordBtnUpInside:(id)sender {
    // finish Recording
    self.recordPhase = AudioRecordPhaseEnd;
}
- (void)onTouchRecordBtnUpOutside:(id)sender {
    //TODO cancel Recording
    self.recordPhase = AudioRecordPhaseEnd;
}

- (void)onTouchRecordBtnDragInside:(id)sender {
    //TODO @"手指上滑，取消发送"
    self.recordPhase = AudioRecordPhaseRecording;
}
- (void)onTouchRecordBtnDragOutside:(id)sender {
    //TODO @"松开手指，取消发送"
    self.recordPhase = AudioRecordPhaseCancelling;
}

- (void)setRecordPhase:(NIMAudioRecordPhase)recordPhase {
    NIMAudioRecordPhase lastPhase = _recordPhase;
    _recordPhase = recordPhase;
    self.audioRecordIndicator.phase = _recordPhase;
    if(lastPhase == AudioRecordPhaseEnd) {
        if(AudioRecordPhaseStart == _recordPhase) {
            if ([_actionDelegate respondsToSelector:@selector(onStartRecording)]) {
                [_actionDelegate onStartRecording];
            }
        }
    } else if (lastPhase == AudioRecordPhaseStart || lastPhase == AudioRecordPhaseRecording) {
        if (AudioRecordPhaseEnd == _recordPhase) {
            if ([_actionDelegate respondsToSelector:@selector(onStopRecording)]) {
                [_actionDelegate onStopRecording];
            }
            self.recording = NO;
        }
    } else if (lastPhase == AudioRecordPhaseCancelling) {
        if(AudioRecordPhaseEnd == _recordPhase) {
            if ([_actionDelegate respondsToSelector:@selector(onCancelRecording)]) {
                [_actionDelegate onCancelRecording];
            }
        }
    }
}

- (void)setRecording:(BOOL)recording {
    if(recording) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.audioRecordIndicator];
        _audioRecordIndicator.center = CGPointMake(NIMKit_UIScreenWidth/2.0, NIMKit_UIScreenHeight/2.0);
        self.recordPhase = AudioRecordPhaseRecording;
    } else {
        [self.audioRecordIndicator removeFromSuperview];
        self.recordPhase = AudioRecordPhaseEnd;
    }
    _recording = recording;
}

- (void)setConfig:(id<NIMSessionConfig>)config
{
    _config = config;
}

- (void)updataRecordTime:(NSTimeInterval)time {
    
    self.audioRecordIndicator.recordTime = time;
    
}

- (NIMInputAudioRecordIndicatorView *)audioRecordIndicator {
    if(!_audioRecordIndicator) {
        _audioRecordIndicator = [[NIMInputAudioRecordIndicatorView alloc] init];
    }
    return _audioRecordIndicator;
}

@end
