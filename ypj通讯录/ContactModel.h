//
//  ContactModel.h
//  ypj通讯录
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 ypj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^returnBlock)(BOOL i);

@interface ContactModel : NSObject

@property (nonatomic, copy) NSString* myName;
@property (nonatomic, copy) NSString* myPersonalTel;
@property (nonatomic, copy) NSString* myCompanyTel;
@property (nonatomic, copy) NSString* myBirthday;
@property (nonatomic, copy) NSString* myPlace;
@property (nonatomic, copy) NSString* myGroupName;
@property (nonatomic, copy) NSString* mymark;
@property (nonatomic, copy) NSString* myHeadImage;

@property (nonatomic, assign) int mylocalId;

@property (nonatomic, assign) BOOL myiscollection;
@property (nonatomic, assign) BOOL myisRemind;
@property (nonatomic, assign) BOOL myisShareToHe;


+(instancetype)initWithName:(NSString*)name
             andPersonalTel:(NSString*)personaltelString
              andCompanyTel:(NSString*)companyTelString
                   andPlace:(NSString*)place
                andBirthday:(NSString*)birthday
               andGroupName:(NSString*)groupname
                    andMark:(NSString*)mark
                andIsRemind:(BOOL)isremind
             andIsShareToHe:(BOOL)issharetohe
            andIsCollection:(BOOL)iscollection;


-(BOOL)insertModelToDatebaseWithSelf;

-(BOOL)myUpDataSelfInMYDB;

+(NSString*)mychangeToStringWithArr:(NSArray*)arr;

+(NSArray*)mychangeToArrWithString:(NSString*)str;
/**
 *  删除数据库中对应id
 *
 *  @param localId 账号对应的表中id
 *
 *  @return 成功与否
 */
-(BOOL)deletModelInDBWithLocalId:(int)localId;

@end
