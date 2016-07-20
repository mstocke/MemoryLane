//
//  MapViewController.m
//  MemoryLane
//
//  Created by tstone10 on 7/14/16.
//  Copyright © 2016 Detroit Labs. All rights reserved.
//

#import "MapViewController.h"
#import "User.h"
@import GoogleMaps;
@import FirebaseDatabase;
@import Firebase;
@import FirebaseStorage;

@interface MapViewController ()<UIImagePickerControllerDelegate>

#pragma mark Properties
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) FIRStorageReference *firebaseStorageRef;
@property (strong, nonatomic) FIRStorage *firebaseStorage;
@property (strong, nonatomic) NSString *nextPhoto;

#pragma mark IBOutlets
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation MapViewController {
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    //ref = [[FIRDatabase database] reference];
    [self configureMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Camera Methods
//Presents the iPhone's camera and is called when the profile photo is selected.
- (IBAction)useCamera:(id)sender {
    _imagePicker = [[UIImagePickerController alloc] init];
    [_imagePicker setDelegate:self];
    [_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:_imagePicker animated:true completion:nil];
    
}

//- (IBAction)useCamera:(id)sender {
//    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePicker.delegate = self;
//    [self presentModalViewController:imagePicker animated:YES];
//    [imagePicker release];
//}

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
 This accepts the NSData that is returned from the image picker and then saves it on Firebase Storage.
 Once it is stored in Firebase storage it gives us back a downloadURL.
 */
-(void)uploadPhotoToFirebase:(NSData *)imageData {
    //Create a uniqueID for the image and add it to the end of the images reference.
    NSString *uniqueID = [[NSUUID UUID]UUIDString];
    NSString *newImageReference = [NSString stringWithFormat:@"photos/%@.jpg", uniqueID];
    //imagesRef creates a reference for the images folder and then adds a child to that folder, which will be every time a photo is taken.
    FIRStorageReference *imagesRef = [_firebaseStorageRef child:newImageReference];
    //This uploads the photo's NSData onto Firebase Storage.
    FIRStorageUploadTask *uploadTask = [imagesRef putData:imageData metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error.description);
        } else {
            _nextPhoto = metadata.downloadURL.absoluteString;
            [self addPhotoToUserList];
        }
    }];
    [uploadTask resume];
}

-(void)addPhotoToUserList {
    FIRDatabaseReference *firebaseRef = [[FIRDatabase database] reference];
    NSLog(@"addPhotoToUserList");
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
    
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    //self.view = mapView_;
    [self.view insertSubview:mapView_ atIndex:0];
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
        NSLog(@"User's location: %@", mapView_.myLocation);
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
    }
}

@end
