//
//  MapViewController.m
//  MemoryLane
//
//  Created by tstone10 on 7/14/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "MapViewController.h"
#import "User.h"
#import "Themer.h"
@import FirebaseDatabase;
@import Firebase;
@import FirebaseStorage;

@interface MapViewController ()<UIImagePickerControllerDelegate>

#pragma mark Properties
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) FIRStorageReference *firebaseStorageRef;
@property (strong, nonatomic) NSString *currentUserProfileKey;
@property (strong, nonatomic) FIRStorage *firebaseStorage;
@property (strong, nonatomic) NSString *nextPhoto;
@property (nonatomic) double lat;
@property (nonatomic) double lng;


#pragma mark IBOutlets
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *photoListButton;

@end

@implementation MapViewController {
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
}

- (void)viewDidLoad {
    //initializes Firebase Storage and creates reference to it.
    [self firebaseSetUp];
    [self customUISetup];
    [self configureMap];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    //ref = [[FIRDatabase database] reference];
    //[self configureMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customUISetup {
    Themer *mvcTheme = [[Themer alloc]init];
    [mvcTheme themeButtons: _buttons];
    [mvcTheme themeAppBackgroundImage: self];
}

//-(void)initDesignElements {
//    CGRect upperScreenRect = {{0, 0}, {CGRectGetWidth(self.view.bounds), 50}};
//    UIView* coverView = [[UIView alloc] initWithFrame:upperScreenRect];
//    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
//    [self.view insertSubview:coverView atIndex:1];
//}

#pragma mark - Camera Methods
//Presents the iPhone's camera and is called when the profile photo is selected.
- (IBAction)useCamera:(id)sender {
    _imagePicker = [[UIImagePickerController alloc] init];
    [_imagePicker setDelegate:self];
    [_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:_imagePicker animated:true completion:nil];
}

/*
 Occurrs when the camera finishes taking the photo.
 It then uses the reduceImageSize func and uploadPhotoToFirebase func
 to reduce the image's size and then send it to Firebase.
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1);
    UIImage *image = [UIImage imageWithData:imageData];
    NSData *resizedImgData =  UIImageJPEGRepresentation([self reduceImageSize:image], .80);
    [self uploadPhotoToFirebase:resizedImgData];
    [self dismissViewControllerAnimated:true completion:nil];
}

//Accepts a UIImage and reduces the size of it.
-(UIImage *)reduceImageSize:(UIImage *)image {
    CGSize newSize = CGSizeMake(image.size.width/10, image.size.height/10);
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    return smallImage;
}

#pragma mark Firebase Methods

//initializes Firebase Storage and creates reference to it.
-(void)firebaseSetUp {
    _firebaseStorage = [FIRStorage storage];
    _firebaseStorageRef = [_firebaseStorage referenceForURL:@"gs://memorylane-f956e.appspot.com"];
}

/*
 Retrieve lists of items or listen for additions to a list of items.
 */
-(void)listenForAdditionsToUserPhotos {
    // Listen for new photos in the Firebase database
    FIRDatabaseReference *photosRef = [[[FIRDatabase database]reference]child:@"photos"];
    [photosRef
    observeEventType:FIRDataEventTypeChildAdded
    withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary *photosDict = snapshot.value;
        
        //NSLog(@"photosDict = %@", photosDict);
        if ([photosDict[@"userID"] isEqualToString:[[User getInstance]userID]]) {
            [self placePhotoPinInMapWithLat:photosDict[@"latitude"] andLong:photosDict[@"longitude"] andImage:photosDict[@"profilePhotoDownloadURL"]];
        }
    }];
    //NSLog(@"User ID = %@", [snapshot.value[[User getInstance]]userID]);
}

-(void)placePhotoPinInMapWithLat:(NSString *)lat andLong:(NSString *)lng andImage:(NSString *)image {
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake([lat floatValue], [lng floatValue]);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    
    NSURL *url = [NSURL URLWithString:image];
    
    //NSLog(@"url = %@", url);
    
    NSData *data = [NSData dataWithContentsOfURL:url];    
    marker.icon = [UIImage imageWithData:data scale:12.0];
    
    marker.map = mapView_;
}

/*
 This accepts the NSData that is returned from the image picker and then saves it on Firebase Storage.
 Once it is stored in Firebase storage it gives us back a downloadURL.
 */
-(void)uploadPhotoToFirebase:(NSData *)imageData {
    //Create a uniqueID for the image and add it to the end of the images reference.
    NSString *uniqueID = [[NSUUID UUID]UUIDString];
    NSString *newImageReference = [NSString stringWithFormat:@"userPhotos/%@.jpg", uniqueID];
    //imagesRef creates a reference for the images folder and then adds a child to that folder, which will be every time a photo is taken.
    FIRStorageReference *imagesRef = [_firebaseStorageRef child:newImageReference];
    //This uploads the photo's NSData onto Firebase Storage.
    FIRStorageUploadTask *uploadTask = [imagesRef putData:imageData metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error.description);
        } else {
            //_currentUser.profileImageDownloadURL = metadata.downloadURL.absoluteString;
            [self updateCurrentUserProfileImageDownloadURLOnFirebaseDatabase:[User getInstance] andMetaData:metadata];
        }
    }];
    [uploadTask resume];
}

/*
 This accepts a UserProfile object to update (which will be our current user profile).
 When the UserProfile object is passed it will already have an updated URL from when the new photo
 is taken and the metaDataURL is sent back. It then updates the child node on Firebase.
 */
-(void)updateCurrentUserProfileImageDownloadURLOnFirebaseDatabase:(User *)userProfile andMetaData:(FIRStorageMetadata *)metadata {
    
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    
    //NSLog(@"profilePhotoDownloadURL :: %@", metadata.downloadURL.absoluteString);
    //NSLog(@"userID :: %@", userProfile.userID);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy:MM:dd:HH:mm:ss"];
    
    NSString *key = [[firebaseRef child:@"photos"] childByAutoId].key;
    NSDictionary *userProfileToUpdate = @{@"profilePhotoDownloadURL": metadata.downloadURL.absoluteString,
                                                           @"userID": userProfile.userID,
                                                         @"latitude": [NSString stringWithFormat:@"%f", _lat],
                                                        @"longitude": [NSString stringWithFormat:@"%f", _lng],
                                                        @"photoDate": [dateFormatter stringFromDate:[NSDate date]]};
    NSDictionary *childUpdates = @{[@"/photos/" stringByAppendingString:key]: userProfileToUpdate};
    [firebaseRef updateChildValues:childUpdates];
}


#pragma mark - Configure Map
-(void)configureMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.3313
                                                            longitude:-83.1998
                                                                 zoom:10];
    
    //mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    //mapView_.mapType = kGMSTypeHybrid;
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.scrollGestures = YES;
    mapView_.settings.zoomGestures = YES;
    mapView_.padding = UIEdgeInsetsMake(60, 0, 0 , 0);
    
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    //self.view = mapView_;
    [self.view insertSubview:mapView_ atIndex:1];
    [self.view bringSubviewToFront:_cameraButton];
    [self.view bringSubviewToFront:_photoListButton];
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
        NSLog(@"User's location: %@", mapView_.myLocation);        
        [self listenForAdditionsToUserPhotos];
    });
}

- (void)dealloc {
    [mapView_ removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

#pragma mark - KVO updates
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
        
        _lat = location.coordinate.latitude;
        _lng = location.coordinate.longitude;
        
        //NSLog(@"current location = %f", location.coordinate.latitude);
        //NSLog(@"current location = %f", location.coordinate.longitude);
    }
}

@end
