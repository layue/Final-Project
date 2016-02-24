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
    
//    move window average
//    NSArray *rawData = @[@1,@2,@5,@8,@6,@4,@7,@3];
//    NSMutableArray *result = [self.kMeans getCentralValue:rawData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startCaptureData:(id)sender {
    NSMutableArray *accData = [[NSMutableArray alloc] init];
    accData = [self.accelerometer accelerationData];

    self.xAcceleration.text = [accData[0] stringValue];
    self.yAcceleration.text = [accData[1] stringValue];
    self.zAcceletation.text = [accData[2] stringValue];
}

@end
