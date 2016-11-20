//
//  GPSNotationView_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/20.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "GPSNotationView_OC.h"

@interface GPSNotationView_OC ()

@property UILabel *gpsNotation;
@property UILabel *infoLabel;

@end

@implementation GPSNotationView_OC

- (id)initWithFrame:(CGRect)frame hasEnable:(BOOL)enable{
    self = [super initWithFrame:frame];
    NSAssert(frame.size.width > 100, @"GPSNotationView's width must > 100");
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.3]];
        [self.layer setCornerRadius:frame.size.height/2];
        
        CGFloat gap = 2;
        _gpsNotation.frame = CGRectMake(0, gap, 30, frame.size.height-gap*2);
        _gpsNotation.layer.cornerRadius = frame.size.height/2;
        _gpsNotation.layer.backgroundColor = [[UIColor redColor] CGColor];
        _gpsNotation.text = @"GPS";
        _gpsNotation.textAlignment = NSTextAlignmentCenter;
        _gpsNotation.textColor = [UIColor blackColor];
        _gpsNotation.font = [UIFont systemFontOfSize:14];
        [self addSubview:_gpsNotation];
        
        CGFloat maxX = _gpsNotation.frame.origin.x + _gpsNotation.frame.size.width;
        _infoLabel.frame = CGRectMake(maxX, gap, frame.size.width-maxX, frame.size.height-gap*2);
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.textColor = [UIColor blackColor];
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.text = @"GPS不可用";
        [self addSubview:_infoLabel];
        self.hasEnabled = enable;
    }
    return self;
}

- (void)refreshCurrentTime{
    _infoLabel.text = [self getCurrentDateDescription];
}

- (NSString *)getCurrentDateDescription{
    NSString *date = [[NSDate date] formatDescription];
    NSRange timeRange = NSMakeRange(11, 5);
    NSArray<NSString *> *dateArray = [[date substringToIndex:10] componentsSeparatedByString:@"-"];
    NSString *timeString = [date substringWithRange:timeRange];
    NSAssert([dateArray count] == 3, @"dateArray should contain year month and day");
    return [NSString stringWithFormat:@"%@年%@月%@日%@",dateArray[0],dateArray[1],dateArray[2],timeString];
    
}

@end
