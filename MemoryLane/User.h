//
//  User.h
//  HitchikersGuide
//
//  Created by tstone10 on 6/29/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface User : NSObject

@property (strong, nonatomic) FBSDKAccessToken *token;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *displayName;

+(instancetype)getInstance;
-(void)setAccessToken:(FBSDKLoginManagerLoginResult *) loginResult;

@end
