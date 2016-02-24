//
//  Header.h
//  ypj通讯录
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 ypj. All rights reserved.
//

#ifndef Header_h
#define Header_h


#define winheight [UIScreen mainScreen].bounds.size.height
#define winwidth [UIScreen mainScreen].bounds.size.width
#define USERDEFAULT [NSUserDefaults standardUserDefaults]

#define SectionHeight 50



#define USER_NOTIFICATION_RELOAD @"reload"
#define USER_NOTIFICATION_ALLCHANGE @"allchanged"
#define USER_NOTIFICATION_GROUPCHANGE @"groupchanged"


#define USER_FONT_GROUPNAME 20
#define USER_FONT_GROUPNUMBER 20


#define USER_LATITUDE @"user_latitude"  //经
#define USER_LONGITUDE @"user_longitude"//纬
#define USER_COORDINATE_PRECISION @"user_coordinate_precision"//定位精度


#define USER_ISALLRELOADDATA @"user_isallReloadData"//所有联系人界面是否刷新过
#define USER_ISGROUPRELOADDATA @"user_isgroupReloadData"//分组界面数据是否刷新过
#define USER_ISLOGINING @"user_islogining"//登陆状态
#define USER_ISLOGINING_CANCELPASSWORD @"user_islogining_cancelPassword"//关闭登陆状态的密码
#define USER_ISSYNCHRONIZE_CONTACT @"user_issynchronize_contact"//是否同步联系人
#define USER_ISSYNCHRONIZE_CONTACT_FREQUENCY @"user_issynchronize_contact_frequency"//同步频率(NSString)
#define USER_ISSYNCHRONIZE_COORDINATE   @"user_issynchronize_coordinate"// 是否自动更新联系人位置
#define USER_ISSHARE_MYCOORDINATE @"user_isshare_mycoordinate"//是否共享我的位置

/**
 * key of the user list
 *
 */
//#define <#macro#>
#define USER_TEL @"user_tel"
#define USER_PASSWORD @"user_password"
#define USER_OBJECTID @"objectId"
#define USER_CONTACT_LIST_NAME @"user_contact_list_name"
#define USER_GROUP_COUNT @"user_group_count"
#define USER_ALL_COUNT @"user_all_count"
#define USER_PLACE @"user_place"
//#define USER_


#define User_InfoInServer_AllCount @"user_infoInServer_allCount"//服务器总人数
#define User_InfoInServer_GroupCount @"user_infoInServer_groupCount"//服务器组数


#define ALERT_TITLE_Attention @"注意"

#define ALERT_MESSAGE_NullName @"姓名不能为空"
#define ALERT_MESSAGE_BothTelIsNull @"真的创建没有电话的联系人吗"
#define ALERT_MESSAGE_DeleteSuccess @"删除成功"
#define ALERT_MESSAGE_AddSuccess @"添加成功"
#define ALERT_MESSAGE_SameName @"存在同名联系人"
#define ALERT_MESSAGE_SameTel @"存在同号联系人"
#endif /* Header_h */
