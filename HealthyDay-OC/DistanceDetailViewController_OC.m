//
//  DistanceDetailViewController_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "DistanceDetailViewController_OC.h"

@interface DistanceDetailViewController_OC ()<UITableViewDelegate,UITableViewDataSource>{
    DataSourceManager *dataSourceManager;
}
@property (weak, nonatomic) IBOutlet UITableView *distanceDetailTableView;

@property NSMutableArray<DistanceDetailItem *> *distances;
@property NSArray<DistanceInfo *> *distancesInfo;

@end

@implementation DistanceDetailViewController_OC

- (void)viewDidLoad {
    [super viewDidLoad];
    [dataSourceManager getAllRunningDataWithCompletion:^(BOOL success,NSArray<DistanceDetailItem *> *items){
        if (success&&items) {
            self.distances = [NSMutableArray arrayWithArray: items];
            self.distancesInfo = [self classifyDistanes:self.distances];
            [self.distanceDetailTableView reloadData];
        }
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"ShowDistanceStatisticsVC"]) {
        DistanceStatisticsViewController_OC *distanceStatisticsVC = segue.destinationViewController;
        distanceStatisticsVC.distanceDetailItem = _distances;
    }
}

- (NSArray<DistanceInfo *> *)classifyDistanes:(NSArray<DistanceDetailItem *> *)distances{
    NSMutableArray<DistanceInfo *> *info;
    if (distances.count > 0) {
        NSString *dateDescription = [distances[0].date formatDescription];
        NSString *month = [dateDescription substringToIndex:7];
        int infoIndex = 0;
        [info addObject:[[DistanceInfo alloc] initWithMonth:month count:0]];
        for (DistanceDetailItem *distance in distances) {
            if ([[distance.date formatDescription] containsString:month]) {
                info[infoIndex].count += 1;
            }else{
                dateDescription = [distance.date formatDescription];
                month = [dateDescription substringToIndex:7];
                [info addObject:[[DistanceInfo alloc] initWithMonth:month count:1]];
                infoIndex += 1;
            }
        }
    }
    return info;
}

- (NSInteger)indexInDistancesArrayWithIndexPath:(NSIndexPath *)indexPath{
    int offset = 0;
    if (indexPath.section == 0) {
        return indexPath.row;
    }else{
        for (NSInteger section = 0; section < indexPath.section; section++) {
            offset += _distancesInfo[section].count;
        }
        return indexPath.row+offset;
    }
}

#pragma mark TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:{
            NSInteger index = [self indexInDistancesArrayWithIndexPath:indexPath];
            [dataSourceManager deleteOneRunningDataItem:_distances[index] withCompletion:^(BOOL success){
                if (!success) {
                    NSLog(@"fail to delete distance dataItem");
                }
            }];
            [_distances removeObjectAtIndex:index];
            _distancesInfo[indexPath.section].count -= 1;
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        default:
            break;
    }
}

#pragma mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _distancesInfo.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _distancesInfo[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DistanceDetailTableViewCell_OC *cell = [tableView dequeueReusableCellWithIdentifier:@"DistanceDetailTableViewCell" forIndexPath:indexPath];
    NSInteger index = [self indexInDistancesArrayWithIndexPath:indexPath];
    cell.date = _distances[index].date;
    cell.distance = _distances[index].distance;
    cell.duration = _distances[index].duration;
    cell.durationPerKilometer = _distances[index].durationPerKilometer;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = _distancesInfo[section].month;
    [title stringByAppendingString:@"月"];
    return [title stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    if (header) {
        header.textLabel.font = [UIFont systemFontOfSize:14];
        header.textLabel.textColor = [[Theme sharedTheme] darkTextColor];
    }
}

@end
