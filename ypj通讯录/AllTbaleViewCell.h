//
//  AllTbaleViewCell.h
//  ypj通讯录
//
//  Created by niit on 16/1/26.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContactModel;
@interface AllTbaleViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *myHeadButton;

@property (nonatomic, copy) ContactModel* mycontact;

@property (weak, nonatomic) IBOutlet UILabel *myNameLable;
@property (weak, nonatomic) IBOutlet UIButton *myTelButton;

/**
 *  创建一个cell
 *
 *  @param contact cell自己的数据
 *
 *  @return cell
 */
-(instancetype)initWithcontact:(ContactModel*)contact;


@end
