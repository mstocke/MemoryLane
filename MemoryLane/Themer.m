//
//  Themer.m
//  MemoryLane
//
//  Created by tstone10 on 7/28/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "Themer.h"
#import "LoginViewController.h"
#import "MapViewController.h"
#import "PhotosTableViewController.h"
#import "PhotoDetailViewController.h"

@implementation Themer

-(void)themeButtons:(NSArray *)buttons {
    for (UIButton *btn in buttons) {
        btn.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 0;
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = [[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0] CGColor];
        btn.layer.backgroundColor = [[UIColor colorWithRed:0.0f/255.0f green:48.0f/255.0f blue:103/255.0f alpha:1.0] CGColor];
        
        [btn.layer setShadowOffset:CGSizeMake(2, 2)];
        [btn.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [btn.layer setShadowOpacity:0.5];
    }
}

-(void)themeLabels:(NSArray *)labels {
    for (UILabel *lbl in labels) {
        lbl.font = [UIFont fontWithName:@"Avenir" size:17];
        //lbl.textColor = [UIColor whiteColor];
        lbl.textColor = [UIColor colorWithRed:0.0/255.0f green:48.0/255.0f blue:103.0/255.0f alpha:1.0f];
    }
}

-(void)themeTitleLabels:(NSArray *)titles {
    for (UILabel *ttl in titles) {
        ttl.font = [UIFont fontWithName:@"Avenir-Heavy" size:25];
        ttl.textColor = [UIColor colorWithRed:0.0/255.0f green:48.0/255.0f blue:103.0/255.0f alpha:1.0f];
    }
}

-(void)themeSubTitleLabels:(NSArray *)subs {
    for (UILabel *sub in subs) {
        sub.font = [UIFont fontWithName:@"Avenir" size:17];
        sub.textColor = [UIColor colorWithRed:0.0/255.0f green:48.0/255.0f blue:103.0/255.0f alpha:1.0f];
    }
}

-(void)themeTextFields:(NSArray *)textFields {
    for (UITextField *tf in textFields) {
        tf.font = [UIFont systemFontOfSize:20];
        tf.layer.cornerRadius = 5;
        tf.layer.masksToBounds = YES;
        tf.layer.borderWidth = 1.0f;
        tf.layer.borderColor = [[UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1.0] CGColor];
    }
}

-(void)themeAppBackgroundImage:(UIViewController *)controller {
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue_circles"]];
    [controller.view insertSubview:backgroundImage atIndex:0];
}

@end
