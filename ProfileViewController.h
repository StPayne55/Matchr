//
//  ProfileViewController.h
//  Matchr
//
//  Created by Steve Payne on 8/25/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mainProfileView;
@property (weak, nonatomic) IBOutlet UILabel *profileFullName;
@property (weak, nonatomic) IBOutlet UILabel *profileOccupation;
@property (weak, nonatomic) IBOutlet UILabel *profileMajor;
@property (weak, nonatomic) IBOutlet UILabel *profilePreference;
@property (weak, nonatomic) IBOutlet UILabel *profileAge;

@end
