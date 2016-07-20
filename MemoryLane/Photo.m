//
//  Photo.m
//  MemoryLane
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "Photo.h"
#import "Location.h"

@implementation Photo

-(instancetype)initWithName:(NSString *)name andDesc:(NSString *)desc andLocation:(Location *)location andDate:(NSString *)date andFavorite:(BOOL)favorite {
    self = [super init];
    
    if (self) {
        _name = name;
        _desc = desc;
        _location = location;
        _date = date;
        _favorite = favorite;
    }
    return self;
}

@end
