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

@property NSMutableArray<CLLocation *> *runningLocations;
@property BOOL hasLocated;
@property CLLocation *oldLocation;
@property (nonatomic) BOOL startRunning;

@property (nonatomic) double runningDistance;
@property (nonatomic) int runningDuration;
@property (nonatomic) int durationPerKilometer;

@property NSTimer *timer;

@end

@implementation RunningViewController_OC

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager.delegate = self;
    [locationManager authorizeWithCompletion:^(BOOL success){
        _gpsNotationView = [[GPSNotationView_OC alloc] initWithFrame:CGRectMake(20, 20, 200, 20) hasEnable:success];
        [_mapView addSubview:_gpsNotationView];
    }];
    _mapView.delegate = self;
    _mapView.userLocation.title = @"我的位置";
    _mapView.showsUserLocation = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_startRunning) {
        _startRunning = NO;
    }
    _hasLocated = NO;
}

- (void)setStartRunning:(BOOL)startRunning{
    _startRunning = startRunning;
    [_runningLocations removeAllObjects];
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

- (void)setRunningDistance:(double)runningDistance{
    _runningDistance = runningDistance;
    NSMutableAttributedString *text = (NSMutableAttributedString *)_runningDistanceLabel.attributedText;
    if (text) {
        NSRange range = NSMakeRange(0, text.length-2);
        NSAttributedString *attributeString= [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",runningDistance/1000.0] attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"DINCondensed-Bold" size:48] forKey:NSFontAttributeName]];
        [text replaceCharactersInRange:range withAttributedString:attributeString];
        _runningDistanceLabel.text = [NSString stringWithFormat:@"%.2f公里",runningDistance/1000.0];
        _runningDistanceLabel.attributedText = text;
    }else{
        
    }
}

- (void)setRunningDuration:(int)runningDuration{
    _runningDuration = runningDuration;
    _runningDurationLabel.text = [[Define sharedDefine] durationFormatterWithSecondsDuration:runningDuration];
}

- (void)setDurationPerKilometer:(int)durationPerKilometer{
    _durationPerKilometer = durationPerKilometer;
    _durationPerKilometerLabel.text = [[Define sharedDefine] durationPerKilometerFormatterWithDuration:durationPerKilometer];
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
    if (_timer.isValid == NO) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDurationAndAverageSpeed:) userInfo:NULL repeats:YES];
    }
}

- (void)drawRouteWithLocations:(NSArray<CLLocation *> *)locations {
    CLLocationCoordinate2D coordinates[locations.count];
    for (int index = 0; index < locations.count; index++) {
        coordinates[index] = locations[index].coordinate;
    }
    [self drawRouteWithCoordinates:coordinates count:locations.count];
}

- (void)drawRouteWithCoordinates:(const CLLocationCoordinate2D *)coordinates count:(NSUInteger)count{
    if (count > 1) {
        MKPolyline *overlay = [MKPolyline polylineWithCoordinates:coordinates count:count];
        [_mapView removeOverlays:_mapView.overlays];
        [_mapView addOverlay:overlay];
    }
}

- (void)updateRunningDistanceWithNewLocations:(NSArray<CLLocation *> *)locations{
    if (_oldLocation != nil && [_oldLocation distanceFromLocation:[locations lastObject]] >= 1) {
        for (CLLocation * location in locations) {
            _runningDistance += [location distanceFromLocation:_oldLocation];
            _oldLocation = location;
        }
    }
}

- (void)saveRunningData{
    DistanceDetailItem *dataItem = [[DistanceDetailItem alloc] initWithDate:[[NSDate date] dateByAddingTimeInterval:(-(double)_runningDuration)] distance:_runningDistance duration:_runningDuration durationPerKilometer:_durationPerKilometer];
    [dataSourceManager saveOneRunningDataItem:dataItem withCompletion:NULL];
}

- (void)updateDurationAndAverageSpeed:(NSTimer *)sender{
    NSAssert(_timer != nil, @"timer should not be nil");
    _runningDuration += (int)_timer.timeInterval;
    if (_runningDistance != 0) {
        _durationPerKilometer = (int)((double)_runningDuration/_runningDistance*1000);
    }
    [_gpsNotationView refreshCurrentTime];
}



- (IBAction)tapToStartRunning:(UIButton *)sender {
    _startRunning = !_startRunning;
    [sender setTitle:_startRunning ? @"暂停" : @"开始" forState:UIControlStateNormal];
    NSLog(@"running start == %d",_startRunning);
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocation *location = [userLocation location];
    if (_mapView.isUserLocationVisible) {
        [_mapView setCenterCoordinate:location.coordinate animated:YES];
    }
    if (!_hasLocated) {
        MKCoordinateRegion userRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0, 1000.0);
        [_mapView setRegion:userRegion animated:YES];
        _hasLocated = YES;
    }
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    render.strokeColor = [UIColor redColor];
    render.lineWidth = 5.0;
    return render;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        _gpsNotationView.hasEnabled = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (_hasLocated && _startRunning) {
        [self drawRouteWithLocations:locations];
        if (_oldLocation == nil){
            _oldLocation = [locations lastObject];
        }else{
            [self updateRunningDistanceWithNewLocations:locations];
        }
        for (CLLocation *location in locations) {
            [_runningLocations addObject:location];
        }
    }
}

@end
