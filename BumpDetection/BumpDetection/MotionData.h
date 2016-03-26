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

@protocol AddMapMarkerDelegate <NSObject>

- (void) addMarkerX:(double)x Y:(double) y Z:(double) z;

@end

@interface MotionData : NSObject

@property CMMotionManager *motionManager;
@property (strong, nonatomic) NSMutableArray *bumpSmoothRecord;
@property (weak) id <AddMapMarkerDelegate> markerDelegate;

- (BOOL) startCaptureData;
- (void) stopCaptureData;

@end
