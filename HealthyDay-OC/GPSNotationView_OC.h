//
//  GPSNotationView_OC.h
//  HealthyDay
//
//  Created by Linsw on 16/11/20.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+NSDate_formatDescription.h"

@interface GPSNotationView_OC : UIView

@property BOOL hasEnabled;

- (id)initWithFrame:(CGRect)frame hasEnable:(BOOL)enable;
- (void)refreshCurrentTime;

@end
