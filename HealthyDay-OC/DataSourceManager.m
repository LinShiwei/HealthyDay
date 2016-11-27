//
//  DataSourceManager.m
//  HealthyDay
//
//  Created by Linsw on 16/11/20.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "DataSourceManager.h"
#import <CoreData/CoreData.h>
#import <AFNetworking/AFNetworking.h>

@interface DataSourceManager ()

@property enum DataSource dataSource;
@property NSMutableArray<NSManagedObject *> *objects;

@end

@implementation DataSourceManager

+ (instancetype)sharedDataSourceManager{
    static DataSourceManager *sharedDataSourceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedDataSourceManager = [[self alloc] init];
    });
    return sharedDataSourceManager;
}

- (id)init{
    self = [super init];
    if (self) {
        //Setting dataSource to change HealthyDay's data source
        self.dataSource = Linshiwei_win;
        self.objects = [NSMutableArray array];
    }
    return self;
}
#pragma mark Public API
- (void)getAllRunningDataWithCompletion:(void(^)(BOOL,NSArray<DistanceDetailItem *> * _Nullable))completion{
    _dataSource == Linshiwei_win ? [self getDataFromWebServerWithCompletion:completion] :
    [self getDataFromCoreDataWithCompletion:completion];
}

- (void)saveOneRunningDataItem:(DistanceDetailItem *)dataItem withCompletion:(void(^ _Nullable)(BOOL))completion{
    _dataSource == Linshiwei_win ? [self saveToWebServerWithOneDataItem:dataItem withCompletion:completion] :
    [self saveToCoreDataWithOneDataItem:dataItem withCompletion:completion];
}

- (void)deleteOneRunningDataItem:(DistanceDetailItem *)dataItem withCompletion:(void (^ _Nullable )(BOOL))completion{
    _dataSource == Linshiwei_win ? [self deleteInWebServerWithOneDataItem:dataItem withCompletion:completion] :
    [self deleteInCoreDataWithOneDataItem:dataItem withCompletion:completion];
}

#pragma mark Private CoreData data API
- (void)getDataFromCoreDataWithCompletion:(void(^)(BOOL,NSArray<DistanceDetailItem *> * _Nullable))completion{
    NSMutableArray<DistanceDetailItem *> *distances = [NSMutableArray array];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Running"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    NSError *error = nil;
    NSArray *results = [[self getManagedContext] executeFetchRequest:fetchRequest error:&error];
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }else{
        _objects = [NSMutableArray arrayWithArray:results];
        if ([_objects count] > 0){
            for (NSManagedObject *object in _objects){
                NSDate *date = [object valueForKey:@"date"];
                double distance = [[object valueForKey:@"distance"] doubleValue];
                int duration = [[object valueForKey:@"duration"] intValue];
                int durationPerKilometer = [[object valueForKey:@"durationPerKilometer"] intValue];
                if (date&&duration&&durationPerKilometer) {
                    [distances addObject:[[DistanceDetailItem alloc] initWithDate:date distance:distance duration:duration durationPerKilometer:durationPerKilometer]];
                }
            }
        }else{
            distances = [NSMutableArray arrayWithArray:[self mockDistancesData]];
            [self saveToCoreDataWithDistances:distances];
        }
    }
    if (completion) {
        completion(YES,distances);
    }
}

- (void)saveToCoreDataWithOneDataItem:(DistanceDetailItem *)dataItem withCompletion:(void(^ _Nullable)(BOOL))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectContext *managedContext = [self getManagedContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Running" inManagedObjectContext:managedContext];
        NSManagedObject *distanceObject = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
        [distanceObject setValue:dataItem.date forKey:@"date"];
        [distanceObject setValue:[[NSNumber alloc] initWithInt:dataItem.duration] forKey:@"duration"];
        [distanceObject setValue:[[NSNumber alloc] initWithDouble:dataItem.distance] forKey:@"distance"];
        [distanceObject setValue:[[NSNumber alloc] initWithInt:dataItem.durationPerKilometer] forKey:@"durationPerKilometer"];
        NSError *error = nil;
        if ([managedContext save:&error] == NO) {
            if (completion) {
                completion(NO);
            }
            NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
        }else{
            if (completion) {
                completion(YES);
            }
        }
    });
}

- (void)deleteInCoreDataWithOneDataItem:(DistanceDetailItem *)dataItem withCompletion:(void(^ _Nullable)(BOOL))completion{
    NSManagedObjectContext *managedContext = [self getManagedContext];
    NSUInteger count = [_objects count];
    [_objects enumerateObjectsUsingBlock:^(NSManagedObject *object, NSUInteger index, BOOL *stop){
        if ([(NSDate *)[object valueForKey:@"date"] compare:dataItem.date]==NSOrderedSame) {
            [managedContext deleteObject:object];
            NSError *error = nil;
            if ([managedContext save:&error] == NO) {
                if (completion) {
                    completion(NO);
                }
                NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
            }else{
                [_objects removeObject:object];
                if (completion) {
                    completion(YES);
                }
            }
        }
    }];
    NSAssert([_objects count] == count - 1, @"after delete, object count should -1");
}

- (NSManagedObjectContext *)getManagedContext{
    AppDelegate *delegete = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegete.persistentContainer.viewContext;
}

