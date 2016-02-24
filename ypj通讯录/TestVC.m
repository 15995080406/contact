//
//  TestVC.m
//  ypj通讯录
//
//  Created by niit on 16/1/28.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import "TestVC.h"

@interface TestVC ()

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];


}
- (instancetype)init
{
    self = [super init];
    if (self) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self = [sb instantiateViewControllerWithIdentifier:@"test"];
    }
    return self;
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

@end
