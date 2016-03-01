//
//  GroupTableVC.m
//  ypj通讯录
//
//  Created by niit on 15/12/25.
//  Copyright © 2015年 ypj. All rights reserved.
//

#import "GroupTableVC.h"
#import "Editvc.h"
#import "Bmob.h"
#import "FMDatabase.h"
#import "ContactModel.h"
#import "SectionView.h"
#import "Group.h"
#import "UIImageView+WebCache.h"

#define TAG_SECTIONVIEW_START 3000
#define TAG_SECTIONBUTTON_START 1000

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define ImageWidth 13

typedef void (^modify) (NSString*);
extern FMDatabase* mydb;
@interface GroupTableVC ()
{
//    NSMutableArray* changeArr;
}
@end

@implementation GroupTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [USERDEFAULT setBool:YES forKey:USER_ISGROUPRELOADDATA];
    [self.tableView setBackgroundColor:BackGroundColor];
//    changeArr = [[NSMutableArray alloc]init];
//    changeArr = [self.mygroupArr mutableCopy];
//    
    
}

-(NSMutableArray *)mygroupArr{
    BOOL a = [USERDEFAULT boolForKey:USER_ISGROUPRELOADDATA];
    if (a == YES) {
        [USERDEFAULT setBool:NO forKey:USER_ISGROUPRELOADDATA];
        
    }
    if (a == YES) {
        
        _mygroupArr =[Group myLoadAllContactFromDbWithbacktype:BACK_TYPE_GROUP];
        
    }
    return _mygroupArr;
}

-(void)viewWillAppear:(BOOL)animated{
    BOOL a =[USERDEFAULT boolForKey:USER_ISGROUPRELOADDATA];
    if (a) {
        [self.tableView reloadData];//同时刷新了箭头动画，不行

    }

//    NSMutableArray  *allcell = [NSMutableArray array];
//    for (int section = 0; section<self.mygroupArr.count; section++) {
//        for (int row = 0; row<[[self.mygroupArr[section] myContactArr] count]; row++) {
//            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:section];
//            [allcell addObject:indexpath];
//        }
//    }
//    [self.tableView reloadRowsAtIndexPaths:allcell withRowAnimation:UITableViewRowAnimationNone];
#warning  仅仅刷新视图不刷新数据？
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mygroupArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Group* currentgroup = self.mygroupArr[section];
    
    if (currentgroup.myisopen ==NO) {
        return 0;
    }
    return currentgroup.myContactArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* idf = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:idf];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idf];
    }
    Group* group = self.mygroupArr[indexPath.section];
    
    
    ContactModel* model = group.myContactArr[indexPath.row];
    UIImage *image = [UIImage imageNamed:model.myHeadImage?model.myHeadImage:@"head_default.png"];
    cell.imageView.image  =[self OriginImage:image scaleToSize:CGSizeMake(image.size.width/8*5, image.size.height/8*5)] ;
    
    cell.textLabel.text = model.myName;
    [cell setBackgroundColor:[UIColor clearColor]];//先设置cell底层背景色为空，圆角属性才可见
    
    //contentview 和backgroundview 区别
    UIView *cellBackgroundview = [[UIView alloc]initWithFrame:cell.frame];
    cellBackgroundview.layer.cornerRadius = 10;
    [cellBackgroundview setBackgroundColor:[UIColor whiteColor]];
    
    [cell setBackgroundView:cellBackgroundview];
    cell.detailTextLabel.text = model.myPersonalTel;
    
    UIButton* callButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [callButton setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = callButton;
    
    return cell;
}

//组名视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    Group* group = self.mygroupArr[section] ;
    SectionView* sectionView = [SectionView initWithGroupname:group.myname andOnlineNumber:0 andAllNumber:(int)group.myContactArr.count];
    sectionView.tag = section+TAG_SECTIONVIEW_START;
    //    点击分组动作----打开与关闭分组
    UIButton* button = [[UIButton alloc]initWithFrame:sectionView.frame];
    button.tag = (int)section+TAG_SECTIONBUTTON_START;
    //    button设置组名（过长会遮盖在线人数）
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:group.myname forState:UIControlStateNormal] ;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(changeisopen:) forControlEvents:UIControlEventTouchUpInside];
    //    长按动作----编辑组名
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longGesture.minimumPressDuration = 1;//最小长按时间
    longGesture.allowableMovement = 100;
    [button addGestureRecognizer:longGesture];
    
    //    分组箭头
    UIImageView* imageview = [[UIImageView alloc]init ];
