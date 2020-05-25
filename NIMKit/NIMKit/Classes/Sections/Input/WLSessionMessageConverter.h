//
//  WLSessionMessageConverter.h
//  will
//
//  Created by 敏 on 2020/5/25.
//  Copyright © 2020 maitang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class NIMMessage;
@class WLMessageGiftAttachment;
@class WLMessageEmotionAttachment;
@class WLMessageSystemAttachment;
@class WLMessageFeedSendMsgAttachment;
@interface WLSessionMessageConverter : NSObject

///文字消息
+ (NIMMessage *)messageWithText:(NSString *)text;
///图片消息
+ (NIMMessage *)messageWithImage:(UIImage *)image;
///语音消息
+ (NIMMessage *)messageWithAudio:(NSString *)filePath;
///自定义礼物消息
+ (NIMMessage *)messageWithGiftAttachment:(WLMessageGiftAttachment *)attachment;
///表情云消息
+ (NIMMessage *)messageWithBQMMAttachment:(WLMessageEmotionAttachment *)attachment apnsText:(NSString *)apnsText;
///911警告消息
+ (NIMMessage *)messageWithSystemNotifactionAttachment:(WLMessageSystemAttachment *)attachment;
///动态发送消息
+ (NIMMessage *)messageWithDtSendMsgAttachment:(WLMessageFeedSendMsgAttachment *)attachment;


@end

NS_ASSUME_NONNULL_END
