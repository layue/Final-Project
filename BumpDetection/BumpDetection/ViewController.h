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
#import "DBManager.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) kMeansCluster *kMeans;
@property (strong, nonatomic) Accelerometer *accelerometer;
@property (strong, nonatomic) Gyroscope *gyroscope;
@property (strong, nonatomic) DBManager *dbManager;

@end

