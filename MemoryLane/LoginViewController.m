//
//  ViewController.m
//  MemoryLane
//
//  Created by tstone10 on 7/14/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
@import Firebase;

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation LoginViewController

FIRDatabaseReference *ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginButton = [[FBSDKLoginButton alloc]initWithFrame:CGRectZero];
    _loginButton.center = self.view.center;
    [self.view addSubview:_loginButton];
    [_loginButton setDelegate:self];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)createLoadingScreen {
    UIView *appLoadingView;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    appLoadingView = [[UIView alloc] initWithFrame:screenRect];
    [appLoadingView setBackgroundColor:[UIColor colorWithRed:0 green:0.508 blue:0.508 alpha:1]];
    
    [appLoadingView addSubview:[self createAppNameLabelForScreenRect:screenRect]];
    [appLoadingView addSubview:[self createLoadingTextLabelForScreenRect:screenRect]];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [appLoadingView addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    return appLoadingView;
}

-(UILabel *)createAppNameLabelForScreenRect:(CGRect)screenRect {
    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenRect.size.width/2)-150, 150, 300, 60)];
    appNameLabel.text = @"Memory Lane";
    appNameLabel.textColor = [UIColor whiteColor];
    [appNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    
    return appNameLabel;
}

-(UILabel *)createLoadingTextLabelForScreenRect:(CGRect)screenRect {
    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenRect.size.width/2)-150, 350, 300, 60)];
    appNameLabel.text = @"Loading...";
    appNameLabel.textColor = [UIColor whiteColor];
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    
    return appNameLabel;
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error == nil) {
        
        [self.view addSubview:[self createLoadingScreen]];
        
        [self loginToFirebase:^(FIRUser *user){
            ref = [[FIRDatabase database] reference];
            
            //before we navigate, figure out the user object stuff in firebase
            [[ref child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSMutableDictionary *userObject;
                
                if(snapshot.value[[user uid]] == nil) {
                    //no object, create an empty one and push to firebase
                    userObject = [@{[user uid]: @{@"token": @"",
                                            @"displayName": @"",
                                                 @"photos": @""}
                    } mutableCopy];
                    [[ref child:@"users"] updateChildValues:userObject];
                }
                else {
                    //use the current one
                    userObject = [snapshot.value[[user uid]] mutableCopy];                    
                    //NSLog(@"userObject = %@", userObject);
                }
                
                //do something to put user object into app memory here, once models are ready
                [[User getInstance]setAccessToken:result];
                if ([User getInstance]) {
                    [User getInstance].userID = [user uid];
                    [User getInstance].displayName = user.displayName;
                    //[User getInstance].photos = userObject.photos;
                    //-- create logic to retrieve photos from photos node with current user UID
                }
                
                [self performSegueWithIdentifier:@"loginToHomeViewSegue" sender:loginButton];
            } withCancelBlock:^(NSError * _Nonnull error) {
                NSLog(@"cancel block error: %@", error.localizedDescription);
            }];
        }];
        
    } else {
        NSLog(error.localizedDescription);
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        NSLog(@"Signed out successfully.");
    }
    
}

- (void)loginToFirebase:(void(^)(FIRUser *user))callbackBlock {
    //grab token from the fb auth provider
    FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
    
    //then sign in to firebase with it
    [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error) {
        if(error == nil) {
            //add in a force refresh to help mitigate issues with firebase not responding
            [user getTokenForcingRefresh:YES completion:^(NSString *token, NSError *error){
                callbackBlock(user);
            }];
        }
        else {
            NSLog(error.localizedDescription);
        }
    }];
}

@end
