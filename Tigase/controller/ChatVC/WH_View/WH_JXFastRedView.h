//
//  WH_JXFastRedView.h
//  Tigase
//
//  Created by 1111 on 2024/2/1.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendRedPacketVCDelegate <NSObject>

- (void)sendRedPacketDelegate:(NSDictionary *_Nullable)redpacketDict;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXFastRedView : UIView

@property (nonatomic,strong) WH_RoomData * room;

@property (nonatomic, weak) id<SendRedPacketVCDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
