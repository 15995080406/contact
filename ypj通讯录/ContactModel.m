//
//  ContactModel.m
//  ypj通讯录
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 ypj. All rights reserved.
//

#import "ContactModel.h"
#import "FMDatabase.h"
extern FMDatabase *mydb;
@implementation ContactModel


+(instancetype)initWithName:(NSString*)name
             andPersonalTel:(NSString*)personaltelString
              andCompanyTel:(NSString*)companyTelString
                   andPlace:(NSString*)place
                andBirthday:(NSString*)birthday
               andGroupName:(NSString*)groupname
                    andMark:(NSString*)mark
                andIsRemind:(BOOL)isremind
             andIsShareToHe:(BOOL)issharetohe
            andIsCollection:(BOOL)iscollection
{
    ContactModel* contact = [[ContactModel alloc]init];
    contact.myName = name;
    contact.myPersonalTel = personaltelString;
    contact.myCompanyTel = companyTelString;
    contact.myPlace = place;
    contact.myBirthday = birthday;
    contact.myGroupName = groupname;
    contact.mymark = mark;
    contact.myisRemind = isremind;
    contact.myisShareToHe =issharetohe;
    contact.myiscollection = iscollection;
    
    return contact;
}

-(void)openDB{
    
    if (![mydb open]) {
        
        NSLog(@"数据库打开失败");
    }else{
        [self creatMyTable];
        NSLog(@"数据库打开成功");
    }
}

-(void)creatMyTable{
    
    [mydb executeUpdate:@"create table if not exists mycontact(localId integer PRIMARY KEY AUTOINCREMENT,name text,personaltel text,companytel text,birthday text,place text,mark text,groupname text,isremind integer,issharetohe integer,iscollection integer)"];
//    autoincrement primary key not null
}

-(BOOL)insertModelToDatebaseWithSelf{
    [self openDB];
        
    NSString* insertstr = [NSString stringWithFormat:@"insert into mycontact (name,personaltel,companytel,birthday,place,groupname,mark,isremind,issharetohe,iscollection) values ('%@','%@','%@','%@','%@','%@','%@','%i','%i','%i')",self.myName,self.myPersonalTel,self.myCompanyTel,self.myBirthday,self.myPlace,self.myGroupName?self.myGroupName:@"未分组",self.mymark,self.myisRemind,self.myisShareToHe,self.myiscollection];
    [USERDEFAULT setBool:YES forKey:USER_ISALLRELOADDATA];
    [USERDEFAULT setBool:YES forKey:USER_ISGROUPRELOADDATA];

       BOOL a = [mydb executeStatements:insertstr];
    return a;
}

-(BOOL)deletModelInDBWithLocalId:(int)localId{
    [mydb open];
    
    NSString* delet = [NSString stringWithFormat:@"delete from mycontact where localId=%i ", localId ];
    BOOL a = [mydb executeStatements:delet];
    [mydb close];
    return  a;
}


+(NSString*)mychangeToStringWithArr:(NSArray*)arr{
    NSString* str;
    for (NSString* strInArr in arr) {
        str = [str stringByAppendingString:@","];
        str = [str stringByAppendingString:strInArr];
    }
    return str;
}

+(NSArray*)mychangeToArrWithString:(NSString*)str{
    NSArray* arr = [str componentsSeparatedByString:str];
    return arr;
}

//更新localid对应的数据
-(BOOL)myUpDataSelfInMYDB{
    [mydb open];
//    name,personaltel,companytel,birthday,place,groupname,mark,isremind,issharetohe,iscollection
    NSString* upDateString = [NSString stringWithFormat:@"update mycontact set name='%@',personaltel='%@',companytel='%@',birthday='%@',place='%@',groupname='%@',mark='%@',isremind=%i,issharetohe=%i,iscollection=%i where localId=%i",self.myName,self.myPersonalTel,self.myCompanyTel,self.myBirthday,self.myPlace,self.myGroupName,self.mymark,self.myisRemind,self.myisShareToHe,self.myiscollection,self.mylocalId];
    BOOL a;
   a = [mydb executeUpdate:upDateString];
    [mydb close];
    return a;
    
}

@end
