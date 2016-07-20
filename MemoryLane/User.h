//
//  User.h
//  MemoryLane
//
//  Created by tstone10 on 7/14/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface User : NSObject

@property (strong, nonatomic) FBSDKAccessToken *token;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSMutableArray *photos;

+(instancetype)getInstance;
-(void)setAccessToken:(FBSDKLoginManagerLoginResult *) loginResult;

@end
