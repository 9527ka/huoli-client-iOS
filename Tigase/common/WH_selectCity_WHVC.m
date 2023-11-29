//
//  WH_selectCity_WHVC.h.m
//
//  Created by flyeagleTang on 14-4-3.
//  Copyright (c) 2019年 YZK. All rights reserved.
//

#import "WH_selectCity_WHVC.h"
#import "WH_JXChat_WHViewController.h"
#import "AppDelegate.h"
#import "JXLabel.h"
#import "WH_JXImageView.h"
//#import "WH_JX_WHCell.h"
#import "WH_JXRoomPool.h"
#import "JXTableView.h"
#import "WH_JXNewFriend_WHViewController.h"
#import "WH_menuImageView.h"
#import "WH_JXConstant.h"
#import "WH_selectArea_WHVC.h"

#define row_height 40

@interface WH_selectCity_WHVC ()

@end

@implementation WH_selectCity_WHVC
@synthesize parentId,parentName,showArea;
@synthesize selected;
@synthesize delegate;
@synthesize didSelect;
@synthesize selValue;
@synthesize areaId;

- (id)init
{
    self = [super init];
    if (self) {
        self.areaId   = 0;
        self.cityId   = 0;
        self.wh_heightHeader = JX_SCREEN_TOP;
        self.wh_heightFooter = 0;
        self.wh_isGotoBack   = YES;
        self.title = self.parentName;
        //self.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
        [self WH_createHeadAndFoot];
        self.wh_isShowFooterPull = NO;
        self.wh_isShowHeaderPull = NO;
        
        _table.backgroundColor = [UIColor whiteColor];
        _array = [g_constant getCity:parentId];

        _keys = [_array allKeys];
        _keys = [_keys sortedArrayUsingSelector:@selector(compare:)];
//        [_keys retain];
    }
    return self;
}

- (void)dealloc {
    self.selValue = nil;
    self.parentName = nil;
//    [_keys release];
    [_array removeAllObjects];
//    [_array release];
//    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell=nil;
    NSString* cellName = [NSString stringWithFormat:@"msg_%d_%ld",_refreshCount,indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        cell = [UITableViewCell alloc];
        [_table WH_addToPool:cell];
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
        UILabel* p = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, row_height)];
        if(indexPath.row==0)
            p.text = parentName;
        else
            p.text = [_array objectForKey:[_keys objectAtIndex:indexPath.row-1]];
        p.font = sysFontWithSize(16);
        [cell addSubview:p];
//        [p release];
        
            UIView* line = [[UIView alloc] initWithFrame:CGRectMake(18,row_height-0.5,JX_SCREEN_WIDTH-18-20,0.5)];
            line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
            [cell addSubview:line];
//            [line release];
        
        if(indexPath.row>0){
            UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_flag"]];
            iv.frame = CGRectMake(JX_SCREEN_WIDTH-20, (row_height-13)/2, 7, 13);
            [cell addSubview:iv];
//            [iv release];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selValue = self.parentName;
    self.selected = self.parentId;
    if(indexPath.row>0){
        self.selValue = [_array objectForKey:[_keys objectAtIndex:indexPath.row-1]];
        self.selected = [[_keys objectAtIndex:indexPath.row-1] intValue];
        self.cityId = self.selected;
        if(self.showArea){
            WH_selectArea_WHVC* vc = [WH_selectArea_WHVC alloc];
            vc.parentName = self.selValue;
            vc.parentId = self.selected;
            vc.didSelect = @selector(doSelect:);
            vc.delegate = self;
            vc = [vc init];
//            [g_window addSubview:vc.view];
            [g_navigation pushViewController:vc animated:YES];
            return;
        }
    }
    if (delegate && [delegate respondsToSelector:didSelect])
//        [delegate performSelector:didSelect withObject:self];
        [delegate performSelectorOnMainThread:didSelect withObject:self waitUntilDone:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self actionQuit];
    });
    
}

-(void)doSelect:(WH_selectArea_WHVC*)sender{
    if(sender.selected==sender.parentId)
        self.selValue = sender.selValue;
    else
        self.selValue = [NSString stringWithFormat:@"%@.%@",self.selValue,sender.selValue];
    self.cityId   = sender.parentId;
    self.areaId   = sender.selected;
    self.selected = sender.selected;
    if (delegate && [delegate respondsToSelector:didSelect])
//        [delegate performSelector:didSelect withObject:self];
        [delegate performSelectorOnMainThread:didSelect withObject:self waitUntilDone:NO];
    [self actionQuit];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return row_height;
}

@end
