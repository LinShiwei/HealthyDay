//
//  CustomBarBtnItem_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "CustomBarBtnItem_OC.h"

@interface CustomBarBtnItem_OC ()

@property UIButton *button;

@end


@implementation CustomBarBtnItem_OC

- (id)initWithButtonFrame:(CGRect)frame title:(NSString *)title itemType:(enum BarBtnItemType)type{
    self = [super init];
    if (self) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width+frame.origin.x, 22)];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self.button setTitle:title forState:UIControlStateNormal];
        if (type == Left) {
            self.button.frame = frame;
        }else{
            self.button.frame = CGRectMake(backView.frame.size.width-frame.size.width-frame.origin.x, backView.frame.origin.y, frame.size.width, frame.size.height);
        }
        [backView addSubview:self.button];
        self.customView = backView;
    }
    return self;
}

- (void)setEnable:(BOOL)enable{
    _enable = enable;
    [_button setEnabled:enable];
}

- (void)addTarget:(id)target action:(SEL)action for:(UIControlEvents)controlEvents{
    [_button addTarget:target action:action forControlEvents:controlEvents];
}
@end
