//
//  Group.h
//  ypj通讯录
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BACK_TYPE_GROUP @"group"
#define BACK_TYPE_ALL @"all"

@interface Group : NSObject
@property (nonatomic, copy) NSString* myname;
@property (nonatomic,assign)BOOL myisopen;
@property (nonatomic, copy) NSMutableArray* myContactArr;


//在所有字段中搜索相关内容
//- (NSMutableArray* )mysearchWithString:(NSString*)str;

//加载所有分组，以及组内联系人
+(NSMutableArray*)myLoadAllContactFromDbWithbacktype:(NSString*)bactype;

+ (NSMutableArray* )mysearchWithString:(NSString*)str;


@end
