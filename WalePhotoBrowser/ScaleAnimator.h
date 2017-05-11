//
//  ScaleAnimator.h
//  OpenGlTest
//
//  Created by wale1994 on 2017/4/18.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScaleAnimator : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype )initWith:(UIView *)startView :(UIView *)endView :(UIView *)scaleView;

@property(nonatomic,strong)UIView *startView;

@property(nonatomic,strong)UIView *endView;

@property(nonatomic,strong)UIView *scaleView;



@end
