//
//  DEMOFirstViewController.m
//  RESideMenuStoryboards
//
//  Created by Steve Payne on 9/6/14.
//  Copyright (c) 2014 Steve Payne. All rights reserved.
//

#import "DEMOFirstViewController.h"
#import "LoginHandler.h"
#import <Parse/Parse.h>
#import "FXBlurView.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface DEMOFirstViewController () <UITextFieldDelegate, UIAlertViewDelegate, FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *blueImage;
@property (weak, nonatomic) IBOutlet UIImageView *pinkImage;
@property (weak, nonatomic) IBOutlet FXBlurView *loginComponents;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet FXBlurView *userSignupView;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicSnapPoint;
@property (weak, nonatomic) IBOutlet FBLoginView *FBLoginView;
@property (weak, nonatomic) IBOutlet UILabel *lblOr;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;


@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *userSignupButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)loginButtonPressed:(UIButton *)sender;
- (IBAction)newUserButtonPressed:(UIButton *)sender;
- (IBAction)signUpButton:(UIButton *)sender;
- (IBAction)cancelButtonWasPressed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet FXBlurView *signUpView;

@end

@implementation DEMOFirstViewController
CGPoint blueOrigin;
CGPoint pinkOrigin;
CGPoint loginOrigin;
CGPoint logoOrigin;
CGPoint signupViewOrigin;
LoginHandler *loginObject;
BOOL newUserViewIsVisible;
PFUser *user;


-(void)viewDidLoad{
    
    user = [PFUser currentUser];
    
    //check to see if user is currently logged in
    if (user) {
        //user is logged in, skip login screen and go straight to profile
        NSLog(@"user is signed in");
        [self userLoggedIn];
    }else{
    _loginComponents.dynamic = YES;
    _loginComponents.iterations = 2;
    _loginComponents.alpha = 0;
    _logo.alpha = 0;
    self.navigationController.navigationBarHidden = YES;
    
    for (UITextField *field in _loginComponents.subviews){
        if ([field isKindOfClass:[UITextField class]]){
            field.delegate = self;
        }
    }
    
    for (UITextField *field in _signUpView.subviews){
        if ([field isKindOfClass:[UITextField class]]){
            field.delegate = self;
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    }
    
    _FBLoginView.delegate = self;
    
}


-(void)createUser{
    loginObject = [[LoginHandler alloc] init];
    loginObject.username = _txtEmail.text;
    loginObject.password = _txtNewPassword.text;
    loginObject.email = _txtEmail.text;
    loginObject.firstName = _txtFirstName.text;
    loginObject.lastName = _txtLastName.text;
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"bluePuzzle.png"], 5.9f);
    PFFile *profilePic = [PFFile fileWithName:@"profilePic" data:imageData];
    loginObject.profilePic = profilePic;
    [loginObject createNewUser];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


-(void)logUserIn{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoggedIn)
                                                 name:@"loginSuccessful"
                                               object:nil];
    
    
    
    //set the properties on the login handler to match the current user.
    if (!newUserViewIsVisible){
        loginObject = [[LoginHandler alloc] init];
        loginObject.username = _txtUsername.text;
        loginObject.password = _txtPassword.text;
    }else{
        loginObject = [[LoginHandler alloc] init];
        loginObject.username = _txtEmail.text;
        loginObject.password = _txtNewPassword.text;
    }
    
    //attempt to log the user in using their entered credentials
    [loginObject logUserIn];
    _loginComponents.dynamic = NO;
    
}


