//
// Created by Anthony Perritano on 1/22/14.
// Copyright (c) 2014 Anthony Perritano. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginDelegate <NSObject>

- (void)didLogin;

- (void)didLogout;

@end