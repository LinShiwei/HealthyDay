//
//  DistanceDetailTableViewCell_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "DistanceDetailTableViewCell_OC.h"

@interface DistanceDetailTableViewCell_OC ()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationPerKilometerLabel;


@end

@implementation DistanceDetailTableViewCell_OC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDate:(NSDate *)date{
    _date = date;
    _dateLabel.text = [self getFormatDateDescriptionFromDate:date];
    
}

- (void)setDistance:(double)distance{
    _distance = distance;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",distance/1000.0] attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"DINCondensed-Bold" size:37] forKey:NSFontAttributeName]];
    NSMutableAttributedString *unitText = [[NSMutableAttributedString alloc] initWithString:@"公里" attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName]];
    [text appendAttributedString:unitText];
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f公里",distance/1000.0];
    _distanceLabel.attributedText = text;
}

- (void)setDuration:(int)duration{
    _duration = duration;
    _durationLabel.text = [[Define sharedDefine] durationFormatterWithSecondsDuration:duration];
}

- (void)setDurationPerKilometer:(int)durationPerKilometer{
    _durationPerKilometer = durationPerKilometer;
    _durationPerKilometerLabel.text = [[Define sharedDefine] durationPerKilometerFormatterWithDuration:durationPerKilometer];
}

#pragma mark Private func
- (NSString *)getFormatDateDescriptionFromDate:(NSDate *)date{
    NSInteger day = [[[Define sharedDefine] calendar] component:NSCalendarUnitDay fromDate:date];
    NSInteger hour = [[[Define sharedDefine] calendar] component:NSCalendarUnitHour fromDate:date];
    if (hour >=0 && hour < 11){
        return [NSString stringWithFormat:@"%ld日上午",(long)day];
    }
    if (hour >=11 && hour < 14){
        return [NSString stringWithFormat:@"%ld日中午",(long)day];
    }
    if (hour >=14 && hour < 19){
        return [NSString stringWithFormat:@"%ld日下午",(long)day];
    }
    if (hour >=19 && hour < 25){
        return [NSString stringWithFormat:@"%ld日晚上",(long)day];
    }
    return @"error";
}
@end
