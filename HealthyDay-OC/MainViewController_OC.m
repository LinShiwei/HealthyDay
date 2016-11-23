//
//  MainViewController_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/17.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "MainViewController_OC.h"

@interface MainViewController_OC ()<MainInfoViewTapGestureDelegate>{
    HealthManager *healthManager;
    enum MainVCState state;
}

@property CustomBarBtnItem_OC *stepBarItem;
@property CustomBarBtnItem_OC *runningBarItem;

@property (weak, nonatomic) IBOutlet MainInfomationView_OC *mainInfoView;
@property (weak, nonatomic) IBOutlet StepBarChartView_OC *stepBarChartView;
@property (weak, nonatomic) IBOutlet StartRunningButton_OC *startRunningBtn;

@end

@implementation MainViewController_OC

#pragma mark Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    healthManager = [HealthManager sharedHealthManager];
    state = Running;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage alloc] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage alloc];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"Back-22"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Back-22"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    
    [healthManager authorizeWithCompletion:^(BOOL success,NSError *error){
        NSLog(@"Error == %@",error);
        NSLog(@"HealthKit authorize:%d",success);
    }];
    
    _mainInfoView.delegate = self;
    [self initStepBarChartView];
    
    _runningBarItem = [[CustomBarBtnItem_OC alloc] initWithButtonFrame:CGRectMake([Define sharedDefine].windowBounds.size.width/5*2-18-25, 0, 50, 22) title:@"运动" itemType:Left];
    [_runningBarItem addTarget:self action:@selector(swipeRight:progress:velocity:) for:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = _runningBarItem;
    
    _stepBarItem = [[CustomBarBtnItem_OC alloc] initWithButtonFrame:CGRectMake([Define sharedDefine].windowBounds.size.width/5*2-18-25, 0, 50, 22) title:@"记步" itemType:Right];
    [_stepBarItem addTarget:self action:@selector(swipeLeft:progress:velocity:) for:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = _stepBarItem;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_mainInfoView refreshAnimation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self updateCurrentDistance];
    [self updateCurrentStepCount];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"ShowStepDetailVC"]) {
        StepDetailViewController_OC *stepDetailVC = segue.destinationViewController;
#ifdef __x86_64__
        
#else
#ifdef __i386__
        
#else
        [healthManager readStepCountWithPeriodDataType:Weekly withCompletion:^(NSArray<NSNumber *> *counts,NSError *error){
            if (counts != nil && error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    stepDetailVC.
                })
            }
        }];
        [healthManager readDistanceWalkingRunningWithPeriodType:Weekly withCompletion:^(NSArray<NSNumber *> *distances,NSError *error){
            if (distances != nil && error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
        }];
#endif
#endif
        
    } else {
        return;
    }
}

- (void)initStepBarChartView{
    _stepBarChartView.alpha = 0;
#ifdef __x86_64__
    
#else
#ifdef __i386__
    
#else
    [healthManager readStepCountWithPeriodDataType:Weekly withCompletion:^(NSArray<NSNumber *> *counts,NSError *error){
        if (counts != nil && error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stepBarChartView.stepCounts = counts;
            });
        }
    }];
#endif
#endif
}

#pragma mark IBAction

- (IBAction)didPanInMainInfoView:(UIPanGestureRecognizer *)sender {
    CGFloat progress = [sender translationInView:_mainInfoView].x/_mainInfoView.frame.size.width;
    switch (sender.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            CGFloat velocityX = [sender velocityInView:self.view].x;
            if (velocityX > 900) {
                [self swipeRight:sender progress:progress velocity:velocityX];
                break;
            }
            if (velocityX < -900) {
                [self swipeLeft:sender progress:progress velocity:velocityX];
                break;
            }
            if (progress > 0.4) {
                [self swipeRight:sender progress:progress velocity:velocityX];
            }else{
                if (progress < -0.4) {
                    [self swipeLeft:sender progress:progress velocity:velocityX];
                } else {
                    if (state == Running) {
                        [self swipeRight:sender progress:progress velocity:velocityX];
                    } else {
                        [self swipeLeft:sender progress:progress velocity:velocityX];
                    }
                }
            }
            break;
        }
        default:
            [_mainInfoView panAnimationWithProgress:progress currentState:state];
            [_stepBarChartView panAnimationWithProgress:progress currentState:state];
            [_startRunningBtn panAnimationWithProgress:progress currentState:state];
            break;
    }
    
}

