//
//  PhotoBrowserCell.h
//  OpenGlTest
//
//  Created by wale1994 on 2017/4/17.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoBrowserCell;

@protocol PhotoBrowserCellDelegate <NSObject>
///单机回调
-(void)photoBrowserCellDidSingleTap:(PhotoBrowserCell *)cell;

///拖动回调
-(void)photoBrowserCellDidDrag:(PhotoBrowserCell *)cell Scale:(CGFloat)scale;

///长按回调
-(void)photoBrowserCellLogPress:(PhotoBrowserCell *)cell image:(UIImage *)image;
@end

@interface PhotoBrowserCell : UICollectionViewCell
@property(nonatomic,weak)id<PhotoBrowserCellDelegate> delegate;
@property(nonatomic,strong)UIImageView *imageView;
-(void)setImage:(UIImage *)image Url:(NSString *)url;

@end
