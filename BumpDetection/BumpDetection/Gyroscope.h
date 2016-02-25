//
//  Gyroscope.h
//  BumpDetection
//
//  Created by 徐冰 on 25/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface Gyroscope : NSObject
{
    double xGyro;
    double yGyro;
    double zGyro;
}

@property (strong, nonatomic) CMMotionManager *motionManager;
- (NSMutableArray *) gyroscopeData;

@end
