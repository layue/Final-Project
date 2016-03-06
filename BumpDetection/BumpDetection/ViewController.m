//
//  ViewController.m
//  BumpDetection
//
//  Created by 徐冰 on 22/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kMeans = [[kMeansCluster alloc] init];
    self.accelerometer = [[Accelerometer alloc] init];
    self.gyroscope = [[Gyroscope alloc] init];
    
//    move window average

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startCaptureData:(id)sender {
//    NSMutableArray *accData = [[NSMutableArray alloc] init];
    [self.accelerometer accelerationData];
    
    NSMutableArray *gyroData = [[NSMutableArray alloc] init];
    gyroData = [self.gyroscope gyroscopeData];
}

- (IBAction)stopCaptureData:(id)sender {
    [self.accelerometer stopAccelerometer];
    [self showAlertMessage:@"Stop to capture Accelerometer data."];
}


- (IBAction)clearDB:(id)sender {
    [[DBManager getSharedInstance] deleteDB];
}

- (IBAction)addBump:(id)sender {
    [self.accelerometer addBump];
}

- (void) showAlertMessage:(NSString *)myMessage {
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"Alert message" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okey" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


@end
