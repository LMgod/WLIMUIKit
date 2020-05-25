//
//  WLMessageSessionConfig.h
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/25.
//

#import <Foundation/Foundation.h>
#import "NIMSessionConfig.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WLMoreItemType) {
    WLMoreItemTypeSendPhto = 0,
    WLMoreItemTypeSpCall,
    WLMoreItemTypeYYCall,
    WLMoreItemTypeSendGift,
    WLMoreItemTypeSendCamera,
};
@interface WLMessageSessionConfig : NSObject<NIMSessionConfig>

@end

NS_ASSUME_NONNULL_END
