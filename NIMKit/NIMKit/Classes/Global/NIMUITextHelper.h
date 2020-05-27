//
//  NIMUITextHelper.h
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NIMUITextHelper : NSObject

/**
 想和Ta说点什么？
*/
+ (NSString *)UITextPlaceHolderIMInput;
/**
   拍照
 */
+ (NSString *)UITextFeedPublicFeedWayCamera;
/**
   照片
 */
+ (NSString *)UITextFeedPublicFeedWayAlbum;

/**
 按住说话
 */
+ (NSString *)UITextMsgInputVoiceContainerAlert;

/**
 说话时间太短!!!
 */
+ (NSString *)UITextMsgSessionAudioRecordTimeShort;


@end

NS_ASSUME_NONNULL_END
