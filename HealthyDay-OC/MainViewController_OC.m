//
//  MainViewController_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/17.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "MainViewController_OC.h"
#import "HealthManager.h"
enum MainVCState{
    Running,Step
};

@interface MainViewController_OC ()
@property HealthManager *healthManager;
@property enum MainVCState state;
@end

@implementation MainViewController_OC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.healthManager = [HealthManager sharedHealthManager];
    [self.healthManager authorizeWithCompletion:^(BOOL success,NSError *error){
        if (success) {
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
