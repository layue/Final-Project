//
//  MotionData.h
//  BumpDetection
//
//  Created by 徐冰 on 13/03/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "DBManager.h"

@interface MotionData : NSObject

@property CMMotionManager *motionManager;
@property (strong, nonatomic) NSMutableArray *bumpSmoothRecord;

- (BOOL) startCaptureData;
- (void) addBump;
- (void) stopCaptureData;

@end
