//
//  WH_JXRedPacketList_WHVC.h
//  Tigase_imChatT
//
//  Created by p on 2018/6/5.
//  Copyright © 2018年 YZK. All rights reserved.
//

#import "WH_JXTableViewController.h"

@interface WH_JXRedPacketList_WHVC : WH_JXTableViewController

@property (nonatomic,copy) NSString *roomJid;

@property(nonatomic,assign)BOOL isDiamound;

- (void)sp_checkUserInfo:(NSString *)mediaInfo;
@end
