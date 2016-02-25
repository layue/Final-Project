//
//  Gyroscope.m
//  BumpDetection
//
//  Created by 徐冰 on 25/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import "Gyroscope.h"

@implementation Gyroscope

- (NSMutableArray *) gyroscopeData {
    NSMutableArray *rotation = [[NSMutableArray alloc] init];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.gyroUpdateInterval = .2;
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        xGyro = gyroData.rotationRate.x;
                                        yGyro = gyroData.rotationRate.y;
                                        zGyro = gyroData.rotationRate.z;
                                        
                                        NSLog(@"%f %f %f", xGyro, yGyro, zGyro);
                                        
                                        if (error) { NSLog(@"%@", error);}
    }];
    
    [rotation addObjectsFromArray:@[[NSNumber numberWithDouble:xGyro], [NSNumber numberWithDouble:yGyro], [NSNumber numberWithDouble:zGyro]]];
    
    return rotation;
}
@end