//as soon as the login handler successfully logs a user in, this method will be executed
-(void)userLoggedIn{
    NSLog(@"User logged in....");
    
    //load profile info and picture
    ProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    //create profile view card
    UIView *profileInfo = [[UIView alloc]init];
    profileInfo = profileView.view;
    
    //populate card labels with corresponding data for the current user
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", [[PFUser currentUser] objectForKey:@"firstName"], [[PFUser currentUser] objectForKey:@"lastName"] ];
    NSString *occupation = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectForKey:@"occupation"]];
    NSString *age = [NSString stringWithFormat:@"%@ Years Old", [[PFUser currentUser] objectForKey:@"age"]];
    NSString *major = [NSString stringWithFormat:@"Currently Studying %@", [[PFUser currentUser] objectForKey:@"major"]];
    NSString *preference = [NSString stringWithFormat:@"Interested In %@", [[PFUser currentUser] objectForKey:@"preference"]];
    
    //set labels with data from the current user object
    profileView.profileFullName.text = fullName;
    profileView.profileOccupation.text = occupation;
    profileView.profileAge.text = age;
    profileView.profileMajor.text = major;
    profileView.profilePreference.text = preference;
    
    for (UILabel *label in profileView.view.subviews){
        if ([label isMemberOfClass:[UILabel class]]){
            if (label == nil){
                
            }
        }
    }
    //hide login view
    PFImageView *profileImageView = [[PFImageView alloc] init];
    
    // grab profile pic from current user object and display profile
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"profilePic"];
    if (imageFile) {
        profileImageView.file = imageFile;
        [profileImageView loadInBackground];
        NSLog(@"profilePic: %@", profileImageView.file);
        
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wood2.png"]];
        background.frame = self.view.frame;
        
        [self.view addSubview:background];
        [self.view sendSubviewToBack:background];
        [self.view addSubview:profileImageView];
        [self.view addSubview:profileInfo];
        [profileInfo setTransform:CGAffineTransformMakeScale(2.0f, 2.0f)];
        [self.view bringSubviewToFront:profileInfo];
        [profileImageView setTransform:CGAffineTransformMakeScale(10.0f, 10.0f)];
        profileImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
        profileImageView.layer.shadowOffset = CGSizeMake(1.0, 5.0);
        profileImageView.layer.shadowOpacity = .8;
        
        [UIView animateWithDuration:.7 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            _FBLoginView.center = CGPointMake(_FBLoginView.center.x, 600);
            [profileInfo setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
            [profileImageView setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
            profileImageView.frame = CGRectMake(self.view.center.x/4, background.center.y/2, 190, 190);
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2;
            profileImageView.clipsToBounds = YES;
            profileImageView.layer.masksToBounds = YES;
            
            [profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [profileImageView.layer setBorderWidth:4.0];
            profileImageView.center = _profilePicSnapPoint.center;
            [profileImageView setContentMode:UIViewContentModeScaleAspectFill];
            
        }completion:nil];
        
        [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.6 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            
            _blueImage.center = CGPointMake(-600, _blueImage.center.y);
            _pinkImage.center = CGPointMake(600, _pinkImage.center.y);
            _loginComponents.center = CGPointMake(_loginComponents.center.x, 900);
            _logo.frame = CGRectMake(_logo.frame.origin.x, _logo.frame.origin.y, _logo.frame.size.width *.9, _logo.frame.size.height);
            _logo.center = CGPointMake(_logo.center.x, -600);
            _logo.transform = CGAffineTransformScale(_logo.transform, 1.2, 1.2);
            self.navigationController.navigationBarHidden = NO;
            _loginComponents.center = CGPointMake(loginOrigin.x, 800);
            //_profileView.alpha = 1;
            
            
        }completion:nil];
        
        //remove login observer
        [[NSNotificationCenter defaultCenter] removeObserver:@"loginSuccessful"];
        
        //make sure all blurred views are disabled since they're VERY cpu intensive if left unchecked
        for (FXBlurView *blurView in self.view.subviews){
            if ([blurView isKindOfClass:[FXBlurView class]]){
                blurView.dynamic = NO;
            }
        }

        
        
        
    } else {
        profileImageView.image = [UIImage imageNamed:@"MatchrLogo.tiff"];
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wood2.png"]];
        background.frame = self.view.frame;
        [self.view addSubview:background];
        [self.view sendSubviewToBack:background];
        [self.view addSubview:profileImageView];
        
        [UIView animateWithDuration:.7 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            profileImageView.frame = CGRectMake(self.view.center.x/4, background.center.y/2, 190, 190);
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2;
            profileImageView.clipsToBounds = YES;
            profileImageView.layer.masksToBounds = YES;
            profileImageView.center = _profilePicSnapPoint.center;
            
            UIImageView *profilePicImageViewFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageFrame.png"]];
            [background addSubview:profilePicImageViewFrame];
            profilePicImageViewFrame.frame = CGRectMake(self.view.center.x/4, self.view.center.y/2, 215, 225);
            profilePicImageViewFrame.clipsToBounds = YES;
            profilePicImageViewFrame.layer.masksToBounds = YES;
            profilePicImageViewFrame.center = _profilePicSnapPoint.center;
        }completion:nil];
        
        [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.6 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            
            _blueImage.center = CGPointMake(-600, _blueImage.center.y);
            _pinkImage.center = CGPointMake(600, _pinkImage.center.y);
            _loginComponents.center = CGPointMake(_loginComponents.center.x, 900);
            _logo.frame = CGRectMake(_logo.frame.origin.x, _logo.frame.origin.y, _logo.frame.size.width *.9, _logo.frame.size.height);
            _logo.center = CGPointMake(_logo.center.x, -600);
            _logo.transform = CGAffineTransformScale(_logo.transform, 1.2, 1.2);
            self.navigationController.navigationBarHidden = NO;
            _loginComponents.center = CGPointMake(loginOrigin.x, 800);
            //_profileView.alpha = 1;
            
            
        }completion:nil];
        
        //remove login observer
        [[NSNotificationCenter defaultCenter] removeObserver:@"loginSuccessful"];
        
        //make sure all blurred views are disabled since they're VERY cpu intensive if left unchecked
        for (FXBlurView *blurView in self.view.subviews){
            if ([blurView isKindOfClass:[FXBlurView class]]){
                blurView.dynamic = NO;
            }
        }
        
        
        
    }
    
   }


