//
//  SectionView.m
//  ypj通讯录
//
//  Created by niit on 16/1/11.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import "SectionView.h"
#import "FMDatabase.h"
#import "ContactModel.h"
extern FMDatabase* mydb;
@implementation SectionView

+ (instancetype)initWithGroupname:(NSString*)groupName andOnlineNumber:(int)onlineNumber andAllNumber:(int)allNumber{

    SectionView *tempView= [[SectionView alloc]initWithFrame:CGRectMake(0, 0, winwidth, USER_SECTIONHIGH)];
    [tempView setBackgroundColor:[UIColor redColor]];
//    UILabel* groupNamelable = [[UILabel alloc]init];

//    CGSize groupSize=[groupName  sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:USER_FONT_GROUPNAME]}];
    
//    [groupNamelable setFrame:CGRectMake(20, 10, groupSize.width, groupSize.height)];
//    [groupNamelable setTextColor:[UIColor blackColor]];
//    groupNamelable.text = groupName;
//

    UILabel* numberLable = [[UILabel alloc]init];
//    数字自适应长宽
    CGSize numberSize = [[NSString stringWithFormat:@"%i/%i",onlineNumber,allNumber] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:USER_FONT_GROUPNUMBER]}];
    CGFloat numberY = (USER_SECTIONHIGH-numberSize.height)/2;
    [numberLable setFrame:CGRectMake(winwidth-numberSize.width,numberY, numberSize.width,numberSize.height)];
    [numberLable setTextColor:[UIColor blackColor]];
    
    numberLable.text =[NSString stringWithFormat:@"%i/%i",onlineNumber,allNumber];
    
//    [tempView addSubview:groupNamelable];
    [tempView addSubview:numberLable];
    
    tempView.layer.cornerRadius = 10;
    return tempView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
