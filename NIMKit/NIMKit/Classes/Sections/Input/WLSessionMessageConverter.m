//
//  WLSessionMessageConverter.m
//  will
//
//  Created by 敏 on 2020/5/25.
//  Copyright © 2020 maitang. All rights reserved.
//

#import "WLSessionMessageConverter.h"
#import "WLMessageFeedSendMsgAttachment.h"
#import "WLMessageSystemAttachment.h"
#import "WLMessageTruthOrDareAttachment.h"
#import "WLMessageEmotionAttachment.h"
#import "WLMessageGiftAttachment.h"
#import <NIMKit.h>
@implementation WLSessionMessageConverter
///文字消息
+ (NIMMessage *)messageWithText:(NSString *)text{
    NIMMessage *textMessage = [NIMMessage new];
    textMessage.text = text;
    return textMessage;
}
///图片消息
+ (NIMMessage *)messageWithImage:(UIImage *)image{
    
    NSString *dateString = [[WLDateFormatter wl_getDateFormatterFive] stringFromDate:[NSDate date]];
    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:image];
    imageObject.displayName = [NSString stringWithFormat:@"image send date:%@",dateString];
    NIMImageOption *option = [[NIMImageOption alloc] init];
    option.compressQuality = 1.0;
    imageObject.option = option;
    NIMMessage *message          = [[NIMMessage alloc] init];
    message.messageObject        = imageObject;
    message.apnsContent = [WLUIHelper UITextWithMsgImgMsgApnsContent];
    return message;
}
///语音消息
+ (NIMMessage *)messageWithAudio:(NSString *)filePath{
    NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:filePath];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = audioObject;
    message.apnsContent = [WLUIHelper UITextWithMsgAudioMsgApnsContent];
    return message;
    
}
///自定义礼物消息
+ (NIMMessage *)messageWithGiftAttachment:(WLMessageGiftAttachment *)attachment{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = [WLUIHelper UITextWithMsgGiftMsgApnsContent];
    return message;
}
///表情云消息
+ (NIMMessage *)messageWithBQMMAttachment:(WLMessageEmotionAttachment *)attachment apnsText:(NSString *)apnsText{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = apnsText;
    return message;
}
///911警告消息
+ (NIMMessage *)messageWithSystemNotifactionAttachment:(WLMessageSystemAttachment *)attachment{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = NO;
    setting.shouldBeCounted    = NO;
    message.setting            = setting;
    return message;
}
///动态发送消息
+ (NIMMessage *)messageWithDtSendMsgAttachment:(WLMessageFeedSendMsgAttachment *)attachment{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = [WLUIHelper UITextWithMsgFeedCommentMsgApnsContent];
    return message;
}
@end