-(void)newUserCreated{
    
    //dismiss spinner interstitial here once added
    
    //inform the user that signup was successful
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Welcome To Matchr!" delegate:self cancelButtonTitle:@"Proceed To Profile" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
    
    //dismiss userSignupView
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.7 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        _userSignupView.center = CGPointMake(_userSignupView.center.x, 800);
        _logo.center = logoOrigin;
        _logo.transform = CGAffineTransformScale(_logo.transform, 1.25, 1.25);
    }completion:^(BOOL finished){
        _userSignupView.dynamic = NO;
        _userSignupView.blurEnabled = NO;
    }];


    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //sign user in using new account credentials and display profile
    [self logUserIn];
    newUserViewIsVisible = NO;
    
    //remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:@"newUserCreated"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //setup login view
    _loginComponents.layer.cornerRadius = _loginComponents.frame.size.width / 10;
    _loginComponents.blurRadius = 80;
    _loginComponents.tintColor = [UIColor whiteColor];
    _loginComponents.clipsToBounds = YES;
    
    
    //setup snap points for each UI element
    blueOrigin = _blueImage.center;
    pinkOrigin = _pinkImage.center;
    loginOrigin = _loginComponents.center;
    logoOrigin = _logo.center;
    signupViewOrigin = _userSignupView.center;
    
    _blueImage.center = CGPointMake(-600, _blueImage.center.y);
    _pinkImage.center = CGPointMake(600, _pinkImage.center.y);
    _loginComponents.center = CGPointMake(_loginComponents.center.x, 900);
    _logo.center = CGPointMake(_logo.center.x, -600);
    _userSignupView.center = CGPointMake(_userSignupView.center.x, 900);
    
    _signUpView.layer.cornerRadius = _signUpView.frame.size.width/18;
    
    _signUpView.backgroundColor = [UIColor whiteColor];
    _signUpView.layer.shadowOffset = CGSizeMake(0, 2.0);
    _signUpView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _signUpView.layer.shadowOpacity = .8;
    _signUpView.clipsToBounds = YES;
    _signUpView.dynamic = NO;
    _signUpButton.center = CGPointMake(_signUpView.center.x*1.5, _signUpButton.center.y);
    
    _FBLoginView.alpha = 0;
    _FBLoginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    _logo.alpha = 1;
    
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        _logo.center = logoOrigin;
        _blueImage.center = blueOrigin;
        _pinkImage.center = pinkOrigin;
        _loginComponents.alpha = 1;
       
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            _loginComponents.center = loginOrigin;
            _userSignupButton.center = CGPointMake(self.view.center.x/2, _userSignupButton.center.y);
            _loginButton.center = CGPointMake(self.view.center.x/2, _loginButton.center.y);
            
        }completion:^(BOOL finished){
             [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
//                 _lblOr.alpha = 1;
//                 _FBLoginView.alpha = 1;
             }completion:nil];
            
        }];
        
    }];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    for (UIView *view in self.loginComponents.subviews){
        [view resignFirstResponder];
    }
    
    [self performSelector:@selector(logUserIn) withObject:self afterDelay:.5];
}

