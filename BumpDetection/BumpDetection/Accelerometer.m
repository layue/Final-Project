//
//  Accelerometer.m
//  BumpDetection
//
//  Created by 徐冰 on 24/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import "Accelerometer.h"

@implementation Accelerometer

- (void) accelerationData {

    NSMutableArray *acc = [[NSMutableArray alloc] init];
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.02;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 NSDate *timestamp = [NSDate date];
                                                 double xAcc = accelerometerData.acceleration.x;
                                                 double yAcc = accelerometerData.acceleration.y;
                                                 double zAcc = accelerometerData.acceleration.z;
                                                 
//                                                 xAcc,yAcc,zAcc can be deleted later
                                                 if (acc.count < 50) {
                                                     [acc addObject:@[timestamp, [NSNumber numberWithDouble:xAcc], [NSNumber numberWithDouble:yAcc], [NSNumber numberWithDouble:zAcc]]];
                                                 }
                                                 else {
                                                     if([self writeBuffer:acc]) {                                                     [acc removeAllObjects];
                                                     } else {
                                                         NSLog(@"Failed to write buffer to disk.");
                                                     }
                                                 }

//                                                 NSLog(@"%f %f %f", xAcc, yAcc, zAcc);
                                                 
                                                 if(!error) { NSLog(@"%@", error); }
    }];
}

- (BOOL) writeBuffer:(NSMutableArray *) buffer {
//      Only create db the first time
    return [[DBManager getSharedInstance] saveData:buffer];
}

@end
