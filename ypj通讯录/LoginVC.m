//
//  LoginVC.m
//  ypj通讯录
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 ypj. All rights reserved.
//

#import "LoginVC.h"
#import <Bmob.h>
@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *myTelTF;
@property (weak, nonatomic) IBOutlet UITextField *MyPassWordTF;

@end

@implementation LoginVC
- (IBAction)loginAction:(id)sender {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"user_list"];

    [bquery whereKey:@"user_tel" equalTo:self.myTelTF.text];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSDictionary* userInfoDic = [array lastObject];
        if (array.count != 0&&array != nil) {
            if ([self.MyPassWordTF.text isEqualToString: [userInfoDic  objectForKey:@"user_password"]]) {
                NSLog(@"用户信息/t%@",userInfoDic);
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path = [paths objectAtIndex:0];
                NSString *filename  = [path stringByAppendingPathComponent:@"test.plist"];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:@123 forKey:@"Id"];

                [dic setObject:[userInfoDic objectForKey:USER_CONTACT_LIST_NAME] forKey:USER_CONTACT_LIST_NAME];
//                [dic setValue:<#(nullable id)#> forKey:<#(nonnull NSString *)#>];
                [dic writeToFile:filename atomically:YES];
//                [dic setobject:[] forKey:USER_GROUP_COUNT];
                [USERDEFAULT setValue:[userInfoDic objectForKey:USER_CONTACT_LIST_NAME] forKey:USER_CONTACT_LIST_NAME];
                [USERDEFAULT setBool:YES forKey:USER_ISLOGINING];
                [USERDEFAULT setValue:[userInfoDic objectForKey:USER_TEL] forKey:USER_TEL];
                [USERDEFAULT setValue:[userInfoDic objectForKey:USER_PASSWORD] forKey:USER_PASSWORD];
                [USERDEFAULT setValue:[userInfoDic objectForKey:USER_OBJECTID] forKey:USER_OBJECTID];
                [USERDEFAULT setValue:[userInfoDic objectForKey:USER_CONTACT_LIST_NAME] forKey:USER_CONTACT_LIST_NAME];
                [USERDEFAULT synchronize];
                NSLog(@"登陆成功");
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                NSLog(@"密码不对");
            }
        }else if(array.count ==0){
            NSLog(@"账号输入错误");
        }else if (array.count ==0){
            NSLog(@"%@",error);
        }
    }];
    
}


- (IBAction)regAction:(id)sender {
    
}




- (IBAction)forgetPassWordAction:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTelTF.text = [USERDEFAULT objectForKey:USER_TEL];
    self.MyPassWordTF.text = [USERDEFAULT objectForKey:USER_PASSWORD];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
