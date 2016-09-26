//
//  MQDragToMoveView.m
//
//  Created by 杨孟强 on 16/6/16.
//  Copyright © 2016年 杨孟强. All rights reserved.
//

#import "MQDragToMoveView.h"

@implementation MQDragToMoveView

#pragma mark - 类方法创建MQDragToMoveView
+ (instancetype)createMQDragToMoveViewWithFrame:(CGRect)frame delegate:(id<MQDragToMoveViewDelegate>)delegate itemNumberOfColumns:(NSInteger)itemNumberOfColumns itemCount:(NSInteger)itemCount itemViewHeight:(CGFloat)itemViewHeight userInfoArray:(NSArray *)userInfoArray
{
    MQDragToMoveView *dragToMoveView = [[MQDragToMoveView alloc] initWithFrame:frame];
    dragToMoveView.numberOfColumns = itemNumberOfColumns;
    dragToMoveView.itemViewHeight = itemViewHeight;
    dragToMoveView.delegate = delegate;
    
    CGFloat width = dragToMoveView.frame.size.width / itemNumberOfColumns;
    for (int i = 0; i < itemCount; ++i) {
        
        id userInfo = nil;
        if (userInfoArray && i < userInfoArray.count) {
            userInfo = userInfoArray[i];
        }
        MQDragToMoveItemView *itemView = [MQDragToMoveItemView createMQDragToMoveItemWithFrame:CGRectMake(i%itemNumberOfColumns*width, i/itemNumberOfColumns*itemViewHeight, width, itemViewHeight) MQDragToMoveItemDelegate:dragToMoveView index:i userInfo:userInfo];
        
        [dragToMoveView addItemView:itemView];
    }
    
    return dragToMoveView;
}

#pragma mark - 刷新试图
- (void)updatedToView
{
    if (self.items.count) {
        CGFloat width = self.frame.size.width / _numberOfColumns;
        NSInteger count = self.items.count;
        for (NSInteger i = 0; i < count; ++i) {
            
            MQDragToMoveItemView *itemView = self.items[i];
            itemView.frame = CGRectMake(i%_numberOfColumns*width, i/_numberOfColumns*_itemViewHeight, width, _itemViewHeight);
            itemView.index = i;
        }
    } else {
        for (MQDragToMoveItemView *item in self.subviews) {
            [item removeFromSuperview];
        }
    }
}