#pragma mark Help func
- (void)swipeLeft:(id)sender progress:(CGFloat)progress velocity:(CGFloat)velocity{
    double duration;
    double baseDuration = 0.5;
    double pro = ABS(progress);
    double vel = ABS(velocity);
    if (vel > 900) {
        switch (state) {
            case Step:
                duration = baseDuration*pro*900/vel;
                break;
            case Running:
                duration = (baseDuration - baseDuration*pro)*900/vel;
            default:
                break;
        }
    }else{
        switch (state) {
            case Step:
                duration = baseDuration*pro;
                break;
            case Running:
                duration = baseDuration - baseDuration*pro;
            default:
                break;
        }
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut&UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_mainInfoView panAnimationWithProgress:-1 currentState:state];
        _stepBarItem.enable = NO;
        _runningBarItem.enable = YES;
        [_stepBarChartView panAnimationWithProgress:-1 currentState:state];
        [_startRunningBtn panAnimationWithProgress:-1 currentState:state];
    } completion:nil];
    
    if (state == Running) {
        [self updateCurrentStepCount];
    }
    state = Step;
}

- (void)swipeRight:(id)sender progress:(CGFloat)progress velocity:(CGFloat)velocity{
    double duration;
    double baseDuration = 0.5;
    double pro = ABS(progress);
    double vel = ABS(velocity);
    if (vel > 900) {
        switch (state) {
            case Step:
                duration = baseDuration*pro*900/vel;
                break;
            case Running:
                duration = (baseDuration - baseDuration*pro)*900/vel;
            default:
                break;
        }
    }else{
        switch (state) {
            case Step:
                duration = baseDuration - baseDuration*pro;
                break;
            case Running:
                duration = baseDuration*pro;
            default:
                break;
        }
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut&UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_mainInfoView panAnimationWithProgress:1 currentState:state];
        _stepBarItem.enable = YES;
        _runningBarItem.enable = NO;
        [_stepBarChartView panAnimationWithProgress:1 currentState:state];
        [_startRunningBtn panAnimationWithProgress:1 currentState:state];
    } completion:nil];
    
    if (state == Step) {
        [self updateCurrentDistance];
    }
    state = Running;
}

- (void)updateCurrentStepCount{
#ifdef __x86_64__
    _mainInfoView.stepCount = 1000;
#else
#ifdef __i386__
    _mainInfoView.stepCount = 1000;
#else
    [healthManager readStepCountWithPeriodDataType:Current withCompletion:^(NSArray<NSNumber *> *counts,NSError *error){
        if (counts != nil && error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _mainInfoView.stepCount = counts[0].intValue;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                _mainInfoView.stepCount = 0;
            });
        }
    }];
#endif
#endif
}

- (void)updateCurrentDistance{
#ifdef __x86_64__
    _mainInfoView.distance = 2000;
#else
#ifdef __i386__
    _mainInfoView.distance = 2000;
#else
    [healthManager readDistanceWalkingRunningWithPeriodType:Current withCompletion:^(NSArray<NSNumber *> *distances,NSError *error){
        if (distances != nil && error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _mainInfoView.distance = distances[0].doubleValue;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                _mainInfoView.distance = 0;
            });
        }
    }];
#endif
#endif
}

#pragma mark MainInfoViewTapGestureDelegate
- (void)didTapInLabel:(UILabel *)label{
    if ([label isKindOfClass:[StepCountLabel_OC class]]) {
        [self performSegueWithIdentifier:@"ShowStepDetailVC" sender:label];
    } else {
        if ([label isKindOfClass:[DistanceWalkingRunningLabel_OC class]]) {
            [self performSegueWithIdentifier:@"ShowDistanceDetailVC" sender:label];
        }
    }
}



@end
