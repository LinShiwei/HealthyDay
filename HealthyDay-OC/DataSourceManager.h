//
//  DataSourceManager.h
//  HealthyDay
//
//  Created by Linsw on 16/11/20.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DistanceDetailItem.h"
enum DataSource{
    CoreData,Linshiwei_win
};
@interface DataSourceManager : NSObject
NS_ASSUME_NONNULL_BEGIN
+ (instancetype)sharedDataSourceManager;

- (void)getAllRunningDataWithCompletion:(void(^)(BOOL,NSArray<DistanceDetailItem *> * _Nullable))completion;
- (void)saveOneRunningDataItem:(DistanceDetailItem *)dataItem withCompletion:(void(^ _Nullable)(BOOL))completion;
- (void)deleteOneRunningDataItem:(DistanceDetailItem *)dataItem withCompletion:(void (^ _Nullable )(BOOL))completion;
NS_ASSUME_NONNULL_END
@end
