//
//  PhotoBorwsetLayout.m
//  OpenGlTest
//
//  Created by wale1994 on 2017/4/14.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import "PhotoBorwsetLayout.h"


@interface PhotoBorwsetLayout ()

@property(nonatomic,assign)CGFloat pageWidth;
@property(nonatomic,assign)NSInteger minPage;
@property(nonatomic,assign)NSInteger maxPage;

@end



@implementation PhotoBorwsetLayout
-(CGFloat)pageWidth
{
    return self.itemSize.width + self.minimumLineSpacing;
}
-(NSInteger )minPage
{
    return 0;
}
-(NSInteger )maxPage
{
    if (self.collectionView) {
        return  (int)roundf(self.collectionView.contentSize.width / self.pageWidth) ;
    }else{
        return 0;
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    NSInteger page = (int)roundf(proposedContentOffset.x / self.pageWidth);

//    NSLog(@"%ld %ld",self.minPage,self.lastPage);
    
    
    if (velocity.x > 0.2) {
        page += 1;
    }else if (velocity.x < -0.2){
        page -= 1;
    }
    
    if (page > self.lastPage + 1) {
        
        page = self.lastPage + 1;
        
    } else if (page < (self.lastPage - 1)){
        
        page = self.lastPage - 1;
        
    }
    if (page > self.maxPage) {
        page = self.maxPage;
    }else if(page < self.minPage){
        page = self.minPage;
    }
    self.lastPage = page;
    return CGPointMake(page * self.pageWidth, 0);
}



@end
