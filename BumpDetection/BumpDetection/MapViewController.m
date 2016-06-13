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
    NSMutableArray *accData;
}

-(void) showHideNavbar:(id) sender
{
    // write code to show/hide nav bar here
    // check if the Navigation Bar is shown
    if (self.navigationController.navigationBar.hidden == NO)
    {
        // hide the Navigation Bar
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    // if Navigation Bar is already hidden
    else if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];

    _mapView = [[GMSMapView  alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - 40)];
    
    _mapView.myLocationEnabled = YES;
    _mapView.settings.myLocationButton = YES;
    _mapView.settings.compassButton = YES;
    
    [_mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
//    [self.view addSubview:_mapView];
    self.view = _mapView;
    
    MotionData *motionData = [[MotionData alloc] init];
    motionData.markerDelegate = self;
    [motionData startCaptureData];
    
    accData = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideNavbar:)];
    [self.view addGestureRecognizer:tapGesture];
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
    [self addMarkerX:0 Y:0 Z:0];
}

- (void) addMarkerX:(double)x Y:(double)y Z:(double)z
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    GMSGeocoder *geocoder = [[GMSGeocoder alloc] init];
    
    GMSReverseGeocodeCallback RGHdl = ^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
        GMSAddress *address = response.firstResult;
        marker.position = address.coordinate;
        marker.title = address.thoroughfare;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = _mapView;
        
        if (accData.count < 10) {
            [accData addObject:@[[NSDate date], [NSNumber numberWithDouble:x], [NSNumber numberWithDouble:y], [NSNumber numberWithDouble:z], [NSNumber numberWithDouble:marker.position.latitude], [NSNumber numberWithDouble:marker.position.longitude], marker.title, [NSNumber numberWithDouble:_mapView.myLocation.course]]];
        } else {
            if ([[DBManager getSharedInstance] saveData:accData]) {
                [accData removeAllObjects];
            } else {
                NSLog(@"Failed to write buffer to database.");
            }
        }
    };
    [geocoder reverseGeocodeCoordinate:_mapView.myLocation.coordinate completionHandler:RGHdl];
}

@end
