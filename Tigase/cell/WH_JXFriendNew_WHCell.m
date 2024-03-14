//
//  WH_JXFriendNew_WHCell.m
//  Tigase
//
//  Created by 1111 on 2024/3/13.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXFriendNew_WHCell.h"

@implementation WH_JXFriendNew_WHCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headBtn.layer.cornerRadius = 26.5f;
    self.headImage.layer.cornerRadius = 26.5f;
    self.statueBtn.layer.cornerRadius = 14.0f;
    self.bgView.layer.cornerRadius = 10.0f;
    
    
}
- (IBAction)lookUserAction:(id)sender {
    if (self.lookUserInfo) {
        self.lookUserInfo();
    }
}

-(void)setUser:(WH_JXFriendObject *)user{
    _user = user;
}

-(void)update{
    NSString* s = @"";SEL action=nil;
    NSString* s2 = @"";SEL action2=nil;
    if([self.user.isMySend boolValue]){
        switch ([self.user.type intValue]) {
            case XMPP_TYPE_SAYHELLO:
                
                self.user.status = [NSNumber numberWithInt:friend_status_addFriend];
                [self.user update];
//                s = @"再打招呼";
//                action = @selector(onSayHello:);
                break;
            case XMPP_TYPE_PASS:
                break;
            case XMPP_TYPE_FEEDBACK:
                if ([self.user.status intValue] == friend_status_hisAddFriend) {
                    s = Localized(@"JX_Pass");
                    action = @selector(WH_clickAddFriend:);
                    s2 = Localized(@"JX_Talk");//同时显示两个按钮
                    action2 = @selector(onFeedback:);
                }else {
                    s2 = Localized(@"JX_Talk");
                    action2 = @selector(onFeedback:);
                }
                break;
            case XMPP_TYPE_NEWSEE:
                s = Localized(@"JX_SayHi");
                action = @selector(onSayHello:);
                break;
            case XMPP_TYPE_DELSEE:
                s = Localized(@"JX_FollowAngin");
                action = @selector(onSeeHim:);
                break;
            case XMPP_TYPE_DELALL:
                s = Localized(@"JX_FollowAngin");
                action = @selector(onSeeHim:);
                break;
            default:
                break;
        }
    }else{
        switch ([self.user.type intValue]) {
            case XMPP_TYPE_SAYHELLO:
                s = @"通过";
                action = @selector(WH_clickAddFriend:);
//                s2 = Localized(@"JX_Talk");//同时显示两个按钮
//                action2 = @selector(onFeedback:);
                self.user.status = [NSNumber numberWithInt:friend_status_hisAddFriend];
                [self.user update];
                break;
            case XMPP_TYPE_PASS:
                break;
            case XMPP_TYPE_FEEDBACK:
                if ([self.user.status intValue] == friend_status_hisAddFriend) {
                    s = Localized(@"JX_Pass");
//                    action = @selector(WH_clickAddFriend:);
                    s2 = Localized(@"JX_Talk");//同时显示两个按钮
                    action2 = @selector(onFeedback:);
                }else {
                    s2 = Localized(@"JX_Talk");
                    action2 = @selector(onFeedback:);
                }
                
                break;
            case XMPP_TYPE_NEWSEE:
                s = Localized(@"JX_AddFriend");
                action = @selector(WH_clickAddFriend:);
                break;
            case XMPP_TYPE_DELSEE:
                if([self.user.status intValue]==friend_status_none){
                    s = Localized(@"JX_Attion");
                    action = @selector(onSeeHim:);
                }
                if([self.user.status intValue]==friend_status_see){
                    s = Localized(@"JX_SayHi");
                    action = @selector(onSayHello:);
                }
                break;
            case XMPP_TYPE_RECOMMEND:
                if([self.user.status intValue]==friend_status_none){
                    s = Localized(@"JX_Attion");
                    action = @selector(onSeeHim:);
                }
                if([self.user.status intValue]==friend_status_see){
                    s = Localized(@"JX_SayHi");
                    action = @selector(onSayHello:);
                }
                break;
            default:
                break;
        }
    }
    self.remarkLab.text = [self.user getLastContent];
    [self.statueBtn setTitle:s forState:UIControlStateNormal];
    [self.statueBtn addTarget:self.target action:action forControlEvents:UIControlEventTouchUpInside];
    if(s.length == 0){
        self.statueBtn.userInteractionEnabled = NO;
        self.statueBtn.backgroundColor = HEXCOLOR(0xF8F8F8);
        [self.statueBtn setTitle:@"已通过" forState:UIControlStateNormal];
        [self.statueBtn setImage:nil forState:UIControlStateNormal];
        [self.statueBtn setTitleColor:HEXCOLOR(0xBABABA) forState:UIControlStateNormal];
    }else{
        self.statueBtn.userInteractionEnabled = YES;
        self.statueBtn.backgroundColor = HEXCOLOR(0x2BAF67);
        [self.statueBtn setTitle:s forState:UIControlStateNormal];
        [self.statueBtn addTarget:self.target action:action forControlEvents:UIControlEventTouchUpInside];
        [self.statueBtn setImage:[UIImage imageNamed:@"friend_check"] forState:UIControlStateNormal];
        [self.statueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
