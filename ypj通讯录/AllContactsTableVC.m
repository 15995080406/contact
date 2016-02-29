//
//  AllContactsTableVC.m
//  ypj通讯录
//
//  Created by niit on 16/1/14.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import "AllContactsTableVC.h"
#import "Editvc.h"
#import "ContactModel.h"
#import "Group.h"
#import "AllTbaleViewCell.h"
#import "DropDownListView.h"
#import "DropDownChooseProtocol.h"
#import <QuartzCore/QuartzCore.h>
#import "TestVC.h"
@interface AllContactsTableVC ()
@end

@implementation AllContactsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.myAllcontacts = [Group myLoadAllGroupFromDbWithbacktype:USER_TYPE_ALL];
 }

-(NSMutableArray *)myAllcontacts{
    if (_myAllcontacts ==nil||[USERDEFAULT boolForKey:USER_ISALLRELOADDATA]) {
        [USERDEFAULT removeObjectForKey:USER_NOTIFICATION_ALLCHANGE];
        _myAllcontacts = [Group myLoadAllContactFromDbWithbacktype:BACK_TYPE_ALL];
    }
    return _myAllcontacts;
}

- (IBAction)addAction:(id)sender {

    Editvc* editvc = [[Editvc alloc]initWithContact:nil];
    
      [self presentViewController:editvc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return self.myAllcontacts.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.myAllcontacts.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllTbaleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allcontact"];
    ContactModel* model = self.myAllcontacts[indexPath.row];

//    cell.backgroundView.layer.cornerRadius = 1.0f;
    if (!cell ) {
        cell = [[AllTbaleViewCell alloc]initWithcontact:model];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0,0,cell.frame.size.width,cell.frame.size.height)];
    container.layer.cornerRadius = 8.0;

    return cell;
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Editvc* editVc = [[Editvc alloc]initWithContact:self.myAllcontacts[indexPath.row]];
    [self presentViewController:editVc animated:YES completion:nil];
    
    

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

//添加该方法左划会出现红色的delete 该方法主要用于提交操作

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactModel *contact = self.myAllcontacts[indexPath.row];
    //判断呢操作类型 执行不同的代码段
    if(editingStyle ==  UITableViewCellEditingStyleDelete){
        NSLog(@"执行删除操作");
        //删除数据源
        [self.myAllcontacts removeObject:contact];


            if ([contact deletModelInDBWithLocalId:contact.mylocalId]) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:ALERT_MESSAGE_DeleteSuccess preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [USERDEFAULT setBool:YES forKey:USER_ISALLRELOADDATA];
                    [USERDEFAULT setBool:YES forKey:USER_ISGROUPRELOADDATA];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            
            
            }
     
        
        //只刷新局部
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        //如果分组中没有联系人了 删除分组
        if(self.myAllcontacts.count==0){
            [self.myAllcontacts removeObject:contact];
            [tableView reloadData];
            
        }
    }else{
        NSLog(@"执行添加操作");

        //刷新section
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        
    }
    
    
    
}








/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}
@end
