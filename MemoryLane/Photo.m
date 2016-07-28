//
//  Photo.m
//  MemoryLane
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(instancetype)initWithImagePath: (UIImage *)imgPath andName:(NSString *)name andDesc:(NSString *)desc andLat:(NSString *)lat andLong:(NSString *)lng andDate:(NSString *)date andFavorite:(BOOL)favorite {
    self = [super init];
    
    if (self) {
        _imgPath = imgPath;
        _name = name;
        _desc = desc;
        _lat = lat;
        _lng = lng;
        _date = date;
        _favorite = favorite;
    }
    return self;
}

@end
