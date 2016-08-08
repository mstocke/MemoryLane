//
//  PhotoDetailViewController.m
//  MemoryLane
//
//  Created by tstone10 on 7/27/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "User.h"
#import "MapViewController.h"
@import FirebaseDatabase;
@import Firebase;
@import FirebaseStorage;

@interface PhotoDetailViewController ()

//@property (strong, nonatomic) Photo *currentPhoto;
@property (strong, nonatomic) FIRDatabaseReference *photosRef;

#pragma mark IBOutlets
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *photoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *photoNameEditField;
@property (weak, nonatomic) IBOutlet UITextView *photoDescriptionEditField;
@property (weak, nonatomic) IBOutlet UIButton *editPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *savePhotoButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _photosRef = [[[FIRDatabase database]reference]child:@"photos"];

    //_mode = [[NSString alloc] init];
    //_mode = @"edit";
    
    if ([_mode isEqualToString:@"edit"]) {
        [self editPhotoDetails];
    } else if ([_mode isEqualToString:@"new"]) {
        //[self newPhotoDetails];
        [self getNewPhotoObject];
    } else {
        [self displayPhotoDetails];
    }
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tapScroll];
    self.photoNameEditField.delegate = self;
    
    [self customUISetup];
}

- (void) tapped {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    [super viewWillDisappear:animated];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin = self.savePhotoButton.frame.origin;
    CGFloat buttonHeight = self.savePhotoButton.frame.size.height;
    CGRect visibleRect = self.view.frame;
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.photoNameEditField resignFirstResponder];
//    [self.photoDescriptionEditField resignFirstResponder];
//}

-(void)customUISetup {
    Themer *mvcTheme = [[Themer alloc]init];
    [mvcTheme themeLabels: _labels];
    [mvcTheme themeTitleLabels: _titles];
    [mvcTheme themeSubTitleLabels: _subs];
    [mvcTheme themeTitleTextFields: _titleFields];
    [mvcTheme themeTextViews: _textViews];
    [mvcTheme themeButtons: _buttons];
    [mvcTheme themeAppBackgroundImage: self];
    _photoDescriptionLabel.numberOfLines = 0;
    [_photoDescriptionLabel sizeToFit];
}

- (void)displayPhotoDetails {
    _photoNameLabel.hidden = FALSE;
    _photoDateLabel.hidden = FALSE;
    _photoDescriptionLabel.hidden = FALSE;
    _editPhotoButton.hidden = FALSE;
    
    _photoNameEditField.hidden = TRUE;
    _photoDescriptionEditField.hidden = TRUE;
    _savePhotoButton.hidden = TRUE;
    
    _photoImage.image = _photo.image;
    _photoImage.contentMode = UIViewContentModeScaleAspectFit;
    _photoNameLabel.text = _photo.name;
    _photoDateLabel.text = _photo.date;
    _photoDescriptionLabel.text = _photo.desc;
}

- (void)editPhotoDetails {
    _photoNameEditField.hidden = FALSE;
    _photoNameEditField.text = _photo.name;
    _photoDescriptionEditField.hidden = FALSE;
    _photoDescriptionEditField.text = _photo.desc;
    _savePhotoButton.hidden = FALSE;
    _photoNameEditField.returnKeyType = UIReturnKeyDone;
    //_photoDescriptionEditField.returnKeyType = UIReturnKeyDone;
    
    _photoNameLabel.hidden = TRUE;
    _photoDateLabel.hidden = TRUE;
    _photoDescriptionLabel.hidden = TRUE;
    _editPhotoButton.hidden = TRUE;
    
    _photoImage.image = _photo.image;
    _photoImage.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)getNewPhotoObject {
    //FIRDatabaseReference *photosRef = [[[FIRDatabase database]reference]child:@"photos"];
    [_photosRef
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot) {
         NSDictionary *photosDict = snapshot.value;
         if ([photosDict[@"userID"] isEqualToString:[[User getInstance]userID]] && [photosDict[@"profilePhotoDownloadURL"] isEqualToString:self.imgPath]) {
             NSURL *url = [NSURL URLWithString:photosDict[@"profilePhotoDownloadURL"]];
             NSData *data = [NSData dataWithContentsOfURL:url];
             
             _photo = [[Photo alloc] initWithImagePath:photosDict[@"profilePhotoDownloadURL"] andImage:[UIImage imageWithData:data] andName:photosDict[@"name"] andDesc:photosDict[@"description"] andLat:photosDict[@"latitude"] andLong:photosDict[@"longitude"] andDate:photosDict[@"photoDate"] andFavorite:FALSE andUID:snapshot.key];
             
             [self editPhotoDetails];
         }
     }];
}

//- (void)newPhotoDetails {
//    _photoNameEditField.hidden = FALSE;
//    _photoDescriptionEditField.hidden = FALSE;
//    _savePhotoButton.hidden = FALSE;
//    
//    _photoNameLabel.hidden = TRUE;
//    _photoDateLabel.hidden = TRUE;
//    _photoDescriptionLabel.hidden = TRUE;
//    _editPhotoButton.hidden = TRUE;
//    
//    _photoImage.image = _photo.imgPath;
//    _photoImage.contentMode = UIViewContentModeScaleAspectFit;
//}

- (IBAction)commitData:(id)sender {
    
    //NSLog(@"_currentPhotoKey = %@", self.currentPhotoKey);
    
    NSDictionary *post = @{@"name": _photoNameEditField.text,
                           @"description": _photoDescriptionEditField.text,
                           @"profilePhotoDownloadURL": _photo.imgPath,
                           @"userID": [[User getInstance]userID],
                           @"latitude": _photo.lat,
                           @"longitude": _photo.lng,
                           @"photoDate": _photo.date
    };
    //NSDictionary *childUpdates = @{[@"" stringByAppendingString:self.currentPhotoKey]: post};
    NSDictionary *childUpdates = @{[@"" stringByAppendingString:_photo.uid]: post};
    [_photosRef updateChildValues:childUpdates];
    
    MapViewController *nextVC = [[MapViewController alloc] init];
    nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
    nextVC.newPic = FALSE;
    
    [self performSegueWithIdentifier:@"backToMapSegue" sender:self];
}
- (IBAction)editExistingPhoto:(id)sender {
    [self editPhotoDetails];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
