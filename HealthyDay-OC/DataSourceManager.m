//
//  DataSourceManager.m
//  HealthyDay
//
//  Created by Linsw on 16/11/20.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "DataSourceManager.h"
#import <CoreData/CoreData.h>

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
        self.dataSource = CoreData;
    }
    return self;
}

- (void)getAllRunningDataWithCompletion:(void(^)(BOOL,NSArray<DistanceDetailItem *> * _Nullable))completion{
//    _dataSource == Linshiwei_win ?
    [self getDataFromCoreDataWithCompletion:completion];
}

- (void)saveOneRunningDataItem:(DistanceDetailItem *)dataItem withCompletion:(void(^ _Nullable)(BOOL))completion{
    [self saveToCoreDataWithOneDataItem:dataItem withCompletion:completion];
}

- (void)deleteOneRunningDataItem:(DistanceDetailItem *)dataItem withCompletion:(void (^ _Nullable )(BOOL))completion{
    [self deleteOneRunningDataItem:dataItem withCompletion:completion];
}

#pragma mark CoreData data Private API
- (void)getDataFromCoreDataWithCompletion:(void(^)(BOOL,NSArray<DistanceDetailItem *> * _Nullable))completion{
    NSMutableArray<DistanceDetailItem *> *distances;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Running"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    NSError *error = nil;
    NSArray *results = [[self getManagedContext] executeFetchRequest:fetchRequest error:&error];
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }else{
        _objects = [NSMutableArray arrayWithArray:results];
//        _objects = (NSArray<NSManagedObject *> *)results;
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
            completion(false);
            NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
        }else{
            completion(true);
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
                completion(false);
                NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
            }else{
                [_objects removeObject:object];
            }
        }
    }];
    NSAssert([_objects count] == count - 1, @"after delete, object count should -1");
}

- (NSManagedObjectContext *)getManagedContext{
    AppDelegate *delegete = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegete.persistentContainer.viewContext;
}

- (NSArray<DistanceDetailItem *> *)mockDistancesData{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-3600*24*100];
    NSMutableArray<DistanceDetailItem *> *items;
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


@end
