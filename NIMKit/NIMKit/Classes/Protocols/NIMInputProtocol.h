//
//  NIMInputProtocol.h
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NIMMediaItem;
@class DTGif;
@class DTEmoji;
@protocol NIMInputActionDelegate <NSObject>

@optional
- (BOOL)onTapMediaItem:(NIMMediaItem *)item;

- (void)onTextChanged:(id)sender;

- (void)onSendText:(NSString *)text
           atUsers:(NSArray *)atUsers;

- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId;

- (void)onSelectEmoticon:(id)emoticon;

- (void)onCancelRecording;

- (void)onStopRecording;

- (void)onStartRecording;

- (void)onTapMoreBtn:(id)sender;

- (void)onTapEmoticonBtn:(id)sender;

- (void)onTapVoiceBtn:(id)sender;

- (void)didReplyCancelled;
//动图
- (void)didSendGif:(nonnull DTGif *)gif;
- (void)didSendEmoji:(nonnull DTEmoji *)emoji;
- (void)didSendWithInput:(nonnull UIResponder<UITextInput> *)input;

@end

