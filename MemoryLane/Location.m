//
//  Location.m
//  MemoryLane
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "Location.h"

@implementation Location

-(instancetype)initWithAddress:(NSString *)address andLat:(int)lat andLng:(int)lng {
    self = [super init];
    
    if (self) {
        _address = address;
        _lat = lat;
        _lng = lng;
    }
    return self;
}

@end
