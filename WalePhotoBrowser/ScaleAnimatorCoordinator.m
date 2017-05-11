//
//  ScaleAnimatorCoordinator.m
//  OpenGlTest
//
//  Created by wale1994 on 2017/4/18.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import "ScaleAnimatorCoordinator.h"

@implementation ScaleAnimatorCoordinator




-(void)updateCurrentHiddenView:(UIView *)view
{
    _currentHiddenView.hidden = NO;
    _currentHiddenView = view;
    view.hidden = YES;
}
-(void)presentationTransitionWillBegin
{
    [super presentationTransitionWillBegin];
    UIView *containerView = self.containerView;
    if (!containerView) {
        return;
    }
    [containerView addSubview:self.maskView];
    self.maskView.frame = containerView.bounds;
    self.maskView.alpha = 0;
    __weak typeof(self) _self = self;
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        _self.maskView.alpha = 1;
        
    } completion:nil];
}
-(void)dismissalTransitionWillBegin
{
    [super dismissalTransitionWillBegin];
    _currentHiddenView.hidden = YES;
    __weak typeof(self) _self = self;
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        _self.maskView.alpha = 0;
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        _self.currentHiddenView.hidden = NO;
    }];
}
#pragma mark Setter丶Getter
-(UIView *)maskView
{
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor blackColor];
        return _maskView;
    }
    return _maskView;
}

@end
