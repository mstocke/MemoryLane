//
//  MapViewController.m
//  MemoryLane
//
//  Created by tstone10 on 7/14/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "MapViewController.h"
@import GoogleMaps;

@implementation MapViewController {
    GMSMapView *mapView_;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    //ref = [[FIRDatabase database] reference];
    [self configureMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Draw Map paths

//-(void)getCurrentLocation {
//
//}

-(void)configureMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.3313
                                                            longitude:-83.1998
                                                                 zoom:10];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.scrollGestures = YES;
    mapView_.settings.zoomGestures = YES;
    
    self.view = mapView_;
}

@end
