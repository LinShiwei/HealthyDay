//
//  DistanceStatisticsViewController_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "DistanceStatisticsViewController_OC.h"

@interface DistanceStatisticsViewController_OC (){
    DistanceStatisticsDataManager *statisticsManager;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *statisticsPeriodSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *totalDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPeriodLabel;

@property (weak, nonatomic) IBOutlet DistanceStatisticsChartView_OC *distanceStatisticsChart;
@property (weak, nonatomic) IBOutlet UILabel *totalDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCalorieLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageDurationPerKilometerLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageSpeedLabel;

- (IBAction)statisticsPeriodChanged:(UISegmentedControl *)sender;

@property (nonatomic) double totalDistance;
@property (nonatomic) NSString * currentPeriodDescription;
@property (nonatomic) int totalDuration;
@property (nonatomic) int averageDurationPerKilometer;
@property (nonatomic) double averageSpeed;

@end

@implementation DistanceStatisticsViewController_OC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self statisticsPeriodChanged:_statisticsPeriodSegmentedControl];
}

- (void)setDistanceDetailItem:(NSArray<DistanceDetailItem *> *)distanceDetailItem{
    _distanceDetailItem = distanceDetailItem;
    statisticsManager.distances = distanceDetailItem;
}

- (void)setTotalDistance:(double)totalDistance{
    NSMutableAttributedString *text = (NSMutableAttributedString *)_totalDistanceLabel.attributedText;
    NSRange range = NSMakeRange(0, text.length-2);
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",_totalDistance/1000.0] attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"DINCondensed-Bold" size:37] forKey:NSFontAttributeName]];
    [text replaceCharactersInRange:range withAttributedString:attributeString];
    _totalDistanceLabel.text = [NSString stringWithFormat:@"%.2f公里",totalDistance/1000.0];
    _totalDistanceLabel.attributedText = text;
}

- (void)setCurrentPeriodDescription:(NSString *)currentPeriodDescription{
    _currentPeriodDescription = currentPeriodDescription;
    _currentPeriodLabel.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"I" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"DINCondensed-Bold" size:37],NSFontAttributeName,[UIColor clearColor],NSForegroundColorAttributeName, nil]];
    NSMutableAttributedString *attributedStringSuffix = [[NSMutableAttributedString alloc] initWithString:_currentPeriodDescription attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName]];
    [text appendAttributedString:attributedStringSuffix];
    _currentPeriodLabel.text = [NSString stringWithFormat:@"I%@",_currentPeriodDescription];
    _currentPeriodLabel.attributedText = text;
}

- (void)setTotalDuration:(int)totalDuration{
    _totalDuration = totalDuration;
    _totalDurationLabel.text = [[Define sharedDefine] durationFormatterWithSecondsDuration:totalDuration];
}

- (void)setAverageDurationPerKilometer:(int)averageDurationPerKilometer{
    _averageDurationPerKilometer = averageDurationPerKilometer;
    _averageDurationPerKilometerLabel.text = [[Define sharedDefine] durationPerKilometerFormatterWithDuration:averageDurationPerKilometer];
}

- (void)setAverageSpeed:(double)averageSpeed{
    _averageSpeed = averageSpeed;
    _averageDurationPerKilometerLabel.text = [NSString stringWithFormat:@"%.2f公里/时",(double)averageSpeed*3600/1000.0];
}
- (void)refreshData{
    _totalDistance = [statisticsManager getTotalDistance];
    _totalDuration = [statisticsManager getTotalDuration];
    _averageDurationPerKilometer = [statisticsManager getAverageDurationPerKilometer];
    _averageSpeed = [statisticsManager getAverageSpeed];
}

- (IBAction)statisticsPeriodChanged:(UISegmentedControl *)sender {
    NSCalendar *calendar = [[Define sharedDefine] calendar];
    switch ([sender selectedSegmentIndex]) {
        case 0:
            statisticsManager.type = Week;
            _currentPeriodDescription = @"本周";
            break;
        case 1:
            statisticsManager.type = Month;
            _currentPeriodDescription = [NSString stringWithFormat:@"%ld年%ld月",[calendar component:NSCalendarUnitYear fromDate:[NSDate date]]+1991,[calendar component:NSCalendarUnitMonth fromDate:[NSDate date]]+1991];
            break;
        case 2:
            statisticsManager.type = Year;
            _currentPeriodDescription = [NSString stringWithFormat:@"%ld年",[calendar component:NSCalendarUnitYear fromDate:[NSDate date]]+1991];
            break;
        case 3:
            statisticsManager.type = All;
            _currentPeriodDescription = @"全部";
            break;
        default:
            break;
    }
    _distanceStatisticsChart.type = statisticsManager.type;
    _distanceStatisticsChart.distanceStatistics = [statisticsManager getDistanceStatistics];
    [self refreshData];
}
@end
