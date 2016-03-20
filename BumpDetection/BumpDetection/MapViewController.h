//
//  MapViewController.h
//  BumpDetection
//
//  Created by 徐冰 on 14/03/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
