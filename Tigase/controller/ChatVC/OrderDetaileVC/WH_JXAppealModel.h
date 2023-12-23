//
//  WH_JXAppealModel.h
//  Tigase
//
//  Created by 1111 on 2023/12/23.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXAppealModel : NSObject

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,copy)NSString *note;
@property(nonatomic,copy)NSString *participantUID;
@property(nonatomic,copy)NSString *result;
@property(nonatomic,copy)NSString *tradeComplaintId;
@property(nonatomic,copy)NSString *round;
@property(nonatomic,copy)NSString *tradeNo;
@property(nonatomic,copy)NSString *viewed;
@property(nonatomic,strong)UIImage *cover;


@end


//createTime = 1703319281873;
//id = 658696f15feedd038196d5f5;
//items =             (
//    "http://192.168.1.88:8089/resources/u/12/10000012/202312/o/db9c9fcb92c747658b8caa18307a9d49.jpg",
//    "http://192.168.1.88:8089/resources/u/12/10000012/202312/o/7f128dc765e34f178717adbd960f8516.jpg",
//    "http://192.168.1.88:8089/resources/u/12/10000012/202312/58ebd885835543dcb18da7324d1e2eca.mp4"
//);
//note = "\U54c8\U55bd\U54c8\U54c8\U54c8\U54c8\U54c8";
//participantUID = 10000012;
//result = 0;
//round = 2;
//tradeComplaintId = 65868ae7757fc81b345384db;
//tradeNo = T495970470899781;
//viewed = 0;

NS_ASSUME_NONNULL_END
