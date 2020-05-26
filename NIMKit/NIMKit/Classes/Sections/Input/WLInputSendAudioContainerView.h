//
//  WLInputSendAudioContainerView.h
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/25.
//

#import <UIKit/UIKit.h>
#import "NIMInputProtocol.h"
#import "NIMSessionConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface WLInputSendAudioContainerView : UIView
@property (assign, nonatomic, getter=isRecording) BOOL recording;
@property (nonatomic,weak)  id<NIMSessionConfig> config;
@property (nonatomic,weak)  id<NIMInputActionDelegate> actionDelegate;

- (void)updataRecordTime:(NSTimeInterval)time;
@end

NS_ASSUME_NONNULL_END
