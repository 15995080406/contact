//
//  PersonCenterTVC.m
//  ypj通讯录
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 ypj. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import <CoreLocation/CoreLocation.h>

#import "PersonCenterTVC.h"
@interface PersonCenterTVC ()<UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationmanager;

    NSArray* pickerViewArr;//更新频率
    UISwitch* myLoginSwitch;
    UILabel* lable2;
    NSArray* precisionArr;
    UILabel*  infoInServer;
    UILabel*  infoInLocal;
}
@property (nonatomic,strong) UIPickerView* issynchroize_contactpickview;

@end

@implementation PersonCenterTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ;
    //    [self initUiArray];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor colorWithRed:105/255.0 green:142/255.0 blue:197/255.0 alpha:1.0]];
    
    

    if ([[[UIDevice currentDevice]systemVersion]doubleValue]>8.0) {
        locationmanager = [[CLLocationManager alloc]init];

        [locationmanager requestAlwaysAuthorization];
        locationmanager.delegate = self;
        locationmanager.distanceFilter = 20;
        
#pragma mark 昨天遗留
    }else{
        [self showAlert:@"版本过低无法使用"];
    }
    
    pickerViewArr =@[@"1",@"2",@"5",@"10",@"30"];
    precisionArr = @[@"10米",@"50米",@"100米",@"1千米",@"3千米",@"省"];
}
 


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if(section == 1){
        if ([USERDEFAULT boolForKey:USER_ISSYNCHRONIZE_CONTACT]) {
            return 1;
        }
    }else if(section == 3){
        if ([USERDEFAULT boolForKey:USER_ISSHARE_MYCOORDINATE]) {
            return 1;
        }
    }
        
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, winwidth, 44)];
    [view setBackgroundColor:[UIColor whiteColor]];

    if (indexPath.section == 1) {
            UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, winwidth-120, 40)];
        if ([USERDEFAULT boolForKey:USER_ISSYNCHRONIZE_CONTACT]){
            //1组cell
            lable.text = @"同步频率";
            [view addSubview:lable];
            _issynchroize_contactpickview = [[UIPickerView alloc]initWithFrame:CGRectMake(winwidth-115, 0, 50, SectionHeight)];
            _issynchroize_contactpickview.delegate = self;
            _issynchroize_contactpickview.dataSource = self;
            for (int i = 0;i<pickerViewArr.count;i++) {
                if ([pickerViewArr[i] intValue] == [[USERDEFAULT objectForKey:USER_ISSYNCHRONIZE_CONTACT_FREQUENCY]intValue]) {
                    [_issynchroize_contactpickview selectRow:i inComponent:0 animated:YES];
                    NSLog(@"pickerview choose %i",[[USERDEFAULT objectForKey:USER_ISSYNCHRONIZE_CONTACT_FREQUENCY]intValue]);
                }
            }
            
            UILabel* daylable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_issynchroize_contactpickview.frame)+5, 0, 30, SectionHeight)];
            daylable.text = @"天";
            [daylable setFont:[UIFont systemFontOfSize:20]];
            [view addSubview:daylable];
            [view addSubview:_issynchroize_contactpickview];
            [view addSubview:lable];

            //是否能被选中
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if (indexPath.section == 3){
        UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 120, 40)];
        lable.text = @"位置精度";
        lable2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lable.frame), 5, 60, 40)];
        lable2.textAlignment = NSTextAlignmentRight;
        UISlider* slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lable2.frame), 5, 100, 40)];
        [slider addTarget:self action:@selector(changeCoordinatePrecision:) forControlEvents:UIControlEventValueChanged];
        slider.value = [USERDEFAULT floatForKey:USER_COORDINATE_PRECISION];

        [view addSubview:lable];
        [view addSubview:lable2];
        [view addSubview:slider];
        
    }

    
    [cell.contentView addSubview:view];
    return cell;
}