//    [imageview setImage:[UIImage imageNamed:@"right.png"]];
    [imageview setImage:[UIImage imageNamed:group.myisopen == YES ? @"down.png":@"right.png"]];
    imageview.tag = 4000+section;
    CGFloat imageviewY = (USER_SECTIONHIGH-ImageWidth)/2;
    [imageview setFrame:CGRectMake(10, imageviewY, ImageWidth, ImageWidth)];
    //   button 文本距离自身输入框边界
    button.titleEdgeInsets = UIEdgeInsetsMake(0, CGRectGetMaxX(imageview.frame)+5, 0, 0);
    
    [sectionView addSubview:button];
    [sectionView addSubview:imageview];
    
    return sectionView;
}



-(void)changeisopen:(id)sender{
    
    UIButton* btn = (UIButton*)sender;
    
    int section = (int)btn.tag-TAG_SECTIONBUTTON_START;
    Group* currentGroup = self.mygroupArr[section];
    
    [currentGroup setMyisopen:!currentGroup.myisopen];
    SectionView* currentSectionView;
    for (UIView*view in [self.tableView subviews]) {
        if (view.tag == TAG_SECTIONVIEW_START+section) {
            currentSectionView = (SectionView*)view;
        }
    }
    
    if (currentSectionView) {
        UIImageView* currentIv;
        for (currentIv in [currentSectionView subviews]) {
            if (currentIv.tag == 4000+section) {
                if (currentGroup.myisopen == YES) {

                    [UIView animateWithDuration:0.3 animations:^{
                        currentIv.transform = CGAffineTransformRotate(currentIv.transform, DEGREES_TO_RADIANS(90));
                        NSMutableArray *arr = [NSMutableArray array];
                        
                        for (int i = 0 ; i < currentGroup.myContactArr.count ; i++) {
                            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:section];
                            [arr addObject:indexpath];
                        }
                        [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
                        
                    } completion:^(BOOL finished) {
                        if (finished) {
                        }
                    }];
                }else{
                    

                    [UIView animateWithDuration:0.3 animations:^{
                        currentIv.transform = CGAffineTransformRotate(currentIv.transform, DEGREES_TO_RADIANS(-90));
                        NSMutableArray *arr = [NSMutableArray array];
                        
                        for (int i = 0 ; i < currentGroup.myContactArr.count ; i++) {
                            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:section];
                            [arr addObject:indexpath];
                        }

                        [self.tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
                    } completion:^(BOOL finished) {
                        
                    }];

                }
            }
        }
    }
    
    
}

-(void)call:(UIButton*)button{
    
    
    
    
    
    
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longGesture{
    NSLog(@"long press...");
    
    CGPoint touchPoint = [longGesture locationInView:self.tableView];
    
    NSIndexPath* indexpath = [self.tableView indexPathForRowAtPoint:touchPoint];
    NSArray* arr = [self.mygroupArr[indexpath.section] myContactArr];
    
    if (longGesture.state==UIGestureRecognizerStateBegan) {
        
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"你想要修改组名吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* addAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField* tf =  [alert.textFields firstObject];
            for (ContactModel* model in arr) {
                model.myGroupName = tf.text;
                int i =0;
                if (i == arr.count-1) {
                    [USERDEFAULT setBool:YES forKey:USER_ISGROUPRELOADDATA];
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];

                }
                if ([model myUpDataSelfInMYDB]) {
                    i++;
                }
            }
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"取消");
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入新组名";
            //密码可见：关闭
            textField.secureTextEntry = NO;
            //观察tf值改变
            textField.clearButtonMode = UITextFieldViewModeAlways;
            
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:addAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if(longGesture.state==UIGestureRecognizerStateChanged){
        NSLog(@"长按状态改变");
    }else if (longGesture.state==UIGestureRecognizerStateEnded){
        NSLog(@"长按结束");
    }else if (longGesture.state==UIGestureRecognizerStateCancelled){
        NSLog(@"长按取消");
    }
    
}

//cell跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    Group* group = self.mygroupArr[indexPath.section];
    ContactModel* model = group.myContactArr[indexPath.row];
    Editvc* editVC = [[Editvc alloc]initWithContact:model];
    [self presentViewController:editVC animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//注册到bmob
-(void)testInsertToBomb{
    BmobObject* insert = [BmobObject objectWithoutDatatWithClassName:@"user_15995080406_list" objectId:@""];
    [insert addObjectsFromArray:@[@"1234623135",@"1231465432"] forKey:@"user_telarr"];
    [insert updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"insert success");
        }else
            NSLog(@"%@",error);
    }];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [self.tableView reloadData];
//    
//}
//返回所有数据


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return USER_SECTIONHIGH;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//}
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(4, 4, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
@end
