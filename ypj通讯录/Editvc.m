//
//  Editvc.m
//  ypj通讯录
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import "Editvc.h"
#import "Group.h"
#import "ContactModel.h"
#import "FMDatabase.h"

extern FMDatabase *mydb;//要声明在.m文件中，否则inport多次后，会有多个重名对象，导致错误
extern int localId;

@interface Editvc ()<UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *myHeadButton;



@end

@implementation Editvc

-(void)awakeFromNib{
//此方法中不能对self赋值

}

-(instancetype)initWithContact:(ContactModel*)contact{
    if (self = [super init]) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        self = [sb instantiateViewControllerWithIdentifier:@"edit"];
        _mycontact = contact;
    }
        return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //    确定button的样式
    self.myCreatButtion.layer.cornerRadius = self.myCreatButtion.frame.size.width/2;
    [self.myCreatButtion setBackgroundColor:[UIColor orangeColor]];
    self.myCreatButtion.clipsToBounds = false;
    [self.myCreatButtion setTitle:@"确定" forState:UIControlStateNormal];
    
    self.myBirthClockSwitch.on = self.mycontact.myisRemind;
    self.myShareToOtherSwitch.on = self.mycontact.myisShareToHe;
    
    //    清空按钮
    self.myNameTF.clearButtonMode = UITextFieldViewModeAlways;
    self.myPersonTelTF.clearButtonMode = UITextFieldViewModeAlways;
    self.myCompanyTelTF.clearButtonMode = UITextFieldViewModeAlways;
    self.myGroupName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //    备注多行自适应
    
    
    
    
    //    设置各输入框默认值
    self.myNameTF.text = self.mycontact.myName;
    self.myPersonTelTF.text = self.mycontact.myPersonalTel;
    self.myCompanyTelTF.text = self.mycontact.myCompanyTel;
    self.myGroupName.text = self.mycontact.myGroupName;
    
    //    datepickerView
    NSDateFormatter* dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    self.myBirthdayDatePickerview.datePickerMode = UIDatePickerModeDate;
    
    NSDate * date =[dateformate dateFromString:self.mycontact.myBirthday];
    [self.myBirthdayDatePickerview setDate:date?date:[NSDate date]];
    self.myMarkTF.text = self.mycontact.mymark;
    [self.myHeadButton addTarget:self action:@selector(mychangeImage:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *headimage = [UIImage imageNamed:self.mycontact.myHeadImage?self.mycontact.myHeadImage:@"head_default"];
    [self.myHeadButton setBackgroundImage:headimage forState:UIControlStateNormal];
    
    [self getBirthdayStr];
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
} ;

- (IBAction)doneAction:(id)sender {
    if (self.mycontact) {

        if ([self mySaveContactWithSelf]) {
            
            
            [self myshowAlertWithTitle:nil andmessage:@"修改成功" withExistModel:nil];
        } ;
        return;
    }else{
        
        if (self.myNameTF.text.length == 0) {
            [self myshowAlertWithTitle:ALERT_TITLE_Attention andmessage:ALERT_MESSAGE_NullName withExistModel:nil];
        }else if([self myisExistNameInDB:self.myNameTF.text]){
            
            [self myshowAlertWithTitle:ALERT_TITLE_Attention andmessage:ALERT_MESSAGE_SameName withExistModel:nil];
        }else  if(self.myPersonTelTF.text.length == 0 && self.myCompanyTelTF.text.length == 0){
            [self myshowAlertWithTitle:ALERT_TITLE_Attention andmessage:ALERT_MESSAGE_BothTelIsNull withExistModel:nil];
            
        }else{
#warning 号码不合规则也可插入  需求：有一个联系人
            
            if ([self mySaveContactWithSelf]) {
                
                
                [self myshowAlertWithTitle:nil andmessage:ALERT_MESSAGE_AddSuccess withExistModel:nil];
            }
            
            
        }
    
    
    
    }
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)myshowAlertWithTitle:(NSString*)str andmessage:(NSString*)message withExistModel:(ContactModel*)existContact{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:str message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction;
    
    if ([message isEqualToString:ALERT_MESSAGE_AddSuccess]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"继续添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [self myResetAllInfo];
        }]];
        cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancelAction];

    }else if([message isEqualToString:ALERT_MESSAGE_NullName]){
        cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        
    }else if ([message isEqualToString:ALERT_MESSAGE_SameName]||[message isEqualToString:ALERT_MESSAGE_SameTel]){
        [alert addAction:[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //  把数据改成已存在的联系人
            Editvc* editVC = [[Editvc alloc]initWithContact:existContact];
            
            [self presentViewController:editVC animated:YES completion:nil];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"仍然添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self mySaveContactWithSelf];
            
        }]];
        cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];

    }else if ([message isEqualToString:ALERT_MESSAGE_BothTelIsNull]){
         [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             
             if ([self mySaveContactWithSelf]) {
                     [self myshowAlertWithTitle:ALERT_TITLE_Attention andmessage:ALERT_MESSAGE_AddSuccess withExistModel:nil];
                 }
                 
         }]];
        cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
    }else if([message isEqualToString:ALERT_MESSAGE_BothTelIsNull] ){
        [alert addAction:[UIAlertAction actionWithTitle:@"仍然添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self mySaveContactWithSelf];
            
        }]];
        cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        
    }else{
        cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        [alert addAction:cancelAction];
        
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

//保存数据
-(BOOL)mySaveContactWithSelf{
    BOOL a;
    ContactModel* contact = [self myCreatAContactWithEditVCInPut];
//如果有contact则更新数据，没有则保存
    if(self.mycontact ){
        
      a=  [contact myUpDataSelfInMYDB];
        return a;
    }
    
    a = [contact insertModelToDatebaseWithSelf];
    return a;
}
//-(void)
-(ContactModel*)myCreatAContactWithEditVCInPut{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    NSString *birthday = [formatter stringFromDate:self.myBirthdayDatePickerview.date];
    
    ContactModel* contact = [ContactModel initWithName:self.myNameTF.text
                                      andPersonalTel:self.myPersonTelTF.text
                                       andCompanyTel:self.myCompanyTelTF.text
                                            andPlace:@"地球上"
                                         andBirthday:birthday
                                        andGroupName:self.myGroupName.text
                                             andMark:self.myMarkTF.text
                                         andIsRemind:self.myBirthClockSwitch.on
                                      andIsShareToHe:self.myShareToOtherSwitch.on
                                                                         andIsCollection:0];
    contact.mylocalId = self.mycontact.mylocalId;
    return contact;
}


-(void)myResetAllInfo{
    self.myNameTF.text =nil;
    self.myPersonTelTF.text = nil;
    self.myCompanyTelTF.text = nil;
    self.myGroupName.text = nil;
    self.myBirthdayDatePickerview.date = [NSDate date];
    self.myBirthClockSwitch.on = NO;
    self.myShareToOtherSwitch.on = NO;
    self.myMarkTF.text = nil;
}
#pragma mark -数据库操作
//判断DB中是否存在同名联系人
-(BOOL)myisExistNameInDB:(NSString*)string{
    BOOL a = NO;
    NSArray* contactAll = [Group myLoadAllContactFromDbWithbacktype:BACK_TYPE_ALL];
    
    for (ContactModel* dataContact in contactAll) {
        if ([string isEqualToString:dataContact.myName]) {
            a = YES;
        }
    }
    return a;
}


-(NSString*)getBirthdayStr{
    //    NSString* resultStr ;
    //    NSLog(@"%@",self.myBirthdayDatePickerview.date);
    //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDateComponents *comps = [[NSDateComponents alloc]init];
    //    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |
    //    NSDayCalendarUnit
    ////    |
    //    NSWeekdayCalendarUnit |
    //    NSHourCalendarUnit |
    //    NSMinuteCalendarUnit |
    //    NSSecondCalendarUnit
    ;
    //    comps = [calendar components:unitFlags fromDate:self.myBirthdayDatePickerview.date];
    ////    int week = (int)[comps weekday];
    //    int year=(int)[comps year];
    //    int month = (int)[comps month];
    //    int day = (int)[comps day];
    NSDateFormatter* dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy:MM:dd"];
    
    NSString* dateStr = [dateformate stringFromDate:self.myBirthdayDatePickerview.date];
    
//    NSLog(@"返回pickerview日期%@",dateStr);
    return dateStr;
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)mychangeImage:(id)sender{
    __block NSUInteger sourceType = 0;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择照片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"从相册选择");
        
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self chooseImage:sourceType];
        
        
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"拍照");
        
        
        //因为模拟器不支持拍照功能 所以需要判断是否支持拍照功能
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            [self chooseImage:sourceType];
        }else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你的手机不支持拍照功能 换了吧..." preferredStyle:UIAlertControllerStyleAlert];
            
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"没钱" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            }
        
        
    }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    [self.myHeadButton setBackgroundImage:image forState:UIControlStateNormal];
    
//self.mycontact.myHeadImage = image.
    
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    NSLog(@"%@",[info objectForKey:UIImagePickerControllerReferenceURL]);
//
//}

- (void)chooseImage:(NSUInteger)sourcetype{
    //1.创建UIImagePickerController对象
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //2.设置代理
    imagePickerController.delegate = self;
    //3.是否允许图片编辑
    imagePickerController.allowsEditing = NO;
    //4.设置是选择图片还是开启照相机
    imagePickerController.sourceType = sourcetype;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    return;
//}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
//只判断是否合法
+ (BOOL )valiMobile:(NSString *)mobile{
//    if(mobile.length == 0){
//        NSLog(@"长度为%zi",mobile.length);
//        return YES;
//    }else if (mobile.length < 11){
//        NSLog(@"少于11位");
//        return NO;
//    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
        
//    }
//    return YES;
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
