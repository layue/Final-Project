//
//  Accelerometer.m
//  BumpDetection
//
//  Created by 徐冰 on 24/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import "Accelerometer.h"

@implementation Accelerometer

- (NSMutableArray *) accelerationData {

    NSMutableArray *acc = [[NSMutableArray alloc] init];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 xAcc = accelerometerData.acceleration.x;
                                                 yAcc = accelerometerData.acceleration.y;
                                                 zAcc = accelerometerData.acceleration.z;
                                                 
//                                                 NSLog(@"%f %f %f", xAcc, yAcc, zAcc);
                                                 
                                                 if(error) { NSLog(@"%@", error); }
    }];
    
    [acc addObjectsFromArray:@[[NSNumber numberWithDouble:xAcc], [NSNumber numberWithDouble:yAcc], [NSNumber numberWithDouble:zAcc]]];
    return acc;
}
@end
