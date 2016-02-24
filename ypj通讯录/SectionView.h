//
//  SectionView.h
//  ypj通讯录
//
//  Created by niit on 16/1/11.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import <UIKit/UIKit.h>
#define USER_SECTIONHIGH 40

@class  Group;
@interface SectionView : UIView

@property (nonatomic, copy) Group* mygroup;

+(instancetype)initWithGroupname:(NSString*)groupName andOnlineNumber:(int)onlineNumber andAllNumber:(int)allNumber;

@end
