//
//  WH_JXGroupMemberRedPacketUnclaimedVC.m
//  Tigase
//
//  Created by luan on 2023/6/11.
//  Copyright © 2023 Reese. All rights reserved.
//长时间未领取红包列表

#import "WH_JXGroupMemberRedPacketUnclaimedVC.h"
#import "WH_JXGroupMemberRedPacketUnclaimedCell.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "WH_JXredPacketDetail_WHVC.h"
#import "RedPacketView.h"
#import "FMDatabase.h"

@interface WH_JXGroupMemberRedPacketUnclaimedVC () <UITableViewDataSource, UITableViewDelegate>{
    BOOL _isLoading;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    ATMHud* _wait;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)BOOL isDidRedPacketRemind;
@property (weak, nonatomic) IBOutlet UIImageView *nodataImage;
@property (weak, nonatomic) IBOutlet UILabel *nodataLab;


@end

@implementation WH_JXGroupMemberRedPacketUnclaimedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    _wait = [ATMHud sharedInstance];
    _isLoading = YES;
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupMemberRedPacketUnclaimedCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupMemberRedPacketUnclaimedCell"];
    //设置刷新的头部以及加载
    [self setTableHeaderAndFotter];
    //数据请求、
    [self receiveRedReceiveListData];
}
//设置刷新以及加载
-(void)setTableHeaderAndFotter{
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    __weak WH_JXGroupMemberRedPacketUnclaimedVC *weakSelf = self;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.page ++;
        [weakSelf receiveRedReceiveListData];
        //        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.tableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.page = 0;
        // 进入刷新状态就会回调这个Block
        [weakSelf receiveRedReceiveListData];
    };
    
}
//数据请求
-(void)receiveRedReceiveListData{
    [g_server WH_redListPageIndex:self.page roomId:self.room.roomJid toView:self];
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    [self WH_stopLoading];
    
    if([aDownload.action isEqualToString:wh_receiv_RedList]){
        if (self.page == 0) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array1];
            
            self.nodataLab.hidden = self.nodataImage.hidden = array1.count > 0?YES:NO;
            
        }else {
            [self.dataArray addObjectsFromArray:array1];
        }
        
        [self.tableView reloadData];
    }else if ([aDownload.action isEqualToString:wh_act_getRedPacket]){//红包详情
        //        if ([dict[@"packet"][@"type"] intValue] != 3) {
        NSString *userId = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"packet"] objectForKey:@"userId"]];
        if (self.room.roomJid.length > 0) {
            if (self.isDidRedPacketRemind) {
                self.isDidRedPacketRemind = NO;
                WH_JXredPacketDetail_WHVC * redPacketDetailVC = [[WH_JXredPacketDetail_WHVC alloc]init];
                redPacketDetailVC.wh_dataDict = [[NSDictionary alloc]initWithDictionary:dict];
                redPacketDetailVC.isGroup = self.room.roomId.length > 0;
                [g_navigation pushViewController:redPacketDetailVC animated:YES];
            }else {
                [self WH_showRedPacket:dict];
            }
            
            //            [g_server openRedPacket:dict[@"packet"][@"id"] toView:self];
        }else {
            [_wait stop];
            if ([userId isEqualToString:MY_USER_ID]) {
                //                [self changeMessageRedPacketStatus:dict[@"packet"][@"id"]];
                //                [self changeMessageArrFileSize:dict[@"packet"][@"id"]];
                
                WH_JXredPacketDetail_WHVC * redPacketDetailVC = [[WH_JXredPacketDetail_WHVC alloc]init];
                redPacketDetailVC.wh_dataDict = [[NSDictionary alloc]initWithDictionary:dict];
                redPacketDetailVC.isGroup = self.room.roomId.length > 0;
                [g_navigation pushViewController:redPacketDetailVC animated:YES];
            }else {
                //                [g_server openRedPacket:dict[@"packet"][@"id"] toView:self];
                [self WH_showRedPacket:dict];
            }
        }
    }
}
#pragma mark 抢红包
- (void)WH_showRedPacket:(NSDictionary *)dict {
    [_wait stop];
    RedPacketView *redPacketView = [[RedPacketView alloc] initWithRedPacketInfo:dict];
    redPacketView.isGroup = self.room.roomId.length > 0;
    [redPacketView showRedPacket];
    redPacketView.redPocketBlock = ^(NSDictionary * _Nonnull dict, BOOL success) {
        //        self.redPacketDict = dict;
        if (success) {
            //刷新列表
            self.page = 1;
            [self receiveRedReceiveListData];
            
            
            NSString *userId = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"packet"] objectForKey:@"userId"]];
            [self changeMessageRedPacketStatus:dict[@"packet"][@"id"]];
            if (self.room.roomJid.length > 0) {
                WH_JXMessageObject *msg = [[WH_JXMessageObject alloc] init];
                msg.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
                msg.timeSend = [NSDate date];
                msg.toUserId = [NSString stringWithFormat:@"%ld",self.room.userId];
                msg.fromUserId = MY_USER_ID;
                msg.objectId = dict[@"packet"][@"id"];
                NSString *userName = [NSString string];
                NSString *overStr = [NSString string];
                if ([userId intValue] == [MY_USER_ID intValue]) {
                    userName = Localized(@"JX_RedPacketOneself");
                    double over = [[NSString stringWithFormat:@"%.2f",[dict[@"packet"][@"over"] floatValue]] doubleValue];
                    if (over < 0.01) {
                        overStr = Localized(@"JX_RedPacketOver");
                    }
                }else {
                    userName = dict[@"packet"][@"userName"];
                }
                NSString *getRedStr = [NSString stringWithFormat:Localized(@"JX_GetRedPacketFromFriend"),userName];
                msg.content = [NSString stringWithFormat:@"%@%@",getRedStr,overStr];
                [msg insert:self.room.roomJid];
                
//                [self WH_show_WHOneMsg:msg];
            }
            [g_server WH_getUserMoenyToView:self];
        }else {//红包被抢完
            WH_JXredPacketDetail_WHVC * redPacketDetailVC = [[WH_JXredPacketDetail_WHVC alloc]init];
            redPacketDetailVC.wh_dataDict = [[NSDictionary alloc]initWithDictionary:dict];
            redPacketDetailVC.isGroup = self.room.roomId.length > 0;
            [g_navigation pushViewController:redPacketDetailVC animated:YES];
        }
    };
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    
    if ([aDownload.action isEqualToString:wh_act_getRedPacket]){//红包详情
        //        if ([dict[@"packet"][@"type"] intValue] != 3) {
        NSString *userId = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"packet"] objectForKey:@"userId"]];
        if (self.room.roomJid.length > 0) {
            WH_JXredPacketDetail_WHVC * redPacketDetailVC = [[WH_JXredPacketDetail_WHVC alloc]init];
            redPacketDetailVC.wh_dataDict = [[NSDictionary alloc]initWithDictionary:dict];
            redPacketDetailVC.isGroup = self.room.roomId.length > 0;
            [g_navigation pushViewController:redPacketDetailVC animated:YES];
        }
        return WH_hide_error;
    }
    
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    [_wait start];
}
- (void)WH_stopLoading {
    _isLoading = NO;
    [_footer endRefreshing];
    [_header endRefreshing];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupMemberRedPacketUnclaimedCell *cell = (WH_JXGroupMemberRedPacketUnclaimedCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupMemberRedPacketUnclaimedCell" forIndexPath:indexPath];
    
    if(self.dataArray.count > indexPath.row){
        NSDictionary *dic = self.dataArray[indexPath.row];
        
        NSString *sendNickname = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sendNickname"]];
        //头像
        [g_server WH_getHeadImageSmallWIthUserId:[dic objectForKey:@"sendUserId"] userName:sendNickname imageView:cell.avatarImage];
        //昵称
        cell.nickNameLabel.text = sendNickname;
        NSString *time = [NSString stringWithFormat:@"%@",dic[@"sendTime"]];
        //时间
        cell.timeLabel.text = [self getTimeFrom:time.doubleValue];
        //红包类型 1.普通红包   2.拼手气   3.口令
        NSString *type = @"普通红包";
        NSNumber *redType = [NSNumber numberWithInteger:[NSString stringWithFormat:@"%@",dic[@"type"]].integerValue];
        if(redType.intValue == 2){
            type = @"手气红包";
        }else if (redType.intValue == 3){
            type = @"口令红包";
        }
        cell.typeLabel.text = type;
        NSString *receiveCount = [NSString stringWithFormat:@"%@",dic[@"receiveCount"]];
        NSString *count = [NSString stringWithFormat:@"%@",dic[@"count"]];
        
        NSInteger redCount = count.integerValue - receiveCount.integerValue;
        
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld",redCount >=0?redCount:0];
        cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[dic[@"overMoney"] floatValue]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count > indexPath.row){
        NSDictionary *dic = self.dataArray[indexPath.row];
        //获取已经领取的数组
        NSMutableArray *array = [NSMutableArray arrayWithArray:[dic objectForKey:@"userIds"]];
        if([array containsObject:g_myself.userId]){
            self.isDidRedPacketRemind = YES;
        }
//        else{
            //获取红包详情
            [g_server WH_getRedPacketWithMsg:[NSString stringWithFormat:@"%@",dic[@"redPacketId"]] toView:self];
//        }
        
    }
    
}
/**
 *根据时间戳 转时间
 */
-(NSString *)getTimeFrom:(double)second{
    //将对象类型的时间转换为NSDate类型
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:second];
        
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter2 stringFromDate:date];
        
    return dateString;
}
//改变红包对应消息的不可获取
-(void)changeMessageRedPacketStatus:(NSString*)redPacketId{
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0){
        return;
    }
    FMDatabase* db = [[JXXMPP sharedInstance] openUserDb:myUserId];
    
    NSString * sufStr = self.room.roomJid.length > 0? self.room.roomJid : [NSString stringWithFormat:@"%ld",self.room.userId];
    
    NSString * sql = [NSString stringWithFormat:@"update msg_%@ set fileSize=2 where objectId=?",sufStr];
    
    [db executeUpdate:sql,redPacketId];

    db = nil;
}



@end
