//
//  AllTbaleViewCell.m
//  ypj通讯录
//
//  Created by niit on 16/1/26.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import "AllTbaleViewCell.h"
#import "ContactModel.h"
#import "DropDownChooseProtocol.h"
#import "DropDownListView.h"
@interface AllTbaleViewCell()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,DropDownChooseDelegate,DropDownChooseDataSource>

@property (weak, nonatomic) IBOutlet UIButton *myCallButton;
@property (weak, nonatomic) IBOutlet UIButton *mySMSButton;

@end
@implementation AllTbaleViewCell
{
    NSMutableArray* chooseArr;
}

-(instancetype)initWithcontact:(ContactModel*)contact{
    [self setBackgroundColor:[UIColor clearColor]];
    self = [[[NSBundle mainBundle]loadNibNamed:@"AllTbaleViewCell" owner:nil options:nil]lastObject];
   _mycontact = contact;
    chooseArr = [NSMutableArray array];
    [chooseArr addObject:self.mycontact.myPersonalTel];
    [chooseArr addObject:self.mycontact.myCompanyTel];
    [self.myHeadButton setBackgroundImage:[UIImage imageNamed:@"map_people"] forState:UIControlStateNormal];

    //    [self.myHeadButton addTarget:self action:@selector(changeHeadButtonImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mySMSButton setBackgroundImage:[UIImage imageNamed:@"send_message"] forState:UIControlStateNormal];
    [_mySMSButton addTarget:self action:@selector(sendSMS:) forControlEvents:UIControlEventTouchUpInside];
    _mySMSButton.contentMode = UIViewContentModeScaleAspectFit;

    _myCallButton.contentMode = UIViewContentModeScaleAspectFit;

    [self.myCallButton setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    self.myNameLable.text = contact.myName;
    NSString* currentTel =contact.myPersonalTel?contact.myPersonalTel:contact.myCompanyTel;
    NSString* showTel = [NSString stringWithFormat:@"%@",currentTel];
    [self.myTelButton setTitle:showTel forState:UIControlStateNormal];
    [self.myCallButton addTarget:self action:@selector(callout:) forControlEvents:UIControlEventTouchUpInside];
    
    DropDownListView* tellist = [[DropDownListView alloc]initWithFrame:self.myTelButton.frame dataSource:self delegate:self];
//    tellist.superview = self.myTelButton.contentView;
//    tellist.superview = self.backgroundView;
    
    
    [self.backgroundView addSubview:tellist];
    
    return self;
}

//-(void)setMycontact:(ContactModel *)mycontact{
//
//    if (_mycontact == nil ) {
//        _mycontact = mycontact;
//    }
////    [self.myCallImageView setImage:[UIImage imageNamed:@"call"]];
////    self.myNameLable.text = self.mycontact.myName;
////    [self.myTelButton setTitle:_mycontact.myPersonalTel?_mycontact.myPersonalTel:_mycontact.myCompanyTel forState:UIControlStateNormal];
//}

-(void)callout:(id)sender{
    NSLog(@"calling。。。");
//  （一）  不返回app
//    UIButton* btn = (UIButton*)sender;
//    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",btn.titleLabel.text]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
#warning ---Need Test Again 功能未测试
    // （二）返回app （无真机，未测试）1
//    UIWebView* callWebview = [[UIWebView alloc] init];
//    NSURL* telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.myTelButton.currentTitle]];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    //记得添加到view上
//    [self addSubview:callWebview];
    
}

-(void)sendSMS:(id)sender{
    
    
    
    
}

//-(void)changeHeadButtonImage:(NSUInteger)sourcetype{
//    NSLog(@"change headImage");
//    UIImagePickerController* imagePickercontroller = [[UIImagePickerController alloc]init];
//    imagePickercontroller.delegate = self;
//    
//    imagePickercontroller.allowsEditing = NO;
//    
//    imagePickercontroller.sourceType = sourcetype;
//    
//    [self.superview 
//    
//    
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark DropDownChooseDataSource

-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index{
    
    
    
}

#pragma mark  DropDownChooseDelegate
-(NSInteger)numberOfSections
{
    return 1;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
//    NSArray *arry =self.mycontact[section];
    return chooseArr.count;
    //    return 0;
}

-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return [NSString stringWithFormat:@"%@", chooseArr[index]];
//    return nil;
}

-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}
@end