#pragma mark --section
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, winwidth, 44)];
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, winwidth-120, 40)];
    
    if (section == 0) {
        
        lable.text = @"自动登陆状态";
        myLoginSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(winwidth-115, 11, 30, 20)];
        [myLoginSwitch addTarget:self action:@selector(changeloginState) forControlEvents:UIControlEventValueChanged];
        myLoginSwitch.on = [USERDEFAULT boolForKey:USER_ISLOGINING];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view addSubview:myLoginSwitch];
        
    }else if(section==1){
        
        lable.text = @"自动上传联系人";
        UISwitch* uiswitch = [[UISwitch alloc]initWithFrame:CGRectMake(winwidth-115, 10, 30, 30)];
        uiswitch.on = [USERDEFAULT boolForKey:USER_ISSYNCHRONIZE_CONTACT];
        [uiswitch addTarget:self action:@selector(changesynchronizeState) forControlEvents:UIControlEventValueChanged];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view addSubview:uiswitch];
        
    }else if(section == 2){
        
        lable.text = @"自动同步联系人位置";
        UISwitch* uiswitch = [[UISwitch alloc]initWithFrame:CGRectMake(winwidth-115, 10, 30, 30)];
        uiswitch.on = [USERDEFAULT boolForKey:USER_ISSYNCHRONIZE_COORDINATE];
        [uiswitch addTarget:self action:@selector(changeSynchronizeCoordinateState) forControlEvents:UIControlEventValueChanged];
        [view addSubview:uiswitch];
        
    }else if(section==3){
        
        lable.text = @"共享我的位置";
        UISwitch* uiswitch  = [[UISwitch alloc]initWithFrame:CGRectMake(winwidth-115, 11, 30, 20)];
        [uiswitch addTarget:self action:@selector(isShareMyCoordinate) forControlEvents:UIControlEventValueChanged];
        uiswitch.on = [USERDEFAULT boolForKey:USER_ISSHARE_MYCOORDINATE];
        
        [view addSubview:uiswitch];
        
    }else if(section == 4){
        lable.text = @"服务器统计信息";
        infoInServer = [[UILabel alloc]init];
        [infoInServer setTranslatesAutoresizingMaskIntoConstraints:NO];
        infoInServer.text = [NSString stringWithFormat:@"%zi人，%zi组",[USERDEFAULT integerForKey:User_InfoInServer_AllCount],[USERDEFAULT integerForKey:User_InfoInServer_GroupCount]];
        infoInServer.textAlignment = NSTextAlignmentRight;
        [view addSubview:infoInServer];
        
        UIButton *setionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, winwidth, SectionHeight)];
        setionBtn.tag = 10001;
        [setionBtn addTarget:self action:@selector(refreshSeverInfo:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:setionBtn];
        
        NSArray* constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[infoInServer(==150)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(infoInServer)];
        NSArray* constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[infoInServer(==40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(infoInServer)];
        [view addConstraints:constraint];
        [view addConstraints:constraint2];
        
    }else if(section == 5){
        lable.text = @"本地统计信息";
        
        infoInLocal = [[UILabel alloc]init];
        [infoInLocal setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        infoInLocal.text = [NSString stringWithFormat:@"%zi人，%zi组",[USERDEFAULT integerForKey:USER_ALL_COUNT],[USERDEFAULT integerForKey:USER_GROUP_COUNT]];
        infoInLocal.textAlignment = NSTextAlignmentRight;
        [view addSubview:infoInLocal];
        
        UIButton *setionBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, winwidth, SectionHeight)];
        setionBtn2.tag = 10002;
        [setionBtn2 addTarget:self action:@selector(refreshSeverInfo:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:setionBtn2];

        NSArray* constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[infoInLocal(==150)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(infoInLocal)];
        NSArray* constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[infoInLocal(==40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(infoInLocal)];
        [view addConstraints:constraint];
        [view addConstraints:constraint2];
        
        
    }else if(section == 6){
        
        
        
    }else if(section == 7){
        lable.text = @"删除所有信息";
        UIButton* uiButton  = [[UIButton alloc]initWithFrame:CGRectMake(winwidth-115, 5, 50, 30)];
        [uiButton addTarget:self action:@selector(wipeAllInformation) forControlEvents:UIControlEventTouchUpInside];
        [uiButton setBackgroundColor:[UIColor redColor]];
        uiButton.titleLabel.text = @"删除";
        [view addSubview:uiButton];
        
    }else{
        
        lable.text = @"敬请期待";
    }
    
    [view addSubview:lable];
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
    
}


#pragma mark cell,section高度

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SectionHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SectionHeight;
}


#pragma mark 各种动作
//改变登陆状态
-(void)changeloginState{
    if (myLoginSwitch.on == YES) {
        [USERDEFAULT setBool:YES forKey:USER_ISLOGINING];
        [USERDEFAULT synchronize];
        NSLog(@"自动登录打开了");
    }else {

        [self performSelectorOnMainThread:@selector(showAlert:) withObject:nil waitUntilDone:YES];
    }


}