#pragma mark - 添加item/插入item/删除item
- (MQDragToMoveItemView *)addItemViewAndUserInfo:(id)userInfo animated:(BOOL)animated
{
    CGFloat width = self.frame.size.width / _numberOfColumns;
    NSInteger index = self.items.count;
    MQDragToMoveItemView *itemView = [MQDragToMoveItemView createMQDragToMoveItemWithFrame:CGRectMake(index%_numberOfColumns*width, index/_numberOfColumns*_itemViewHeight, width, _itemViewHeight) MQDragToMoveItemDelegate:self index:index userInfo:userInfo];
    
    [self addItemView:itemView animated:animated];
    
    return itemView;
}
- (void)addItemView:(MQDragToMoveItemView *)itemView
{
    [self addItemView:itemView animated:NO];
}
- (void)addItemView:(MQDragToMoveItemView *)itemView animated:(BOOL)animated
{
    CGFloat width = self.frame.size.width / _numberOfColumns;
    NSInteger index = self.items.count;
    CGRect rect = CGRectMake(index%_numberOfColumns*width, index/_numberOfColumns*_itemViewHeight, width, _itemViewHeight);
    
    if (animated) {//执行动画
        
        if (self.animatedDelegate &&
            [self.animatedDelegate respondsToSelector:@selector(addItemViewAnimated:)]) {//代理执行动画
            itemView.frame = rect;
            [self.animatedDelegate addItemViewAnimated:itemView];
        } else {
            itemView.frame = CGRectMake(rect.origin.x + (rect.size.width / 2),
                                        rect.origin.y + (rect.size.height / 2),
                                        0, 0);
            [UIView animateWithDuration:0.3 animations:^{
                itemView.frame = rect;
            }];
            [self addSubview:itemView];
        }
        
    } else {
        
        itemView.frame = rect;
        [self addSubview:itemView];
    }
    
    [self.items addObject:itemView];
    
    NSInteger row = (int)(self.items.count / self.numberOfColumns) + ((self.items.count % self.numberOfColumns > 0) ? 1 : 0);
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.itemViewHeight * row);
}
- (void)insertItemView:(MQDragToMoveItemView *)itemView atIndex:(NSInteger)index
{
    [self insertItemView:itemView atIndex:index animated:NO];
}
- (void)insertItemView:(MQDragToMoveItemView *)itemView atIndex:(NSInteger)index animated:(BOOL)animated
{
    [self.items insertObject:itemView atIndex:index];
    
     CGFloat width = self.frame.size.width / _numberOfColumns;
    CGRect rect = CGRectMake(index%_numberOfColumns*width, index/_numberOfColumns*_itemViewHeight, width, _itemViewHeight);
    
    if (animated) {//执行动画

        itemView.frame = CGRectMake(rect.origin.x + (rect.size.width / 2),
                                    rect.origin.y + (rect.size.height / 2),
                                    0, 0);
        [UIView animateWithDuration:0.3 animations:^{
            itemView.frame = rect;
        }];
        [self addSubview:itemView];
    } else {
        
        itemView.frame = rect;
        [self addSubview:itemView];
    }
    
    for (NSInteger i = index+1; i < self.items.count; ++i) {
        
        MQDragToMoveItemView *view = self.items[i];
        view.index = i;
        
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = CGRectMake(i%_numberOfColumns*width, i/_numberOfColumns*_itemViewHeight, width, _itemViewHeight);
            }];
        } else {
            view.frame = CGRectMake(i%_numberOfColumns*width, i/_numberOfColumns*_itemViewHeight, width, _itemViewHeight);
        }
    }
    
    NSInteger row = (int)(self.items.count / self.numberOfColumns) + ((self.items.count % self.numberOfColumns > 0) ? 1 : 0);
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.itemViewHeight * row);
}
- (void)removeItemsViewAtIndex:(NSUInteger)index
{
    [self removeItemsViewAtIndex:index animated:NO];
}
- (void)removeItemsViewAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    MQDragToMoveItemView *itemView = self.items[index];
    
    CGFloat width = self.frame.size.width / _numberOfColumns;
 
    if (animated) {//动画
        
        if (self.animatedDelegate &&
            [self.animatedDelegate respondsToSelector:@selector(removeItemsViewAnimated:index:)]) {//代理执行动画
            [self.animatedDelegate removeItemsViewAnimated:itemView index:index];
        } else {
            CGRect rect = CGRectMake(itemView.frame.origin.x + (itemView.frame.size.width / 2),
                                     itemView.frame.origin.y + (itemView.frame.size.height / 2),
                                     0, 0);
            [UIView animateWithDuration:0.3 animations:^{
                itemView.frame = rect;
            } completion:^(BOOL finished) {
                [itemView removeFromSuperview];
            }];
        }
        
    } else {
        [itemView removeFromSuperview];
    }
    
    [self.items removeObjectAtIndex:index];
    for (NSInteger i = index; i < self.items.count; ++i) {
        
        MQDragToMoveItemView *view = self.items[i];
        view.index = i;
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = CGRectMake(i%_numberOfColumns*width, i/_numberOfColumns*_itemViewHeight, width, _itemViewHeight);
            }];
        } else {
            view.frame = CGRectMake(i%_numberOfColumns*width, i/_numberOfColumns*_itemViewHeight, width, _itemViewHeight);
        }
    }
    
    NSInteger row = (int)(self.items.count / self.numberOfColumns) + ((self.items.count % self.numberOfColumns > 0) ? 1 : 0);
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.itemViewHeight * row);
}

