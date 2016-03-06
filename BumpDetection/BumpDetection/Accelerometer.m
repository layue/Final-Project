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
    self.bumpSmoothRecord = [[NSMutableArray alloc] init];
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 NSDate *timestamp = [NSDate date];
                                                 double xAcc = accelerometerData.acceleration.x;
                                                 double yAcc = accelerometerData.acceleration.y;
                                                 double zAcc = accelerometerData.acceleration.z;
                                                 
//                                                 xAcc,yAcc,zAcc can be deleted later
                                                 if (acc.count < 50) {
                                                     [acc addObject:@[timestamp, [NSNumber numberWithDouble:xAcc], [NSNumber numberWithDouble:yAcc], [NSNumber numberWithDouble:zAcc], [NSMutableString stringWithFormat:@"Smooth"]]];
                                                 }
                                                 else {
                                                     if([self writeBuffer:acc]) {                                                     [acc removeAllObjects];
                                                     } else {
                                                         NSLog(@"Failed to write buffer to disk.");
                                                     }
                                                 }
                                                 
                                                 if(error != NULL) { NSLog(@"There is an error.%@", error); }
    }];
}

- (void) stopAccelerometer {
    [self.motionManager stopAccelerometerUpdates];
}

- (BOOL) writeBuffer:(NSMutableArray *) buffer {
//      Only create db the first time
    for (id obj in buffer){
        if ([self.bumpSmoothRecord count] > 0) {
            
            int FROM = 0;
            int TO = 1;
            int LABLE = 2;
            if ([obj[0] compare:self.bumpSmoothRecord[0][FROM]] == NSOrderedDescending) {
                if ([obj[0] compare:self.bumpSmoothRecord[0][TO]] == NSOrderedAscending) {
                    [obj[4] setString:self.bumpSmoothRecord[0][LABLE]];
                } else {
                    [self.bumpSmoothRecord removeObjectAtIndex:0];
                }
            }
        }
    }

    return [[DBManager getSharedInstance] saveData:buffer];
}

- (void) addBump {
    NSDate *from = [NSDate dateWithTimeIntervalSinceNow:-1];
    NSDate *to = [NSDate dateWithTimeIntervalSinceNow:1];
    if ([self.bumpSmoothRecord count] > 0) {
        NSUInteger last = [self.bumpSmoothRecord count] - 1;
        int TO = 1;
        if ([from compare:self.bumpSmoothRecord[last][TO]] == NSOrderedAscending) {
            [self.bumpSmoothRecord[last] replaceObjectAtIndex:TO withObject:to];
        } else {
            [self.bumpSmoothRecord addObject:[NSMutableArray arrayWithObjects:from, to, @"Bump", nil]];
        }
    } else {
        [self.bumpSmoothRecord addObject:[NSMutableArray arrayWithObjects:from, to, @"Bump", nil]];
    }
}

@end
