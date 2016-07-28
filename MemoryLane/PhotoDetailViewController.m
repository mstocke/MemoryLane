//
//  PhotoDetailViewController.m
//  MemoryLane
//
//  Created by tstone10 on 7/27/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "PhotoDetailViewController.h"

@interface PhotoDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *photoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoDateLabel;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayPhotoDetails];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayPhotoDetails {
    _photoImage.image = _photo.imgPath;
    _photoNameLabel.text = _photo.name;
    _photoDescriptionLabel.text = _photo.desc;
    _photoDateLabel.text = _photo.date;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
