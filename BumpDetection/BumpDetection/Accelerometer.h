//
//  Accelerometer.h
//  BumpDetection
//
//  Created by 徐冰 on 24/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "DBManager.h"

@interface Accelerometer : NSObject

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSMutableArray *bumpSmoothRecord;

- (void) accelerationData;
- (void) stopAccelerometer;
- (void) addBump;

@end
