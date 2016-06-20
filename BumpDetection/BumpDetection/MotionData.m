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
    self.locationManager = [[CLLocationManager alloc] init];
    self.bumpSmoothRecord = [[NSMutableArray alloc] init];
    self.accData = [[NSMutableArray alloc] init];
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    if (!self.motionManager.deviceMotionAvailable || ![CLLocationManager locationServicesEnabled]) {
        isSuccess = NO;
        return isSuccess;
    }
    
//Motion sensors start. Push method
    self.motionManager.deviceMotionUpdateInterval = 1;
    
    CMDeviceMotionHandler dmHandler = ^(CMDeviceMotion *motion, NSError * error){
        CMAcceleration acc = motion.userAcceleration;
        CMRotationMatrix rotMtx = motion.attitude.rotationMatrix;
        NSMutableArray *tempAccData = [[NSMutableArray alloc] init];

        double x = acc.x * rotMtx.m11 + acc.y * rotMtx.m21 + acc.z * rotMtx.m31;
        double y = acc.x * rotMtx.m12 + acc.y * rotMtx.m22 + acc.z * rotMtx.m32;
        double z = acc.x * rotMtx.m12 + acc.y * rotMtx.m23 + acc.z * rotMtx.m33;
//use a threshold to detect bump, but depending on high or low speed, the threshold should change
        if (fabs(z) >= 0.5) {
            [self.markerDelegate addMarkerX:x Y:y Z:z];
            
            NSLog(@"There is a bump!");
        
            if (self.accData.count < 500) {
//accData structure: timestamp, accX, accY, accZ, lantitude, longitude, course, speed, battery level, street number and name
                [tempAccData addObjectsFromArray:@[[NSDate date], [NSString stringWithFormat:@"%.3f", x], [NSString stringWithFormat:@"%.3f", y], [NSString stringWithFormat:@"%.3f", z], [NSString stringWithFormat:@"%.5f", self.locationManager.location.coordinate.latitude], [NSString stringWithFormat:@"%.5f", self.locationManager.location.coordinate.longitude], [NSNumber numberWithDouble:self.locationManager.location.course], [NSNumber numberWithDouble:self.locationManager.location.speed], [NSNumber numberWithFloat:[UIDevice currentDevice].batteryLevel]]];
                
                
                CLGeocodeCompletionHandler CLGHandler = ^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                    //判断是否有错误或者placemarks是否为空
                    if (error !=nil || placemarks.count==0) {
                        NSLog(@"%@",error);
                        return ;
                    }
                    [tempAccData addObject: [placemarks lastObject].name];
                    
                    [self.accData addObject:tempAccData];
                    //TODO: log. Delete later
                    NSLog(@"%@", [self.accData lastObject]);
                };
                CLGeocoder *geocoder=[[CLGeocoder alloc] init];
//Reverse geocode, from location to address description
                [geocoder reverseGeocodeLocation:self.locationManager.location completionHandler: CLGHandler];

            } else {
                if ([self writeBufferToDB:self.accData]) {
                    [self.accData removeAllObjects];
                } else {
                    NSLog(@"Failed to write buffer to database.");
                }
            }
        }
        //else ignore the event
    };
    //End of handler block
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:dmHandler];
    
//Start location service
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = 500; // meters
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    return isSuccess;
}

//The location manager reports events to the locationManager:didUpdateLocations: method of its delegate when they become available
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    CLLocation* location = [locations lastObject];
//    NSDate* eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (fabs(howRecent) < 15.0) {
//        // If the event is recent, do something with it.
//        NSLog(@"latitude %+.6f, longitude %+.6f\n",
//              location.coordinate.latitude,
//              location.coordinate.longitude);
//    }
//}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.alertDelegate showAlertMessage:@"Cannot update your location! Please try again later."];
}

- (void) stopCaptureData {
    [self.motionManager stopDeviceMotionUpdates];
    [self.locationManager stopUpdatingLocation];
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

@end
