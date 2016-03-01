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

-(ContactModel *)mycontact{
    if (_mycontact == nil) {
        self.mycontact = [[ContactModel alloc ]init];
    }
    return _mycontact;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mycontact = [[ContactModel alloc]init];
    }
    return self;
}
-(void)awakeFromNib{
    if (_mycontact == nil) {
        self.mycontact = [[ContactModel alloc]init];
    }
}

-(instancetype)initWithcontact:(ContactModel*)contact{

    self = [[[NSBundle mainBundle]loadNibNamed:@"AllTbaleViewCell" owner:nil options:nil]lastObject];
    self.mycontact = [[ContactModel alloc]init];
    self.mycontact = contact;
    chooseArr = [[NSMutableArray alloc]init];
    [chooseArr addObject:contact.myPersonalTel?contact.myPersonalTel:nil];
    [chooseArr addObject:contact.myCompanyTel?contact.myCompanyTel:nil];
//    cellb背景色
    [self setBackgroundColor:[UIColor clearColor]];
    UIView *backgroundview = [[UIView alloc]initWithFrame:self.frame];
    [backgroundview setBackgroundColor:[UIColor whiteColor]];
    backgroundview.layer.cornerRadius = 10;
    [self setBackgroundView:backgroundview];
    
    
   _mycontact = contact;
    chooseArr = [NSMutableArray array];
    [chooseArr addObject:self.mycontact.myPersonalTel];
    [chooseArr addObject:self.mycontact.myCompanyTel];
    [self.myHeadButton setBackgroundImage:[UIImage imageNamed:self.mycontact.myHeadImage?self.mycontact.myHeadImage:@"head_default.png"] forState:UIControlStateNormal];


//    短信
    [self.mySMSButton setBackgroundImage:[UIImage imageNamed:@"send_message"] forState:UIControlStateNormal];
    [_mySMSButton addTarget:self action:@selector(sendSMS:) forControlEvents:UIControlEventTouchUpInside];
    _mySMSButton.contentMode = UIViewContentModeScaleAspectFit;
//     打电话
    _myCallButton.contentMode = UIViewContentModeScaleAspectFit;
    [self.myCallButton setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    self.myNameLable.text = contact.myName;
    
    NSString* currentTel = contact.myPersonalTel?contact.myPersonalTel:contact.myCompanyTel;
    NSString* showTel = [NSString stringWithFormat:@"%@",currentTel];
    [self.myTelButton setTitle:showTel forState:UIControlStateNormal];
    [self.myCallButton addTarget:self action:@selector(callout:) forControlEvents:UIControlEventTouchUpInside];
    [self.mySMSButton addTarget:self action:@selector(sendSMS:) forControlEvents:UIControlEventTouchUpInside];
    
//    有2个电话时会有下拉列表

    
    
    
    
    
    
    return self;
}


-(void)callout:(id)sender{
    NSLog(@"calling。。。");
//  （一）  不返回app
//    UIButton* btn = (UIButton*)sender;
//    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",btn.titleLabel.text]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    // （二）返回app
    UIWebView* callWebview = [[UIWebView alloc] init];
    NSURL* telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.myTelButton.currentTitle]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self addSubview:callWebview];
    
}

-(void)sendSMS:(id)sender{
    NSLog(@"%s",__func__);
    if ([self.messagedelegate respondsToSelector:@selector(showMessageView:title:body:)]) {
        [self.messagedelegate showMessageView:@[self.mycontact.myPersonalTel] title:nil body:nil];
    
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

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
