//
//  Accelerometer.h
//  BumpDetection
//
//  Created by 徐冰 on 24/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface Accelerometer : NSObject
{
    double xAcc;
    double yAcc;
    double zAcc;
}

@property (strong, nonatomic) CMMotionManager *motionManager;
- (NSMutableArray *) accelerationData;

@end
