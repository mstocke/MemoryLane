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

@interface PhotoDetailViewController : UIViewController <UITextFieldDelegate> 

@property(strong, nonatomic)Photo *photo;

//Properties
@property (strong, nonatomic) NSString *mode;
@property (strong, nonatomic) NSString *imgPath;
@property (strong, nonatomic) NSString *currentPhotoKey;

//IBOutletCollections
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titles;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *subs;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *titleFields;
@property (strong, nonatomic) IBOutletCollection(UITextView) NSArray *textViews;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@end
