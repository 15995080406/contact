//
//  Group.m
//  ypj通讯录
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import "Group.h"
#import "ContactModel.h"
#import "FMDatabase.h"




FMDatabase* mydb;
@implementation Group
-(NSMutableArray *)myContactArr{
    if (_myContactArr == nil) {
        _myContactArr = [NSMutableArray array];
    }
    return _myContactArr;
}


+(void)initialize{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *paths = [path stringByAppendingString:@"/mydb.db"] ;
    
    mydb = [FMDatabase databaseWithPath:paths];
    
    NSLog(@"group 中%@",paths);
    
}


+(instancetype)initWithname:(NSString* )groupName andContactModelArr:(NSArray*)arr{
    Group* groupModel = [[Group alloc]init];
    groupModel.myname = groupName;
    [groupModel.myContactArr addObjectsFromArray:arr];
    
    return groupModel;
}

//根据输入
+(NSMutableArray*)myLoadAllContactFromDbWithbacktype:(NSString*)backtype{
    [mydb open];
    
//    mydb 
    NSMutableArray* contactArr = [[NSMutableArray alloc]init];
    NSMutableArray* resultArr = [[NSMutableArray alloc]init];

    NSString *searchSql = [NSString stringWithFormat:@"select * from mycontact"];
    FMResultSet *set = [mydb executeQuery:searchSql];
    while ([set next]) {
        
        //        构建返回数据
        NSString* myname = [set stringForColumn:@"name"];
        NSString* mypersonalTelStr = [set objectForColumnName:@"personaltel"];
        NSString* mycompanyTelStr = [set objectForColumnName:@"companytel"];
        NSString* mybirthday = [set stringForColumn:@"birthday"];
        NSString* mygroupName = [set stringForColumn:@"groupname"];
        NSString* myplace = [set stringForColumn:@"place"];
        NSString* mymark = [set stringForColumn:@"mark"];
        
        NSInteger myisremind = [set intForColumn:@"isremind"];
        NSInteger myissharetohe = [set intForColumn:@"issharetohe"];
        NSInteger myiscollection =(NSInteger) [set intForColumn:@"iscollection"];
        int mylocalId =[set intForColumn:@"localId"];
        ContactModel *contact = [ContactModel initWithName:myname
                                            andPersonalTel:mypersonalTelStr
                                             andCompanyTel:mycompanyTelStr
                                                  andPlace:myplace
                                               andBirthday:mybirthday
                                              andGroupName:mygroupName
                                                   andMark:mymark
                                               andIsRemind:myisremind
                                            andIsShareToHe:myissharetohe
                                           andIsCollection:myiscollection];
        contact.mylocalId =(int)mylocalId;
        [contactArr addObject:contact];
    }
    [mydb close];
    
    if ([backtype isEqualToString:BACK_TYPE_ALL]) {
//        返回所有人数组
        [mydb close];
        return contactArr;
        
    }else if([backtype isEqualToString:BACK_TYPE_GROUP]){
//     返回分好组的数组
        NSArray* groupNameArr;
        NSMutableDictionary* groupNameDic = [NSMutableDictionary dictionary];
        
        //    利用字典去重
        for (ContactModel* model in contactArr) {
            [groupNameDic setValue:model.myGroupName forKey:model.myGroupName];
        }
        groupNameArr = [groupNameDic allKeys];
        //把联系人分组
        for (int i = 0; i < groupNameArr.count; i++) {
            NSString* str = groupNameArr[i];
            
            Group* group = [[Group alloc]init];
            group.myname = str;
            if ([str isEqualToString:@""]) {
                group.myname =@"未分组";
            }
            for (ContactModel* inModel in contactArr) {
                
                if ([inModel.myGroupName isEqualToString:str]) {
                    
                    [group.myContactArr addObject:inModel];
                }
            }
            [resultArr addObject:group];
        }

    }else if ([backtype isEqualToString:BACK_TYPE_COLLECTION]){
//        返回收藏的联系人数组
        for (ContactModel *model5 in contactArr) {
            if (model5.myiscollection) {
                [resultArr addObject:model5];
            }
        }
    }
    
       return resultArr;
}

//搜索
+ (NSMutableArray* )mysearchWithString:(NSString*)str
{
    [mydb open];
    NSMutableArray* backArray = [NSMutableArray array];

    NSString* searchSql =[NSString stringWithFormat:@"select * from mycontact where name like '%%%@%%' or tel like '%%%@%%' or birthday like '%%%@%%' or groupname like '%%%@%%' or place like '%%%@%%' ",str,str,str,str,str];

    FMResultSet* set = [mydb executeQuery:searchSql];
    while ([set next]) {
//        构造返回的对象
        NSString* myname = [set stringForColumn:@"name"];
        NSString* mypersonalTelStr = [set objectForColumnName:@"personaltel"];
        NSString* mycompanyTelStr = [set objectForColumnName:@"companytel"];
        NSString* mybirthday = [set stringForColumn:@"birthday"];
        NSString* mygroupName = [set stringForColumn:@"groupname"];
        NSString* myplace = [set stringForColumn:@"place"];
        NSString* mymark = [set stringForColumn:@"mark"];
        NSInteger myisremind = [set intForColumn:@"isremind"];
        NSInteger myissharetohe = [set intForColumn:@"issharetohe"];
        NSInteger myiscollection =(NSInteger) [set intForColumn:@"iscollection"];
        int mylocalId =[set intForColumn:@"localId"];
        ContactModel *contact = [ContactModel initWithName:myname
                                            andPersonalTel:mypersonalTelStr
                                             andCompanyTel:mycompanyTelStr
                                                  andPlace:myplace
                                               andBirthday:mybirthday
                                              andGroupName:mygroupName
                                                   andMark:mymark
                                               andIsRemind:myisremind
                                            andIsShareToHe:myissharetohe
                                           andIsCollection:myiscollection];
        contact.mylocalId = (int)mylocalId;
        [backArray addObject:contact];
    }
    [mydb close];
    return backArray;
}




@end
