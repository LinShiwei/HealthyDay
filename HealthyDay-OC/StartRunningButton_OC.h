//
//  StartRunningButton_OC.h
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVCStateEnum.h"
#import "Theme.h"

@interface StartRunningButton_OC : UIButton

- (void)panAnimationWithProgress:(CGFloat)progress currentState:(enum MainVCState)currentState;

@end
