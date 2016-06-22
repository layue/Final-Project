//
//  MotionData.h
//  BumpDetection
//
//  Created by 徐冰 on 13/03/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import "DBManager.h"

@protocol AddMapMarkerDelegate <NSObject>

- (void) addMarkerX:(double)x Y:(double) y Z:(double) z;

@end

@protocol AlertDelegate <NSObject>

- (void) showAlertMessage:(NSString *) myMessage;

@end

@interface MotionData : NSObject <CLLocationManagerDelegate>

@property CMMotionManager *motionManager;
@property CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *bumpSmoothRecord;
@property (strong, nonatomic) NSMutableArray *accData;
@property (weak) id <AddMapMarkerDelegate> markerDelegate;
@property (weak) id <AlertDelegate> alertDelegate;

- (BOOL) startCaptureData;
- (void) stopCaptureData;
- (BOOL) writeBufferToDB:(NSMutableArray *) buffer;
- (NSArray *) getDBRecord;
//- (void) addBump;
@end
