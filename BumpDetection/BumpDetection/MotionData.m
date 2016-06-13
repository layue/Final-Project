//
//  MotionData.m
//  BumpDetection
//
//  Created by 徐冰 on 13/03/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import "MotionData.h"
@import UIKit;

@implementation MotionData

- (BOOL) startCaptureData {
    BOOL isSuccess = YES;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.bumpSmoothRecord = [[NSMutableArray alloc] init];
    NSMutableArray *accData = [[NSMutableArray alloc] init];
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    if (!self.motionManager.deviceMotionAvailable) {
        isSuccess = NO;
        return isSuccess;
    }
    
//Push method
    self.motionManager.deviceMotionUpdateInterval = 1.0/100;
    
    CMDeviceMotionHandler dmHandler = ^(CMDeviceMotion *motion, NSError * error){
        CMAcceleration acc = motion.userAcceleration;
        CMRotationMatrix rotMtx = motion.attitude.rotationMatrix;

        double x = acc.x * rotMtx.m11 + acc.y * rotMtx.m21 + acc.z * rotMtx.m31;
        double y = acc.x * rotMtx.m12 + acc.y * rotMtx.m22 + acc.z * rotMtx.m32;
        double z = acc.x * rotMtx.m12 + acc.y * rotMtx.m23 + acc.z * rotMtx.m33;
//use a threshold to detect bump, but depending on high or low speed, the threshold should change
        if (fabs(z) >= 0.2) {
            [self.markerDelegate addMarkerX:x Y:y Z:z];
            
            NSLog(@"There is a bump!");
        
            if (accData.count < 500) {
                [accData addObject:@[[NSDate date], [NSString stringWithFormat:@"%.3f", x], [NSString stringWithFormat:@"%.3f", y], [NSString stringWithFormat:@"%.3f", z], [NSMutableString stringWithString:@""],[NSNumber numberWithFloat:[UIDevice currentDevice].batteryLevel]]];
            } else {
                if ([self writeBufferToDB:accData]) {
                    [accData removeAllObjects];
                } else {
                    NSLog(@"Failed to write buffer to database.");
                }
            }
        }
        //else ignore the event
    };
    //End of handler block
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:dmHandler];
    
    return isSuccess;
}

- (void) stopCaptureData {
    [self.motionManager stopDeviceMotionUpdates];
}

//Use this method to store original Smooth and Bumpy data to analyse. Can be delete after analyse
- (BOOL) writeBufferToDB:(NSMutableArray *) buffer {
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
    } //because now all records are labled as Bump, so do not need change Smooth to Bump
    
    return [[DBManager getSharedInstance] saveData:buffer];
}

- (void) addBump {
    NSDate *from = [NSDate dateWithTimeIntervalSinceNow:-0.5];
    NSDate *to = [NSDate date];
    
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
