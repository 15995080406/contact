//
//  Util.m
//  ypj通讯录
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import "Util.h"
@implementation Util

+(void)showAlertWith:(UIViewController*)VC usingTitle:(NSString*)str andmessage:(NSString*)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:str message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([str  isEqualToString:@"注册成功"]) {
//            [alert popoverPresentationController];
            NSLog(@"注册成功");
            
        } else if([str isEqualToString:@"账号或密码错误"]){
//            [alert popoverPresentationController];
            NSLog(@"账号密码错误");
        }else if([str isEqualToString:@"错误"]){
//            [alert popoverPresentationController];
            NSLog(@"cuowu");
        }
        if ([message containsString:@"真的要创建一个空的联系人"]) {
            
        }
        NSLog(@"好的被点击");
        
        
    }]];
UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    NSLog(@"取消了");
}];
    [alert addAction:cancelAction];
    [VC presentViewController:alert animated:YES completion:nil];
    
}
@end
