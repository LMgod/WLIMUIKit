//
//  WLMessageSessionConfig.m
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/25.
//

#import "WLMessageSessionConfig.h"
#import "NSString+NIMKit.h"
@implementation WLMessageSessionConfig

/**
 *  可以显示在点击输入框“+”按钮之后的多媒体按钮
 */
- (NSArray<NIMMediaItem *> *)mediaItems {
    NIMMediaItem *cameraItem = [NIMMediaItem item:@"onTapMediaItemShoot:"
                                      normalImage:[UIImage imageNamed:@"WL_action_camera"]
                                    selectedImage:[UIImage imageNamed:@"WL_action_camera"]
                                            title:@"拍照".nim_localized];
    NIMMediaItem *photoItem = [NIMMediaItem item:@"onTapMediaItemPicture:"
                                     normalImage:[UIImage imageNamed:@"WL_action_photo"]
                                   selectedImage:[UIImage imageNamed:@"WL_action_photo"]
                                           title:@"照片".nim_localized];
    NSMutableArray *itemsAry = [NSMutableArray arrayWithArray:@[cameraItem,photoItem]];
    
    return itemsAry;
    
}


/**
 *  是否禁用在贴耳的时候自动切换成听筒模式
 */
- (BOOL)disableProximityMonitor{
    return NO;
}

/**
 *  是否需要处理已读回执
 *
 */
- (BOOL)shouldHandleReceipt{
    return YES;
}

/**
 *  这次消息时候需要做已读回执的处理
 *
 *  @param message 消息
 *
 *  @return 是否需要
 */
- (BOOL)shouldHandleReceiptForMessage:(NIMMessage *)message
{
    //文字，语音，图片，视频，文件，地址位置和自定义消息都支持已读回执，其他的不支持
    NIMMessageType type = message.messageType;
//    if (type == NIMMessageTypeCustom) {
//        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
//        id attachment = object.attachment;
//
//        //        if ([attachment isKindOfClass:[NTESWhiteboardAttachment class]]) {
//        //            return NO;
//        //        }
//    }
    
    
    
    return type == NIMMessageTypeText ||
    type == NIMMessageTypeAudio ||
    type == NIMMessageTypeImage ||
    type == NIMMessageTypeVideo ||
    type == NIMMessageTypeFile ||
    type == NIMMessageTypeLocation ||
    type == NIMMessageTypeCustom;
}

/**
 *  录音类型
 *
 *  @return 录音类型
 */
- (NIMAudioType)recordType
{
    return NIMAudioTypeAAC;
}
/**
 *  最大录音时长 2分钟
 *
 *  @return 录音时常
 */
- (NSTimeInterval)maxRecordDuration {
    
    return 2 * 60.0;
    
}
@end
