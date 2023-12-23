//
//  WH_JXAppealListVC.m
//  Tigase
//
//  Created by 1111 on 2023/12/22.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXAppealListVC.h"
#import "WH_JXAppealListCell.h"
#import "WH_JXAppealAddVC.h"
#import "WH_JXChat_WHViewController.h"
#import "WH_JXAppealModel.h"
#import "WH_JXVideoPlayer.h"

@interface WH_JXAppealListVC ()<UITableViewDataSource, UITableViewDelegate>{
    WH_JXVideoPlayer* videoPlayer;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UILabel *reasonLab;
@property (weak, nonatomic) IBOutlet UILabel *statueLab;
@property (weak, nonatomic) IBOutlet UILabel *detaileLab;

@end

@implementation WH_JXAppealListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取申诉列表接口
    [g_server WH_orderAppealListWithId:self.orderId toView:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXAppealListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXAppealListCell"];
    
}
//联系对方
- (IBAction)connectAction:(id)sender {
    WH_JXUserObject *userobj = [[WH_JXUserObject sharedUserInstance] getUserById:self.otherUserId];
    
    WH_JXChat_WHViewController *sendView=[WH_JXChat_WHViewController alloc];
    sendView.scrollLine = 0;
    sendView.title = userobj.userNickname;
    sendView.chatPerson = userobj;
    sendView = [sendView init];
    [g_navigation pushViewController:sendView animated:YES];
}
//提交申诉
- (IBAction)commitAction:(id)sender {
    WH_JXAppealAddVC *vc = [[WH_JXAppealAddVC alloc] init];
    vc.orderId = self.orderId;
    [g_navigation pushViewController:vc animated:YES];
}
- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
// MARK: -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXAppealListCell *cell = (WH_JXAppealListCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXAppealListCell" forIndexPath:indexPath];
    if(self.dataSource.count > indexPath.row){
        cell.model = self.dataSource[indexPath.row];
    }
    __weak typeof (self)weakSelf = self;
    cell.lookImageBlock = ^(NSInteger tag, NSArray * _Nonnull items) {
        
    };
    cell.lookVideoBlock = ^(NSString * _Nonnull videoUrl) {
        videoPlayer= [WH_JXVideoPlayer alloc];
        videoPlayer.videoFile = videoUrl;
        videoPlayer.WH_didVideoPlayEnd = @selector(WH_didVideoPlayEnd);
        videoPlayer.isStartFullScreenPlay = YES; //全屏播放
        videoPlayer.delegate = self;
        videoPlayer = [videoPlayer initWithParent:self.view];
        [videoPlayer wh_switch];
    };
    return cell;
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    
    
    NSString *listUrl = [NSString stringWithFormat:@"%@%@",wh_order_Info,self.orderId];
    if([aDownload.action isEqualToString:listUrl]){
        // /** start to process */
//        int STATUS_INIT = 1;
//           /** complaint is done*/
//        int STATUS_DONE = 2;
        NSString *status = [NSString stringWithFormat:@"%@",dict[@"status"]];
        self.statueLab.text = status.intValue == 1? @"申诉中":@"申诉已结束";
        self.detaileLab.text = status.intValue == 1? @"如需补充材料，可以提交心得申诉资料":@"如需进一步帮助，请发起一个新的申诉";
        
        NSArray *items = [WH_JXAppealModel mj_objectArrayWithKeyValuesArray:dict[@"items"]];
        for (WH_JXAppealModel *model in items) {
            if(model.items.count > 0){
                for (NSString *url in model.items) {
                    if([url containsString:@"video"] || [url containsString:@"mp4"]){
                        model.cover = [self thumbnailImageForVideo:[NSURL URLWithString:url]];
                    }
                }
            }
        }
        
        WH_JXAppealModel *model = items.firstObject;
        
        NSString *contentStr = [NSString stringWithFormat:@"%@",model.note];
        self.reasonLab.text = contentStr;
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:items];
        [self.tableView reloadData];
    }

}
//获取视频封面，本地视频，网络视频都可以用
- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL {

    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:nil];
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];

    return thumbImg;

}
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
//    [_wait start];
}

//complainantUID = 10000012;
//createTime = 1703316199221;
//id = 65868ae7757fc81b345384db;
//items =     (
//            {
//        createTime = 1703319281873;
//        id = 658696f15feedd038196d5f5;
//        items =             (
//            "http://192.168.1.88:8089/resources/u/12/10000012/202312/o/db9c9fcb92c747658b8caa18307a9d49.jpg",
//            "http://192.168.1.88:8089/resources/u/12/10000012/202312/o/7f128dc765e34f178717adbd960f8516.jpg",
//            "http://192.168.1.88:8089/resources/u/12/10000012/202312/58ebd885835543dcb18da7324d1e2eca.mp4"
//        );
//        note = "\U54c8\U55bd\U54c8\U54c8\U54c8\U54c8\U54c8";
//        participantUID = 10000012;
//        result = 0;
//        round = 2;
//        tradeComplaintId = 65868ae7757fc81b345384db;
//        tradeNo = T495970470899781;
//        viewed = 0;
//    }
//);
//result = 0;
//status = 0;
//tradeNo = T495970470899781;



@end
