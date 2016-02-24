//
//  ViewController.m
//  ypj通讯录
//
//  Created by niit on 15/12/24.
//  Copyright © 2015年 ypj. All rights reserved.
//

#import "ViewController.h"
#import <Bmob.h>
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray* contact_personArr;
    NSMutableArray* contact_groupArr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    bmob添加数据方法
//    BmobObject *contactList = [BmobObject objectWithClassName:@"contactList"];
//    [contactList setObject:@"自己" forKey:@"name"];
//    [contactList setObject:@"15995080406" forKey:@"tel"];
//    
//    [contactList saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        NSLog(@"%@",isSuccessful?@"success":@"fail");
//    }];




}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark uitableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* idf = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:idf];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idf];
        
    }
    cell.imageView.image  = [UIImage imageNamed:@"add"];
    cell.textLabel.text = @"sss";
    cell.detailTextLabel.text =@"aaa";
    
    return cell;
}
@end
