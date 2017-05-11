//
//  ScaleAnimatorCoordinator.h
//  OpenGlTest
//
//  Created by wale1994 on 2017/4/18.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleAnimatorCoordinator : UIPresentationController

@property(nonatomic,strong)UIView *currentHiddenView;

@property(nonatomic,strong)UIView *maskView;

-(void)updateCurrentHiddenView:(UIView *)view;

@end