#pragma mark - itemView手势代理
- (void)MQDragToMoveItemTapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(MQDragToMoveViewItemTapGestureRecognizer:)]) {
        [self.delegate MQDragToMoveViewItemTapGestureRecognizer:(MQDragToMoveItemView *)tap.view];
    }
}
- (void)MQDragToMoveItemLongPressSelected:(UILongPressGestureRecognizer *)longPress
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(MQDragToMoveViewItemLongPressSelected:)]) {
        [self.delegate MQDragToMoveViewItemLongPressSelected:(MQDragToMoveItemView *)longPress.view];
    }
}
- (void)MQDragToMoveItemPanGestureRecognizer:(UIPanGestureRecognizer *)panGesture
{
    static CGPoint changedPoint;
    
    MQDragToMoveItemView *panGestureView = (MQDragToMoveItemView *)panGesture.view;
    [self bringSubviewToFront:panGestureView];
    
    NSInteger row = self.items.count / self.numberOfColumns + (self.items.count % self.numberOfColumns > 0 ? 1 : 0);
    BOOL isChanged = NO;
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
        changedPoint = CGPointMake(0, 0);
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [panGesture translationInView:self];
        panGestureView.center = CGPointMake(panGestureView.center.x + point.x, panGestureView.center.y + point.y);
        [panGesture setTranslation:CGPointMake(0, 0) inView:self];
        
        changedPoint.x += point.x;
        changedPoint.y += point.y;
        
        CGFloat yMovingMax = panGestureView.frame.size.height / 2;
        CGFloat xMovingMax = panGestureView.frame.size.width / 2;
        
        //确定行可不可以移动
        if (changedPoint.y < -yMovingMax) {//上
            
            isChanged = YES;
            
            NSInteger currentIndex = panGestureView.index;
            if (currentIndex >= _numberOfColumns) {
                
                NSInteger currentRow = currentIndex / _numberOfColumns;
                NSInteger currentSection = currentIndex % _numberOfColumns;
                if (currentRow > 0) {
                    
                    NSInteger changedIndex = (currentRow - 1) * self.numberOfColumns + currentSection;
                    
                    if ([self indexIsMove:changedIndex]) {
                        CGFloat width = self.frame.size.width / _numberOfColumns;
                        for (NSInteger i = currentIndex; i > changedIndex; --i) {
                            MQDragToMoveItemView *view = self.items[i-1];
                            self.items[i] = view;
                            view.index = i;
                            [UIView animateWithDuration:0.3 animations:^{
                                view.frame = CGRectMake(i%_numberOfColumns*width, i/_numberOfColumns*_itemViewHeight, width, _itemViewHeight);
                            }];
                        }
                        self.items[changedIndex] = panGestureView;
                        panGestureView.index = changedIndex;
                    }
                }
            }
            
        } else if (changedPoint.y > yMovingMax) {//下
            isChanged = YES;
            
            NSInteger currentIndex = panGestureView.index;
            if (currentIndex < self.items.count-1) {
                
                NSInteger currentRow = currentIndex / _numberOfColumns;
                NSInteger currentSection = currentIndex % _numberOfColumns;
                if (currentRow < row-1) {
                    
                    NSInteger changedIndex = (currentRow + 1) * _numberOfColumns + currentSection;
                    
                    if ([self indexIsMove:changedIndex]) {
                        if (changedIndex < self.items.count) {
                            CGFloat width = self.frame.size.width / _numberOfColumns;
                            for (NSInteger i = currentIndex; i < changedIndex; ++i) {
                                MQDragToMoveItemView *view = self.items[i+1];
                                self.items[i] = view;
                                view.index = i;
                                [UIView animateWithDuration:0.3 animations:^{
                                    view.frame = CGRectMake(i%_numberOfColumns*width, i/_numberOfColumns*_itemViewHeight, width, _itemViewHeight);
                                }];
                            }
                            self.items[changedIndex] = panGestureView;
                            panGestureView.index = changedIndex;
                        }
                    }
                }
            }
            
        }
        
        //确定列可不可以移动
        if (changedPoint.x < -xMovingMax) {//左
            isChanged = YES;
            
            NSInteger currentIndex = panGestureView.index;
            NSInteger currentSection = currentIndex % self.numberOfColumns;
            if (index > 0 && currentSection != 0) {
                
                NSInteger changedIndex = currentIndex - 1;
                
                if ([self indexIsMove:changedIndex]) {
                    //itemView
                    MQDragToMoveItemView *view = self.items[changedIndex];
                    self.items[currentIndex] = view;
                    view.index = currentIndex;
                    self.items[changedIndex] = panGestureView;
                    panGestureView.index = changedIndex;
                    
                    CGFloat width = self.frame.size.width / _numberOfColumns;
                    [UIView animateWithDuration:0.3 animations:^{
                        view.frame = CGRectMake(currentIndex%_numberOfColumns*width, currentIndex/_numberOfColumns*_itemViewHeight, width, _itemViewHeight);
                    }];
                }
            }
        } else if (changedPoint.x > xMovingMax) {//右
            isChanged = YES;
            
            NSInteger currentIndex = panGestureView.index;
            NSInteger currentSection = currentIndex % self.numberOfColumns;
            if (currentIndex < self.items.count-1 &&
                currentSection != self.numberOfColumns - 1) {
                
                NSInteger changedIndex = currentIndex + 1;
                
                if ([self indexIsMove:changedIndex]) {
                    CGFloat width = self.frame.size.width / _numberOfColumns;
                    
                    //itemView
                    MQDragToMoveItemView *view = self.items[changedIndex];
                    self.items[currentIndex] = view;
                    view.index = currentIndex;
                    self.items[changedIndex] = panGestureView;
                    panGestureView.index = changedIndex;
                    [UIView animateWithDuration:0.3 animations:^{
                        view.frame = CGRectMake(currentIndex%_numberOfColumns*width, currentIndex/_numberOfColumns*_itemViewHeight, width, _itemViewHeight);
                    }];
                }
            }
        }
        
        //根据移动后的位置重新设定changedPoint坐标
        if (isChanged) {
            CGFloat width = self.frame.size.width / _numberOfColumns;
            NSInteger index = panGestureView.index;
            CGFloat x = index % _numberOfColumns * width;
            CGFloat y = index / _numberOfColumns * _itemViewHeight;
            changedPoint.x = panGestureView.frame.origin.x - x;
            changedPoint.y = panGestureView.frame.origin.y - y;
        }
        
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        
        //手指松开滑动后重新调整当前view的位置
        CGFloat width = self.frame.size.width / _numberOfColumns;
        NSInteger index = panGestureView.index;
        CGFloat x = index % _numberOfColumns * width;
        CGFloat y = index / _numberOfColumns * _itemViewHeight;
        if (panGestureView.frame.origin.x != x ||
            panGestureView.frame.origin.y != y) {
            [UIView animateWithDuration:0.3 animations:^{
                panGestureView.frame = CGRectMake(x, y, panGestureView.frame.size.width, panGestureView.frame.size.height);
            }];
        }
        
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(MQDragToMoveViewItemGestureRelease:)]) {
            [self.delegate MQDragToMoveViewItemGestureRelease:(MQDragToMoveItemView *)panGesture.view];
        }
    }
}

