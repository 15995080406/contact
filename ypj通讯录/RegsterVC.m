//
//  RegsterVC.m
//  ypj通讯录
//
//  Created by niit on 16/1/6.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import "RegsterVC.h"
#import <Bmob.h>
@interface RegsterVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myTelTF;
@property (weak, nonatomic) IBOutlet UITextField *myPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *myRegisterButton;

@end

@implementation RegsterVC
- (IBAction)registerAction:(id)sender {

    if (self.myTelTF.text.length != 0 && self.myTelTF.text.length != 0 ) {
        BmobObject   *bobject = [BmobObject objectWithClassName:@"user_list"];
        [bobject setObject:self.myTelTF.text forKey:USER_TEL];
        [bobject setObject:self.myPasswordTF.text forKey:USER_PASSWORD];
        [bobject setObject:[NSString stringWithFormat:@"user_%@_list",self.myTelTF.text] forKey:USER_CONTACT_LIST_NAME];
        [bobject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [USERDEFAULT setObject:self.myTelTF.text forKey:USER_TEL];
                [USERDEFAULT synchronize];
                [self showAlertWithtitle:@"注册成功" andmessage:@"即将回到个人中心"];
            } else if(error.code ==401 ){
                NSLog(@"%@",error);
                [self showAlertWithtitle:@"错误" andmessage:@"账号重复"];
            }
        }];
    } else {
        [self showAlertWithtitle:@"账号或密码错误" andmessage:@"请重新输入"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTelTF.delegate = self;
    self.myPasswordTF.delegate = self;
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.myTelTF.frame.origin.x, self.myTelTF.frame.origin.y, self.myTelTF.frame.size.height, self.myTelTF.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"edit"]];
    self.myTelTF.leftView =imageView;
    self.myTelTF.leftViewMode = UITextFieldViewModeAlways;
    self.myTelTF.returnKeyType = UIReturnKeyNext;
    
    self.myPasswordTF.delegate = self;
    UIImageView* imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.myPasswordTF.frame.origin.x, self.myPasswordTF.frame.origin.y, self.myPasswordTF.frame.size.height, self.myPasswordTF.frame.size.height)];
    [imageView2 setImage:[UIImage imageNamed:@"edit"]];
    self.myPasswordTF.leftView = imageView2;
    self.myPasswordTF.leftViewMode = UITextFieldViewModeAlways;
    self.myPasswordTF.returnKeyType = UIReturnKeyDone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.myTelTF) {
        [self.myTelTF resignFirstResponder];
        [self.myPasswordTF becomeFirstResponder];
    } else if(textField == self.myPasswordTF){
        [self.myPasswordTF resignFirstResponder];
        [self registerAction:self.myRegisterButton];
    }
    return YES;
}

-(void)showAlertWithtitle:(NSString*)str andmessage:(NSString*)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:str message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([str  isEqualToString:@"注册成功"]) {
            [self popoverPresentationController];

        } else if([str isEqualToString:@"账号或密码错误"]){
            [self popoverPresentationController];
            
        }else if([str isEqualToString:@"错误"]){
            [self popoverPresentationController];
        }
        
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