- (IBAction)newUserButtonPressed:(UIButton *)sender {
    newUserViewIsVisible = YES;
    _userSignupView.dynamic = YES;
    _userSignupView.layer.cornerRadius = _userSignupView.frame.size.width / 8;
    _userSignupView.clipsToBounds = YES;
    _userSignupView.blurRadius = 40;
    _userSignupView.tintColor = [UIColor whiteColor];
    
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        _userSignupView.center = signupViewOrigin;
        _logo.center = CGPointMake(logoOrigin.x, logoOrigin.y - 90);
        _loginComponents.dynamic = NO;
        _loginComponents.alpha = 0;
        _loginComponents.center = CGPointMake(loginOrigin.x, loginOrigin.y + 800);
        _logo.transform = CGAffineTransformScale(_logo.transform, .8, .8);
    }completion:nil];
    
    
        
        
    
    
}

- (IBAction)signUpButton:(UIButton *)sender {
    if ([_txtNewPassword.text isEqualToString:_txtConfirmPassword.text]){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(newUserCreated)
                                                     name:@"newUserCreated"
                                                   object:nil];
        [self createUser];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:@"The Passwords You Entered Don't Match. Please Try Again" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (IBAction)cancelButtonWasPressed:(UIButton *)sender {
    newUserViewIsVisible = NO;
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.7 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
    _userSignupView.center = CGPointMake(_userSignupView.center.x, 800);
        _logo.center = logoOrigin;
        _logo.transform = CGAffineTransformScale(_logo.transform, 1.25, 1.25);
    }completion:^(BOOL finished){
        
        _loginComponents.alpha = 1;
        _loginComponents.dynamic = YES;
        _userSignupView.dynamic = NO;
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        _loginComponents.center = loginOrigin;
        _userSignupButton.center = CGPointMake(self.view.center.x/2, _userSignupButton.center.y);
        _loginButton.center = CGPointMake(self.view.center.x/2, _loginButton.center.y);
        }completion:nil];
        
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        _logo.center = CGPointMake(logoOrigin.x, logoOrigin.y - 60);
        _loginComponents.center = CGPointMake(loginOrigin.x, loginOrigin.y - 80);
        _logo.transform = CGAffineTransformScale(_logo.transform, .8, .8);
        

    }completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.9 options:nil animations:^{
        if (!newUserViewIsVisible){
        _loginComponents.center = loginOrigin;
        _logo.center = CGPointMake(logoOrigin.x, logoOrigin.y);
        }
        _logo.transform = CGAffineTransformScale(_logo.transform, 1.25, 1.25);
        
    }completion:nil];
    
}

#pragma mark Facebook Delegate Methods

// This method will be called when the user information has been fetched
// This method will be called when the user information has been fetched
//- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
//                            user:(id<FBGraphUser>)user {
//    self.profilePictureView.profileID = user.objectID;
//    self.profilePictureView.sizeToFit;
//    self.lblOr.text = user.name;
//    
//    __block UIImage *image = nil;
//    
//    [self.view.subviews enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isMemberOfClass:[UIImageView class]]) {
//            UIImageView *objImg = (UIImageView *)obj;
//            image = objImg.image;
//            *stop = YES;
//        }
//    }];
//    
//    
//}



@end
