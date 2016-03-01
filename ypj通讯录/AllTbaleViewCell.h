//
//  AllTbaleViewCell.h
//  ypj通讯录
//
//  Created by niit on 16/1/26.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@protocol showdelegate <NSObject>
@optional

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body;

@end


@class ContactModel;

@interface AllTbaleViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *myHeadButton;
@property (strong, nonatomic) ContactModel *mycontact;
@property (weak, nonatomic) IBOutlet UILabel *myNameLable;
@property (weak, nonatomic) IBOutlet UIButton *myTelButton;
@property (weak, nonatomic) UITableViewController<MFMessageComposeViewControllerDelegate,showdelegate> *messagedelegate;


/**
 *  创建一个cell
 *
 *  @param contact cell自己的数据
 *
 *  @return cell
 */
-(instancetype)initWithcontact:(ContactModel*)contact;


@end
