//
//  Photo.h
//  MemoryLane
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *date;
@property (nonatomic) BOOL favorite;

-(instancetype)initWithName:(NSString *)name andDesc:(NSString *)desc andLocation:(NSString *)location andDate:(NSString *)date andFavorite:(BOOL)favorite;

@end