#pragma mark Private Core Data helper
- (NSArray<DistanceDetailItem *> *)mockDistancesData{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-3600*24*100];
    NSMutableArray<DistanceDetailItem *> *items = [NSMutableArray array];
    for (int i=0; i<20; i++) {
        double secondOffset = (double)arc4random_uniform(3600*24*2)+3600*24*3;
        double distance = (double)(arc4random_uniform(2000)+9000);
        int durationPerKilometer = (int)arc4random_uniform(60)+330;
        int duration = (int)(distance / 1000 * (double)(durationPerKilometer));
        date = [date dateByAddingTimeInterval:secondOffset];
        [items addObject:[[DistanceDetailItem alloc] initWithDate:date distance:distance duration:duration durationPerKilometer:durationPerKilometer]];
    }
    return items;
}

- (void)saveToCoreDataWithDistances:(NSArray<DistanceDetailItem *> *)distances{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectContext *managedContext = [self getManagedContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Running" inManagedObjectContext:managedContext];
        for (DistanceDetailItem *distance in distances){
            NSManagedObject *distanceObject = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
            [distanceObject setValue:distance.date forKey:@"date"];
            [distanceObject setValue:[[NSNumber alloc] initWithInt:distance.duration] forKey:@"duration"];
            [distanceObject setValue:[[NSNumber alloc] initWithDouble:distance.distance] forKey:@"distance"];
            [distanceObject setValue:[[NSNumber alloc] initWithInt:distance.durationPerKilometer] forKey:@"durationPerKilometer"];
            [self.objects addObject:distanceObject];
        }
        NSError *error = nil;
        if ([managedContext save:&error] == NO) {
            NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
        }
    });
}

#pragma mark Private Web server API

NSString *serverAPIAddress = @"http://www.linshiwei.win/healthyday.php?key=lsw";

- (void)getDataFromWebServerWithCompletion:(void(^)(BOOL,NSArray<DistanceDetailItem *> * _Nullable))completion{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{@"query": @"get"};
    [manager GET:serverAPIAddress parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject){
//        NSLog(@"aaaaa%@",responseObject);
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([[responseDic objectForKey:@"status"] intValue] == 1) {
            NSMutableArray<DistanceDetailItem *> *items = [NSMutableArray array];
            NSArray<NSDictionary *> *itemData = [responseDic objectForKey:@"runningdata"];
            for (NSDictionary *data in itemData) {
                NSDate *date = [NSDate dateFromFormatString:data[@"date"]];
                double distance = [data[@"distance"] doubleValue];
                int duration = [data[@"duration"] intValue];
                int durationPerKilometer = [data[@"durationPerKilometer"] intValue];
                if (date&&distance&&duration&&durationPerKilometer) {
                    DistanceDetailItem *item = [[DistanceDetailItem alloc] initWithDate:date distance:distance duration:duration durationPerKilometer:durationPerKilometer];
                    [items addObject:item];
                }else{
                    NSLog(@"linshiwei.win invalid data");
                }
            }
            completion(YES,items);
        }else{
            NSLog(@"linshiwei.win status == 0, fail to fetch data");
            completion(NO,NULL);
            
        }
    } failure:^(NSURLSessionTask *operation, NSError *error){
        NSLog(@"Error: %@", error);
        completion(NO,NULL);
    }];
}

- (void)saveToWebServerWithOneDataItem:(DistanceDetailItem *)dataItem withCompletion:(void(^ _Nullable)(BOOL))completion{
    NSString *dateString = [[dataItem.date formatDescription] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *distanceString = [NSString stringWithFormat:@"%.2f",dataItem.distance];
    NSString *durationString = [NSString stringWithFormat:@"%d",dataItem.duration];
    NSString *durationPerKilometerString = [NSString stringWithFormat:@"%d",dataItem.durationPerKilometer];
    NSDictionary *parameters = @{@"query": @"set",
                                 @"date": dateString,
                                 @"distance":distanceString,
                                 @"duration":durationString,
                                 @"durationperkilometer":durationPerKilometerString};
//    NSLog(@"%@&query=set&date=%@&distance=%@&duration=%@&durationPerKilometer=%@",serverAPIAddress,dateString,distanceString,durationString,durationPerKilometerString);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:serverAPIAddress parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject){
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([[responseDic objectForKey:@"status"] intValue] == 1) {
            if (completion) {
                completion(YES);
            }
        }else{
            NSLog(@"fail to save to web server, status == 0");
            if (completion) {
                completion(NO);
            }
        }
    }failure:^(NSURLSessionTask *operation, NSError *error){
        NSLog(@"Error: %@", error);
        if (completion) {
            completion(NO);
        }
    }];
    
}

- (void)deleteInWebServerWithOneDataItem:(DistanceDetailItem *)dataItem withCompletion:(void(^ _Nullable)(BOOL))completion{
    NSString *dateString = [[dataItem.date formatDescription] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSDictionary *parameters = @{@"query": @"delete",
                                 @"date":dateString};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:serverAPIAddress parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject){
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([[responseDic objectForKey:@"status"] intValue] == 1) {
            if (completion) {
                completion(YES);
            }
        }else{
            NSLog(@"fail to delete in web server, status == 0");
            if (completion) {
                completion(NO);
            }
        }
    }failure:^(NSURLSessionTask *operation, NSError *error){
        NSLog(@"Error: %@", error);
        if (completion) {
            completion(NO);
        }
    }];
}
@end
