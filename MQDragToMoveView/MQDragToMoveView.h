//
//  MQDragToMoveView.h
//
//  Created by 杨孟强 on 16/6/16.
//  Copyright © 2016年 杨孟强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQDragToMoveItemView.h"


/**代理*/
@protocol MQDragToMoveViewDelegate <NSObject>

@optional

/**点击*/
- (void)MQDragToMoveViewItemTapGestureRecognizer:(MQDragToMoveItemView *)itemView;
/**长按选中*/
- (void)MQDragToMoveViewItemLongPressSelected:(MQDragToMoveItemView *)itemView;
/**手势释放*/
- (void)MQDragToMoveViewItemGestureRelease:(MQDragToMoveItemView *)itemView;

@end



/**动画代理*/
@protocol MQDragToMoveViewAnimatedDelegate <NSObject>

@optional
/**自定义动画需要自己调用[dragToMoveView addSubview:itemView];或[itemView removeFromSuperview];代码*/
- (void)addItemViewAnimated:(MQDragToMoveItemView *)itemView;
- (void)removeItemsViewAnimated:(MQDragToMoveItemView *)itemView index:(NSUInteger)index;

@end


@interface MQDragToMoveView : UIView<MQDragToMoveItemDelegate>

@property (nonatomic, weak) id<MQDragToMoveViewDelegate> delegate;
@property (nonatomic, weak) id<MQDragToMoveViewAnimatedDelegate> animatedDelegate;

@property (nonatomic, strong) NSMutableArray<MQDragToMoveItemView *> *items;

/**列数*/
@property (nonatomic) NSInteger numberOfColumns;
/**itemView高度*/
@property (nonatomic) CGFloat itemViewHeight;
///**不可移动位置集合*/
//@property (nonatomic, strong) NSArray<NSNumber *> *nonMoveIndexArray;


/*
    类方法创建MQDragToMoveView
 */
+ (instancetype)createMQDragToMoveViewWithFrame:(CGRect)frame delegate:(id<MQDragToMoveViewDelegate>)delegate itemNumberOfColumns:(NSInteger)itemNumberOfColumns itemCount:(NSInteger)itemCount itemViewHeight:(CGFloat)itemViewHeight userInfoArray:(NSArray *)userInfoArray;

/*
    根据初始化信息添加Item
    userInfo 附加信息
 */
- (MQDragToMoveItemView *)addItemViewAndUserInfo:(id)userInfo animated:(BOOL)animated;
/*
    添加Item
 */
- (void)addItemView:(MQDragToMoveItemView *)itemView;
/*
    添加Item
    animated 是否执行动画
 */
- (void)addItemView:(MQDragToMoveItemView *)itemView animated:(BOOL)animated;

/*
    插入Item
    atIndex 插入位置
 */
- (void)insertItemView:(MQDragToMoveItemView *)itemView atIndex:(NSInteger)index;
/*
    插入Item
    atIndex 插入位置
    animated 是否执行动画
*/
- (void)insertItemView:(MQDragToMoveItemView *)itemView atIndex:(NSInteger)index animated:(BOOL)animated;

/*
    删除Item
 */
- (void)removeItemsViewAtIndex:(NSUInteger)index;
/*
    删除Item
    animated 是否执行动画
 */
- (void)removeItemsViewAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end
