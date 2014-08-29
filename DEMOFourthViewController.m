//
//  DEMOFourthViewController.m
//  Matchr
//
//  Created by Steve Payne on 9/5/14.
//  Copyright (c) 2014 Steve Payne. All rights reserved.
//

#import "DEMOFourthViewController.h"
#import "FXBlurView.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface DEMOFourthViewController ()
@property (weak, nonatomic) IBOutlet FXBlurView *imageBlur;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstName;


@end

@implementation DEMOFourthViewController
int rotateCount;
float totalDist;
float increment;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    _lblFirstName.center = CGPointMake(self.view.center.x, _lblFirstName.center.y+40);
    _imageBlur.layer.shadowOpacity = .8;
    _imageBlur.layer.shadowOffset = CGSizeMake(0, 2.0);
    _imageBlur.layer.shadowColor = [[UIColor blackColor] CGColor];
}

-(void)viewDidAppear:(BOOL)animated{
    _imageBlur.dynamic = NO;
    rotateCount = 0;
    totalDist = _profilePic.center.x - self.view.center.x;
    increment = totalDist/4;
    [self rotateSpinningView];
    
    
}

- (void)rotateSpinningView
{
    
    if (rotateCount < 3){
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_profilePic setTransform:CGAffineTransformRotate(_profilePic.transform, -M_PI_2)];
            _profilePic.center = CGPointMake(_profilePic.center.x-increment, _profilePic.center.y);
        } completion:^(BOOL finished) {
            if (finished && !CGAffineTransformEqualToTransform(_profilePic.transform, CGAffineTransformIdentity)) {
                rotateCount++;
                [self rotateSpinningView];
            }
        }];
    }else if (rotateCount < 4){
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_profilePic setTransform:CGAffineTransformRotate(_profilePic.transform, -M_PI_2)];
            _profilePic.center = CGPointMake(_profilePic.center.x-(increment), _profilePic.center.y);
            _lblFirstName.center = CGPointMake(self.view.center.x, _lblFirstName.center.y-28);
        } completion:^(BOOL finished) {
        }];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageBlur.blurRadius = 30;
    _imageBlur.tintColor = [UIColor clearColor];
    _profilePic.clipsToBounds = YES;
    _profilePic.layer.cornerRadius = _profilePic.frame.size.width/2;
    [_profilePic.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [_profilePic.layer setBorderWidth: 2.0];

    PFImageView *profileImageView = [[PFImageView alloc] init];
    
    // grab profile pic from current user object and display profile
    PFFile *imageFile = [[PFUser currentUser] objectForKey:@"profilePic"];
    if (imageFile) {
        profileImageView.file = imageFile;
        [profileImageView loadInBackground];
        _profilePic.image = profileImageView.image;
        
        _lblFirstName.text = [[PFUser currentUser] objectForKey:@"firstName"];
        [_profilePic setContentMode:UIViewContentModeScaleAspectFill];
        _profilePic.center = CGPointMake(900, _profilePic.center.y);
        NSLog(@"profilePic: %@", profileImageView.file);
        
    }
    
    //_profilePic.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
