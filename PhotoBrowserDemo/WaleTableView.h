//
//  WaleTableView.h
//  PhotoBrowserDemo
//
//  Created by wale1994 on 2017/5/10.
//  Copyright © 2017年 wale1994. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tableViewBasicModel : NSObject

@property(nonatomic,strong)NSArray<NSString *> *cellCalss;
@property(nonatomic,assign)NSInteger numofSection;
@property(nonatomic,assign)NSInteger numofRow;
@property(nonatomic,assign)CGFloat height;


@end

@implementation tableViewBasicModel

-(Class)cellCalss
{
    if (_cellCalss) {
        return _cellCalss;
    }
    return nil;
}
-(NSInteger)numofRow{
    if (_numofRow>0) {
        return _numofRow;
    }
    return 0;
}
-(NSInteger)numofSection
{
    if (_numofSection>1) {
        return _numofSection;
    }
    return 1;
}
-(CGFloat)height
{
    if (_height>0) {
        return _height;
    }
    return 0;
}
@end










typedef tableViewBasicModel *(^BasicForCell)(UITableView *tableView);
//返回cell的Block
typedef NSArray<UITableViewCell *> *(^CellForIndexPath)(UITableView *tableView);
//点击cell方法的block
typedef void(^DiDSelectCellIndexPath)(UITableView *tableView,NSIndexPath *indexPath);


@interface WaleTableView : UIView


@property(nonatomic,strong)UITableView *tableView;



@end
