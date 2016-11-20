//
//  RunningViewController_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/20.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "RunningViewController_OC.h"

@interface RunningViewController_OC () <MKMapViewDelegate,CLLocationManagerDelegate>{
    LocationManager *locationManager;
    DataSourceManager *dataSourceManager;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet RunningInfomationView_OC *runningInfoView;

@property (weak, nonatomic) IBOutlet UILabel *runningDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationPerKilometerLabel;

- (IBAction)tapToStartRunning:(UIButton *)sender;

@property GPSNotationView_OC *gpsNotationView;

@property NSMutableArray *runningCoordinates;
@property BOOL hasLocated;
@property (nonatomic) BOOL startRunning;
@property CLLocation *oldLocation;

@property double runningDistance;
@property int runningDuration;
@property int durationPerKilometer;

@property NSTimer *timer;

@end

@implementation RunningViewController_OC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setStartRunning:(BOOL)startRunning{
    _startRunning = startRunning;
    [_runningCoordinates removeAllObjects];
    if (startRunning) {
        [self initTimer];
        _runningDistance = 0;
        _runningDuration = 0;
        [locationManager startUpdate];
    }else{
        [_timer invalidate];
        [self saveRunningData];
        [locationManager stopUpdate];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initTimer{
    
}

- (void)drawRouteWithCoordinates:(NSArray *)coordinates{
    
}

- (void)updateRunningDistanceWithNewLocations:(NSArray *)locations{
    
}

- (void)saveRunningData{
    
}

- (void)updateDurationAndAverageSpeed:(NSTimer *)sender{
    
}



- (IBAction)tapToStartRunning:(UIButton *)sender {
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    render.strokeColor = [UIColor redColor];
    render.lineWidth = 5.0;
    return render;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
}

@end
