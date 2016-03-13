//
//  ViewController.h
//  BumpDetection
//
//  Created by 徐冰 on 22/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kMeansCluster.h"
#import "DBManager.h"
#import "MotionData.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) kMeansCluster *kMeans;
@property (strong, nonatomic) MotionData *motionData;

@end