-(void)showAlert:(NSString*)str{
    UIAlertController* Alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"取消自动登录将删除所有个人设置" preferredStyle:UIAlertControllerStyleAlert];

    [Alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = str?str:@"请输入密码";
        //密码可见：关闭
        textField.secureTextEntry = YES;
        //观察textfield值改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];

    }];
    [Alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        myLoginSwitch.on = YES;
        NSLog(@"自动登录仍然打开");
    }]];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if ([Alert.textFields.lastObject.text isEqualToString:[USERDEFAULT objectForKey:USER_ISLOGINING_CANCELPASSWORD]]) {
            myLoginSwitch.on = NO;
            [USERDEFAULT setBool:NO forKey:USER_ISLOGINING];
            [USERDEFAULT synchronize];
//            删除USERDEFAULT所有信息
            NSDictionary *defaultsDictionary = [USERDEFAULT dictionaryRepresentation];
            for (NSString *key in [defaultsDictionary allKeys]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
            NSLog(@"自动登陆关闭了");
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            
        }else{
            [self showAlert:@"密码错误，请重新输入"];
        }
        
    }];
    
    okAction.enabled = NO;
    [Alert addAction:okAction];

    [self presentViewController:Alert animated:YES completion:nil];

    
}
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length > 2;
    }
}
//改变同步联系人状态
-(void)changesynchronizeState{
    [USERDEFAULT setBool:![USERDEFAULT boolForKey:USER_ISSYNCHRONIZE_CONTACT] forKey:USER_ISSYNCHRONIZE_CONTACT];
    [USERDEFAULT synchronize];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    //当同步联系人关闭时，同步频率界面消失
    if ([USERDEFAULT boolForKey:USER_ISSYNCHRONIZE_CONTACT]) {
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];

        [self.tableView endUpdates];
        
    }else{
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
//        NSLog(@"%li",self.tableView.visibleCells.count);
    }
    NSLog(@"自动同步联系人开关：%@了",[USERDEFAULT boolForKey:USER_ISSYNCHRONIZE_CONTACT]?@"开启":@"关闭");

}
#pragma mark pickview-data-source
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [USERDEFAULT setValue:pickerViewArr[row] forKey:USER_ISSYNCHRONIZE_CONTACT_FREQUENCY];
    [USERDEFAULT synchronize];
    
    NSLog(@"pickerView Change To %i",[[USERDEFAULT objectForKey:USER_ISSYNCHRONIZE_CONTACT_FREQUENCY]intValue]);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickerViewArr.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return pickerViewArr[row];
}
//自动更新联系人位置
-(void)changeSynchronizeCoordinateState{
    [USERDEFAULT setBool:![USERDEFAULT boolForKey:USER_ISSYNCHRONIZE_COORDINATE] forKey:USER_ISSYNCHRONIZE_COORDINATE];
    
    
    
    [USERDEFAULT synchronize];
    NSLog(@"自动更新联系人位置：%@了",[USERDEFAULT boolForKey:USER_ISSYNCHRONIZE_COORDINATE]?@"开启":@"关闭");

}
//改变定位精度
-(void)changeCoordinatePrecision:(UISlider*)slider{
    NSString* precision;
    float a = (float)precisionArr.count;
//    float a = a;//
    if (slider.value<(1/(2*(a-1)))) {
        slider.value = 0/(a-1);
        precision =precisionArr[0];
    } else if(slider.value>=1/(2*(a-1)) && slider.value<3/(2*(a-1))){
        slider.value = 1/(a-1);
        precision =precisionArr[1];

    }else if(slider.value >= 3/(2*(a-1)) && slider.value <5/(2*(a-1))){
        slider.value = 2/(a-1);
        precision =precisionArr[2];

    }else if(slider.value>=5/(2*(a-1)) && slider.value < 7/(2*(a-1))){
        slider.value = 3/(a-1);
        precision =precisionArr[3];

    }else if(slider.value>=7/(2*(a-1)) && slider.value < 9/(2*(a-1))){
        slider.value = 4/(a-1);
        precision =precisionArr[4];
        
    }else if(slider.value>=9/(2*(a-1))){
        slider.value = 5/(a-1);
        precision =precisionArr[5];
        
    }
    
    [USERDEFAULT setFloat:slider.value forKey:USER_COORDINATE_PRECISION];
    lable2.text = precision;
    
    NSLog(@"现在是%f",slider.value);
}
-(void)isShareMyCoordinate{
    [USERDEFAULT setBool:![USERDEFAULT boolForKey:USER_ISSHARE_MYCOORDINATE] forKey:USER_ISSHARE_MYCOORDINATE];
    [USERDEFAULT synchronize];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    
    if ([USERDEFAULT boolForKey:USER_ISSHARE_MYCOORDINATE]) {
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
    }else{
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    NSLog(@"共享我的位置开关：%@",[USERDEFAULT boolForKey:USER_ISSHARE_MYCOORDINATE]?@"开启":@"关闭");
    
}
#pragma mark 刷新服务器数据和自己的数据
-(void)refreshSeverInfo:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    BOOL isServer =btn.tag == 10001?YES:NO;//是否是服务器按钮
    if(isServer){
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"user_list"];
    //查找GameScore表里面id为0c6db13c的数据
        
    [bquery getObjectInBackgroundWithId:@"NQcVZZZi" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
            NSLog(@"%@",error);
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                int allcount = [[object objectForKey:@"user_all_count"] intValue];
                int groupCount = [[object objectForKey:@"user_group_count"]intValue];
//                infoInServer.text = [NSString stringWithFormat:@"%i人，%i组",allcount,groupCount];
//                NSLog(@"refresh server");
                [USERDEFAULT setInteger:allcount forKey:User_InfoInServer_AllCount];
                [USERDEFAULT setInteger:groupCount forKey:User_InfoInServer_GroupCount];
                [USERDEFAULT synchronize];
                [self.tableView reloadData];
            }
        }
    }];
    }else{
        NSLog(@"refresh Local");
        
    }

}

-(void)wipeAllInformation{
    NSLog(@"删除所有信息");
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults]dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }

    [USERDEFAULT synchronize];
    [self.tableView reloadData];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return NO;
//    } else if(indexPath.section ==1){
//        if (indexPath.row == 0) {
//            return YES;
//        }
//        return NO;
//    }
    return YES;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
     
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


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
@end