#pragma mark -
- (BOOL)indexIsMove:(NSInteger)index
{
    BOOL isMoveIndex = YES;
//    if (self.nonMoveIndexArray && self.nonMoveIndexArray.count) {
//        for (int i = 0; i < self.nonMoveIndexArray.count; ++i) {
//            if (index == [self.nonMoveIndexArray[i] integerValue]) {
//                isMoveIndex = NO;
//                break;
//            }
//        }
//    }
    return isMoveIndex;
}

#pragma mark - get/set
- (NSMutableArray<MQDragToMoveItemView *> *)items
{
    if (_items == nil) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}
- (void)setNumberOfColumns:(NSInteger)numberOfColumns
{
    if (_numberOfColumns != numberOfColumns) {
        _numberOfColumns = numberOfColumns;
        [self updatedToView];
    }
}
- (void)setItemViewHeight:(CGFloat)itemViewHeight
{
    if (_itemViewHeight != itemViewHeight) {
        _itemViewHeight = itemViewHeight;
        [self updatedToView];
    }
}
//- (void)setNonMoveIndexArray:(NSArray<NSNumber *> *)nonMoveIndexArray
//{
//    if (nonMoveIndexArray) {
//        _nonMoveIndexArray = nonMoveIndexArray ? nonMoveIndexArray : @[];
//        
//        NSInteger noIndexJ = 0;
//        for (int i = 0; i < self.items.count; ++i) {
//            MQDragToMoveItemView *item = self.items[i];
//            
//            if (noIndexJ < _nonMoveIndexArray.count &&
//                [_nonMoveIndexArray[noIndexJ] intValue] == i) {
//                item.userInteractionEnabled = NO;
//                ++noIndexJ;
//            } else {
//                item.userInteractionEnabled = YES;
//            }
//        }
//    }
//}

@end
