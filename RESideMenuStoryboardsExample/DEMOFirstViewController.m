//
//  DEMOFirstViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOFirstViewController.h"

@interface DEMOFirstViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *blueImage;
@property (weak, nonatomic) IBOutlet UIImageView *pinkImage;
@property (weak, nonatomic) IBOutlet UIView *loginComponents;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (weak, nonatomic) IBOutlet UILabel *lblLogin;

@end

@implementation DEMOFirstViewController
CGPoint blueOrigin;
CGPoint pinkOrigin;
CGPoint loginOrigin;
CGPoint logoOrigin;

-(void)viewDidLoad{
    _loginComponents.alpha = 0;
    _logo.alpha = 0;
    self.navigationController.navigationBarHidden = YES;
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
        _loginComponents.alpha = 1;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.9 options:nil animations:^{
_loginComponents.center = loginOrigin;
        }completion:nil];
    }];
    
}

@end
