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

    _mapView.myLocationEnabled = YES;
    
    _mapView.settings.myLocationButton = YES;
    _mapView.settings.compassButton = YES;
    
    [_mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    self.view = _mapView;
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
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
            NSLog(@"%@", _mapView.myLocation);
    }
}

@end
