//
//  WalePhotoBrowser.h
//  OpenGlTest
//
//  Created by wale1994 on 2017/4/14.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WalePhotoBrowser;


@protocol PhotoBrowserDelegate <NSObject>
@required
/// 实现本方法以返回图片数量
-(NSInteger) numberOfPhotos:(WalePhotoBrowser *)photoBrowser;
/// 实现本方法以返回默认图片，缩略图或占位图
-(UIImage *) photoBrowserImage:(WalePhotoBrowser *)photoBrowser
                  WithThumbnailImageForIndex:(NSInteger )index;
@optional
/// 实现本方法以返回默认图所在view，在转场动画完成后将会修改这个view的hidden属性
/// 比如你可返回ImageView，或整个Cell
-(UIView *) photoBrowserView:(WalePhotoBrowser *)photoBrowser
                  WithThumbnailImageForIndex:(NSInteger )index;

/// 实现本方法以返回高质量图片。可选
-(UIImage *) photoBrowserHighImage:(WalePhotoBrowser *)photoBrowser
    WithThumbnailImageForIndex:(NSInteger )index;
 /// 实现本方法以返回高质量图片的url。可选
-(NSString *) photoBrowserUrl:(WalePhotoBrowser *)photoBrowser
        WithThumbnailImageForIndex:(NSInteger )index;
/// 长按时回调
-(NSString *) photoBrowserLongPress:(WalePhotoBrowser *)photoBrowser
                          WithThumbnailImageForIndex:(NSInteger )index
                          Withimage:(UIImage *)image;
@end






@interface WalePhotoBrowser : UIViewController

#pragma mark method
-(instancetype )initWithpreresentVc:(UIViewController *)vc
                 delegate:(id<PhotoBrowserDelegate>)delegate;
-(void)showWith:(NSInteger )index;

@property(nonatomic,weak)id<PhotoBrowserDelegate> deleagte;

@property(nonatomic,assign)UIViewContentMode imageScaleMode;

@property(nonatomic,assign)CGFloat photoSapceing;

@property(nonatomic,assign)BOOL isShowPageControl;

@property(nonatomic,assign)NSInteger currentIndex;
-(void)simpleShowWithpreresentVc:(UIViewController *)vc delegate:(id<PhotoBrowserDelegate>)delegate WithIndex:(NSInteger)index;




@end
