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


/**
 星期一
*/
+ (NSString *)UITextWithTimeAlertMonday;
/**
 星期二
*/
+ (NSString *)UITextWithTimeAlertTuesday;
/**
 星期三
*/
+ (NSString *)UITextWithTimeAlertWednesday;
/**
 星期四
*/
+ (NSString *)UITextWithTimeAlertThursday;
/**
 星期五
*/
+ (NSString *)UITextWithTimeAlertFriday;
/**
 星期六
*/
+ (NSString *)UITextWithTimeAlertSaturday;
/**
 星期日
*/
+ (NSString *)UITextWithTimeAlertSunday;

/**
 昨天
*/
+ (NSString *)UITextWithTimeAlertYesterday;
/**
 前天
*/
+ (NSString *)UITextWithTimeAlertBeforeYesterday;
@end

NS_ASSUME_NONNULL_END
