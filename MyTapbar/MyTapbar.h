//
//  MyTapbar.h
//  MyTapbar
//
//  Created by 蔡成汉 on 16/3/25.
//  Copyright © 2016年 蔡成汉. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  展示方式
 */
typedef NS_ENUM(NSInteger , MyTapbarShowType) {
    /**
     *  居中对齐 -- 默认展示方式
     */
    MyTapbarShowTypeDefault = 0,
    /**
     *  居左对齐 -- 当数据项总宽度小于tapbar宽度时，则居中对齐
     */
    MyTapbarShowTypeLeft = 1
};

@protocol MyTapbarDelegate;

@interface MyTapbar : UIView

/**
 *  delegate
 */
@property (nonatomic , weak) id<MyTapbarDelegate>delegate;

/**
 *  选中的索引 -- 默认为0
 */
@property (nonatomic , assign) NSInteger selectIndex;

/**
 *  选中颜色
 */
@property (nonatomic , strong) UIColor *selectColor;

/**
 *  未选中的颜色
 */
@property (nonatomic , strong) UIColor *unSelectColor;

/**
 *  选中的字体
 */
@property (nonatomic , strong) UIFont *selectFont;

/**
 *  为选中的字体
 */
@property (nonatomic , strong) UIFont *unSelectFont;

/**
 *  分割宽度 -- 默认为20像素宽度
 */
@property (nonatomic , assign) CGFloat sepWidth;

/**
 *  边界宽度 -- 这个值在数据项总长度超过控件的宽度的时候，会起到作用；默认和sepWidth相同
 */
@property (nonatomic , assign) CGFloat sidesWidth;

/**
 *  指示器高度 -- 默认为3像素高度
 */
@property (nonatomic , assign) CGFloat indicatorHeight;

/**
 *  指示器颜色 -- 默认为item项选中颜色
 */
@property (nonatomic , strong) UIColor *indicatorColor;

/**
 *  是否展示指示器 -- 默认为NO
 */
@property (nonatomic , assign) BOOL showIndicator;

/**
 *  滚动动画时间 -- 默认为0.5秒
 */
@property (nonatomic , assign) NSTimeInterval scrollAnimationTime;

/**
 *  tapbar展示方式
 */
@property (nonatomic , assign) MyTapbarShowType showType;

/**
 *  标题数组 -- 数组元素为字符串或者字典；当为字典时，需要指定title，否则不接受
 */
@property (nonatomic , strong) NSArray *dataArray;

@end

@protocol MyTapbarDelegate <NSObject>

@optional

/**
 *  目标项点击
 *
 *  @param tapbar MyTapbar
 *  @param index  index
 */
-(void)myTapbar:(MyTapbar *)tapbar itemIsTouch:(NSInteger)index;

@end
