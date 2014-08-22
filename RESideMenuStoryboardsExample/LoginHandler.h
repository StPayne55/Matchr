//
//  LoginHandler.h
//  Matchr
//
//  Created by Steve Payne on 8/22/14.
//  Copyright (c) 2014 Steve Payne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface LoginHandler : NSObject

@property NSString *username;
@property NSString *password;
@property NSString *email;
@property PFFile *profilePic;

-(void)createNewUser;
-(void)logUserIn;


@end
