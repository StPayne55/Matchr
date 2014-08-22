//
//  DEMOFirstViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOFirstViewController.h"
#import "LoginHandler.h"
#import <Parse/Parse.h>

@interface DEMOFirstViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *blueImage;
@property (weak, nonatomic) IBOutlet UIImageView *pinkImage;
@property (weak, nonatomic) IBOutlet UIView *loginComponents;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)loginButtonPressed:(UIButton *)sender;

@end

@implementation DEMOFirstViewController
CGPoint blueOrigin;
CGPoint pinkOrigin;
CGPoint loginOrigin;
CGPoint logoOrigin;
LoginHandler *loginObject;


-(void)viewDidLoad{
    _loginComponents.alpha = 0;
    _logo.alpha = 0;
    self.navigationController.navigationBarHidden = YES;
    _txtUsername.delegate = self;
    _txtPassword.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoggedIn)
                                                 name:@"loginSuccessful"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


-(void)createUser{
    loginObject = [[LoginHandler alloc] init];
    loginObject.username = @"stpayne5555";
    loginObject.password = @"pass";
    loginObject.email = @"stpayne2@oakland.edugf";
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
    //set the properties on the login handler to match the current user.
    loginObject = [[LoginHandler alloc] init];
    loginObject.username = _txtUsername.text;
    loginObject.password = _txtPassword.text;
    
    //attempt to log the user in using their entered credentials
    [loginObject logUserIn];
}



-(void)userLoggedIn{
    NSLog(@"User logged in....");
    
    //hide login view and display profile
    
    [UIView animateWithDuration:.7 delay:.5 usingSpringWithDamping:.4 initialSpringVelocity:.9 options:nil animations:^{
        _loginComponents.center = CGPointMake(loginOrigin.x, 800);
        _blueImage.center = CGPointMake(-600, _blueImage.center.y);
        _pinkImage.center = CGPointMake(600, _pinkImage.center.y);
        _loginComponents.center = CGPointMake(_loginComponents.center.x, 900);
        _logo.frame = CGRectMake(_logo.frame.origin.x, _logo.frame.origin.y, _logo.frame.size.width *.9, _logo.frame.size.height);
        _logo.center = CGPointMake(_logo.center.x, -600);
        _logo.transform = CGAffineTransformScale(_logo.transform, 1.2, 1.2);
        self.navigationController.navigationBarHidden = NO;
    }completion:nil];

    

}

-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor whiteColor];
    
    blueOrigin = _blueImage.center;
    pinkOrigin = _pinkImage.center;
    loginOrigin = _loginComponents.center;
    logoOrigin = _logo.center;
    
    _blueImage.center = CGPointMake(-600, _blueImage.center.y);
    _pinkImage.center = CGPointMake(600, _pinkImage.center.y);
    _loginComponents.center = CGPointMake(_loginComponents.center.x, 900);
    _logo.center = CGPointMake(_logo.center.x, -600);
}


-(void)viewDidAppear:(BOOL)animated{
    _logo.alpha = 1;
 
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:.9 options:UIViewAnimationCurveEaseInOut animations:^{
        _logo.center = logoOrigin;
        _blueImage.center = blueOrigin;
        _pinkImage.center = pinkOrigin;
        _loginComponents.alpha = .5;
       
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.9 options:nil animations:^{
_loginComponents.center = loginOrigin;
        }completion:nil];
    }];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    [self logUserIn];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.9 options:nil animations:^{
        _logo.center = CGPointMake(logoOrigin.x, logoOrigin.y - 60);
        _loginComponents.center = CGPointMake(loginOrigin.x, loginOrigin.y - 60);
        _logo.transform = CGAffineTransformScale(_logo.transform, .9, .9);
    }completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.9 options:nil animations:^{
        _loginComponents.center = loginOrigin;
        _logo.transform = CGAffineTransformScale(_logo.transform, 1.1, 1.1);
        _logo.center = CGPointMake(logoOrigin.x, logoOrigin.y);
    }completion:nil];
   
}


@end
