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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCaptureData:(id)sender {
    self.motionData = [[MotionData alloc] init];
    if (![self.motionData startCaptureData]) {
        [self showAlertMessage:@"Failed to start capture motion data."];
    }
}

- (IBAction)stopCaptureData:(id)sender {
    [self.motionData stopCaptureData];
    [self showAlertMessage:@"Stop to capture Accelerometer data."];
}

- (IBAction)clearDB:(id)sender {
    if([[DBManager getSharedInstance] clearDB]) {
        [self showAlertMessage:@"You have cleared all Accelerometer data."];
    } else {
        [self showAlertMessage:@"Failed to clear Accelerometer data."];
    }
}

- (IBAction)addBump:(id)sender {
    [self.motionData addBump];
}

- (void) showAlertMessage:(NSString *)myMessage {
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"Alert message" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okey" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
