//
//  CustomBarBtnItem_OC.h
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarBtnItemTypeEnum.h"

@interface CustomBarBtnItem_OC : UIBarButtonItem

@property (nonatomic) BOOL enable;

- (id)initWithButtonFrame:(CGRect)frame title:(NSString *)title itemType:(enum BarBtnItemType)type;
- (void)addTarget:(id)target action:(SEL)action for:(UIControlEvents)controlEvents;

@end
