//
//  MyCollectionViewCell.m
//  ypj通讯录
//
//  Created by niit on 16/3/1.
//  Copyright © 2016年 ypj. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (void)awakeFromNib {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [view setBackgroundColor:[UIColor blueColor]];
    [self addSubview:view];

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyCollectionViewCell" owner:nil options:nil] lastObject];
        
        
    }
    
    return self;
}
@end
