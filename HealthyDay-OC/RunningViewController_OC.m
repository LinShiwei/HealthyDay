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
    dataSourceManager = [DataSourceManager sharedDataSourceManager];
    locationManager = [LocationManager sharedLocationManager];
    _runningLocations = [NSMutableArray array];
    
    locationManager.delegate = self;
    [locationManager authorizeWithCompletion:^(BOOL success){
        if (success) {
            ;
        } else {
            ;
        }
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
        self.startRunning = NO;
    }
    _hasLocated = NO;
}

- (void)setStartRunning:(BOOL)startRunning{
    _startRunning = startRunning;
    [_runningLocations removeAllObjects];
    if (startRunning) {
        [self initTimer];
        self.runningDistance = 0;
        self.runningDuration = 0;
        [locationManager startUpdate];
    }else{
        [_timer invalidate];
        _timer = nil;
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

- (void)initTimer{
    if (_timer == nil || _timer.isValid == NO) {
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
            self.runningDistance += [location distanceFromLocation:_oldLocation];
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
    self.runningDuration += (int)_timer.timeInterval;
    if (_runningDistance != 0) {
        self.durationPerKilometer = (int)((double)_runningDuration/_runningDistance*1000);
    }
    [_gpsNotationView refreshCurrentTime];
}



- (IBAction)tapToStartRunning:(UIButton *)sender {
    self.startRunning = !_startRunning;
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
        [self drawRouteWithLocations:_runningLocations];
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
