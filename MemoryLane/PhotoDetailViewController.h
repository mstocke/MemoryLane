//
//  PhotoDetailViewController.h
//  MemoryLane
//
//  Created by tstone10 on 7/27/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "Themer.h"

@interface PhotoDetailViewController : UIViewController

@property(strong, nonatomic)Photo *photo;

//IBOutletCollections
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titles;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *subs;

@end
