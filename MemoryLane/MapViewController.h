//
//  MapViewController.h
//  MemoryLane
//
//  Created by tstone10 on 7/14/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;

@interface MapViewController : UIViewController

//IBOutletCollections
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property BOOL newPic;

@end
