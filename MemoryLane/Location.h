//
//  Location.h
//  MemoryLane
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (strong, nonatomic) NSString *address;
@property (nonatomic) int lat;
@property (nonatomic) int lng;

-(instancetype)initWithAddress:(NSString *)address andLat:(int)lat andLng:(int)lng;

@end
