//
//  ViewController.h
//  BumpDetection
//
//  Created by 徐冰 on 22/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kMeansCluster.h"
#import "Accelerometer.h"
#import "Gyroscope.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *xAcceleration;
@property (weak, nonatomic) IBOutlet UILabel *yAcceleration;
@property (weak, nonatomic) IBOutlet UILabel *zAcceletation;
@property (weak, nonatomic) IBOutlet UILabel *xRotation;
@property (weak, nonatomic) IBOutlet UILabel *yRotation;
@property (weak, nonatomic) IBOutlet UILabel *zRotation;

@property (strong, nonatomic) kMeansCluster *kMeans;
@property (strong, nonatomic) Accelerometer *accelerometer;
@property (strong, nonatomic) Gyroscope *gyroscope;

@end

