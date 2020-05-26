//
//  NIMUITextHelper.m
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/26.
//

#import "NIMUITextHelper.h"
@implementation NIMUITextHelper
/**
 想和Ta说点什么？
*/
+ (NSString *)UITextPlaceHolderIMInput{
    return @"想和Ta说点什么？";
}

/**
   拍照
 */
+ (NSString *)UITextFeedPublicFeedWayCamera {
    return @"拍照";
}

/**
   照片
 */
+ (NSString *)UITextFeedPublicFeedWayAlbum {
    return @"照片";
}

/**
 按住说话
 */
+ (NSString *)UITextMsgInputVoiceContainerAlert {
    return @"按住说话";
}

/**
 说话时间太短!!!
 */
+ (NSString *)UITextMsgSessionAudioRecordTimeShort {
    return @"说话时间太短!!!";
}
@end
