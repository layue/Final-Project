//
//  MotionData.m
//  BumpDetection
//
//  Created by 徐冰 on 13/03/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import "MotionData.h"

@implementation MotionData

- (BOOL) startCaptureData {
    BOOL isSuccess = YES;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.bumpSmoothRecord = [[NSMutableArray alloc] init];
    NSMutableArray *accData = [[NSMutableArray alloc] init];
    
    if (!self.motionManager.deviceMotionAvailable) {
        isSuccess = NO;
        return isSuccess;
    }
    
    self.motionManager.deviceMotionUpdateInterval = 1;
    
    CMDeviceMotionHandler dmHandler = ^(CMDeviceMotion *motion, NSError * error){
        CMAcceleration acc = motion.userAcceleration;
        CMRotationMatrix rotMtx = motion.attitude.rotationMatrix;
        
        double x = acc.x * rotMtx.m11 + acc.y * rotMtx.m21 + acc.z * rotMtx.m31;
        double y = acc.x * rotMtx.m12 + acc.y * rotMtx.m22 + acc.z * rotMtx.m32;
        double z = acc.x * rotMtx.m12 + acc.y * rotMtx.m23 + acc.z * rotMtx.m33;
        
        NSString *xAcc = [NSString stringWithFormat:@"%.2f", x];
        NSString *yAcc = [NSString stringWithFormat:@"%.2f", y];
        NSString *zAcc = [NSString stringWithFormat:@"%.2f", z];
        NSLog(@"xAcc = %@, yAcc = %@, zAcc = %@", xAcc, yAcc, zAcc);
        
        if (accData.count < 50) {
            [accData addObject:@[[NSDate date], xAcc, yAcc, zAcc, [NSMutableString stringWithFormat:@"Smooth"]]];
        } else {
            if ([self writeBufferToDB:accData]) {
                [accData removeAllObjects];
            } else {
                NSLog(@"Failed to write buffer to database.");
            }
        }
    };
    //End of handler block
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical toQueue:[NSOperationQueue currentQueue] withHandler:dmHandler];
    
    return isSuccess;
}

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

- (void) stopCaptureData {
    [self.motionManager stopDeviceMotionUpdates];
}

@end
