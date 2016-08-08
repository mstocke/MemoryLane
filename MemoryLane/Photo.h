//
//  Photo.h
//  MemoryLane
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *imgPath;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *date;
@property (nonatomic) BOOL favorite;

-(instancetype)initWithImagePath:(NSString *)imgPath andImage:(UIImage *)image andName:(NSString *)name andDesc:(NSString *)desc andLat:(NSString *)lat andLong:(NSString *)lng andDate:(NSString *)date andFavorite:(BOOL)favorite andUID:(NSString *)uid;

@end
