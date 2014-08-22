//
//  LoginHandler.m
//  Matchr
//
//  Created by Steve Payne on 8/22/14.
//  Copyright (c) 2014 Steve Payne. All rights reserved.
//

#import "LoginHandler.h"
#import <Parse/Parse.h>




@implementation LoginHandler

-(void)createNewUser{
    PFUser *user = [PFUser user];
    user.username = _username;
    user.password = _password;
    user.email = _email;
    
    // other fields can be set just like with PFObject
    user[@"profilePic"] = _profilePic;
    
    //create a new user with the entered credentials
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:errorString delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

-(void)logUserIn{
    [PFUser logInWithUsernameInBackground:_username password:_password block:^(PFUser *user, NSError *error){
        if (user) {
            //successful login. Broadcast this message to any observers waiting on login success...
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"loginSuccessful"
             object:self];
            NSLog(@"login success!");
        } else {
            // The login failed. Explain why to the user.
            NSLog(@"Login Failure");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!" message:[error userInfo][@"error"] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
}



@end
