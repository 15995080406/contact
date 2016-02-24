//
//  Editvc.h
//  ypj通讯录
//
//  Created by niit on 16/1/7.,
//  Copyright © 2016年 ypj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

@interface Editvc : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *myNameTF;
@property (weak, nonatomic) IBOutlet UITextField *myPersonTelTF;
@property (weak, nonatomic) IBOutlet UITextField *myCompanyTelTF;

@property (weak, nonatomic) IBOutlet UIDatePicker *myBirthdayDatePickerview;

@property (weak, nonatomic) IBOutlet UISwitch *myBirthClockSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *myShareToOtherSwitch;
@property (weak, nonatomic) IBOutlet UIButton *myCreatButtion;

@property (weak, nonatomic) IBOutlet UITextField *myGroupName;
@property (weak, nonatomic) IBOutlet UITextField *myMarkTF;

@property (nonatomic,strong) ContactModel* mycontact;


-(instancetype)initWithContact:(ContactModel*)contact;

@end
