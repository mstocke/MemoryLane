//
//  User.m
//  MemoryLane
//
//  Created by tstone10 on 7/14/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "User.h"

@implementation User

+(instancetype)getInstance {
    static User *applicationUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        applicationUser = [[User alloc]initPrivately];
    });
    return applicationUser;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[User sharedAccessToken]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivately {
    self = [super init];
    return self;
}

- (void)setAccessToken:(FBSDKLoginManagerLoginResult *)loginResult {
    _token = loginResult.token;
}

@end
