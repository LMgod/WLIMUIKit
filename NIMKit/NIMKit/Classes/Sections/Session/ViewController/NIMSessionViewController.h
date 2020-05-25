//
//  NIMSessionViewController.h
//  NIMKit
//
//  Created by NetEase.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>
#import "NIMSessionConfig.h"
#import "NIMMessageCellProtocol.h"
#import "NIMSessionConfigurateProtocol.h"
#import "NIMInputView.h"
#import "NIMAdvanceMenu.h"

@interface NIMSessionViewController : UIViewController<NIMSessionInteractorDelegate,NIMInputActionDelegate,NIMMessageCellDelegate,NIMChatManagerDelegate,NIMConversationManagerDelegate,NIMChatExtendManagerDelegate>

@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, strong)  NIMInputView *sessionInputView;

@property (nonatomic,strong)    NIMAdvanceMenu *advanceMenu;

@property (nonatomic, strong)  NIMSession *session;

@property (nonatomic,weak)    id<NIMSessionInteractor> interactor;

- (instancetype)initWithSession:(NIMSession *)session;
- (id<NIMSessionConfig>)sessionConfig;
- (void)sendMessage:(NIMMessage *)message;
@end
