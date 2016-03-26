//
//  MapViewController.m
//  BumpDetection
//
//  Created by 徐冰 on 14/03/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import "MapViewController.h"
@import GoogleMaps;

@implementation MapViewController {
    BOOL firstLocationUpdate;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[GMSMapView alloc] init];

    _mapView = [[GMSMapView  alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - 40)];
    
    _mapView.myLocationEnabled = YES;
    _mapView.settings.myLocationButton = YES;
    _mapView.settings.compassButton = YES;
    
//    _mapView.myLocation.course
    
    [_mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    [self.view addSubview:_mapView];
    
    MotionData *motionData = [[MotionData alloc] init];
    motionData.markerDelegate = self;
    [motionData startCaptureData];

}

- (void)dealloc {
    [_mapView removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that location.
        firstLocationUpdate = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];

//        NSLog(@"%f", _mapView.myLocation.course);
    }
}

- (IBAction)addBumpMarker:(id)sender {
//    [self addMarkers:(_mapView.myLocation.coordinate)];
    NSLog(@"%@", _mapView.myLocation);
}

- (void) addMarker {
    GMSMarker *marker = [[GMSMarker alloc] init];
    GMSGeocoder *geocoder = [[GMSGeocoder alloc] init];
    
    GMSReverseGeocodeCallback RGHdl = ^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
        GMSAddress *address = response.firstResult;
        marker.position = address.coordinate;
        marker.title = address.thoroughfare;
        marker.snippet = [NSString stringWithFormat:@"%f", _mapView.myLocation.course];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = _mapView;
    };
    [geocoder reverseGeocodeCoordinate:_mapView.myLocation.coordinate completionHandler:RGHdl];
//change marker color
//    marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]];
   
}

@end
