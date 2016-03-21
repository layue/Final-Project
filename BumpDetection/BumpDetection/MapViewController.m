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

    _mapView = [GMSMapView mapWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - 40) camera:[GMSCameraPosition cameraWithLatitude:33 longitude:50 zoom:10]];
    
    _mapView.myLocationEnabled = YES;
    
    _mapView.settings.myLocationButton = YES;
    _mapView.settings.compassButton = YES;
    
    
    [_mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    [self.view addSubview:_mapView];
//    self.view = _mapView;
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
//        <+53.47480881,-2.22818378> +/- 30.00m (speed 0.46 mps / course 350.51) @ 20/03/2016, 23:24:25 Greenwich Mean Time
    }
}

- (IBAction)addBumpMarker:(id)sender {
    [self addMarkers:(_mapView.myLocation.coordinate)];
    NSLog(@"%@", _mapView.myLocation);
}

- (void) addMarkers:(CLLocationCoordinate2D) markerCoordinate {
    GMSMarker *marker = [[GMSMarker alloc] init];
    
    marker.position = markerCoordinate;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.title = @"Bump";
//change marker color
//    marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]];
    marker.map = _mapView;
}

@end
