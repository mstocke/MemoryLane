//
//  Themer.h
//  MemoryLane
//
//  Created by tstone10 on 7/28/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Themer : NSObject

-(void)themeButtons:(NSArray *)buttons;
-(void)themeLabels:(NSArray *)labels;
-(void)themeTextFields:(NSArray *)textFields;
-(void)themeAppBackgroundImage:(UIViewController *)controller;

@end
