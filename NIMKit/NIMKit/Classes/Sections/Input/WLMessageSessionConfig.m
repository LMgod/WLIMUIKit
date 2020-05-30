//
//  WLMessageSessionConfig.m
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/25.
//

#import "WLMessageSessionConfig.h"
#import "NSString+NIMKit.h"
#import "NIMUITextHelper.h"
@implementation WLMessageSessionConfig

/**
 *  可以显示在点击输入框“+”按钮之后的多媒体按钮
 */
- (NSArray<NIMMediaItem *> *)mediaItems {
    NIMMediaItem *cameraItem = [NIMMediaItem item:@"onTapMediaItemShoot:"
                                      normalImage:[UIImage imageNamed:@"WL_action_camera"]
                                    selectedImage:[UIImage imageNamed:@"WL_action_camera"]
                                            title:[NIMUITextHelper UITextFeedPublicFeedWayCamera]];
    NIMMediaItem *photoItem = [NIMMediaItem item:@"onTapMediaItemPicture:"
                                     normalImage:[UIImage imageNamed:@"WL_action_photo"]
                                   selectedImage:[UIImage imageNamed:@"WL_action_photo"]
                                           title:[NIMUITextHelper UITextFeedPublicFeedWayAlbum]];
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
    return NO;
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

@end
