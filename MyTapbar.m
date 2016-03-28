//
//  MyTapbar.m
//  MyTapbar
//
//  Created by 蔡成汉 on 16/3/25.
//  Copyright © 2016年 蔡成汉. All rights reserved.
//

#import "MyTapbar.h"
#import <Addition/AdditionFrameworks.h>

@interface MyTapbar ()
{
    /**
     *  上一次选中的index -- 默认为0
     */
    NSInteger lastSelectIndex;
}
/**
 *  scrollView
 */
@property (nonatomic , strong) UIScrollView *scrollView;

/**
 *  指示器
 */
@property (nonatomic , strong) UIImageView *indicatorView;

@end

@implementation MyTapbar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _sepWidth = _sidesWidth = 20.0;
        _selectColor = _indicatorColor = [UIColor redColor];
        _unSelectColor = [UIColor blackColor];
        _selectFont = _unSelectFont = [UIFont systemFontOfSize:16.0];
        _indicatorHeight = 3.0;
        _showIndicator = NO;
        _scrollAnimationTime = 0.5;
        _selectIndex = lastSelectIndex = 0;
        [self initialView];
    }
    return self;
}

-(void)initialView
{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _indicatorView = [[UIImageView alloc]init];
    _indicatorView.backgroundColor = _indicatorColor;
    [_scrollView addSubview:_indicatorView];
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    if (_dataArray != nil)
    {
        [self resetSelectItemFrame:YES];
    }
    [self setNeedsLayout];
}

-(void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    [self setNeedsLayout];
}

-(void)setUnSelectColor:(UIColor *)unSelectColor
{
    _unSelectColor = unSelectColor;
    [self setNeedsLayout];
}

-(void)setSelectFont:(UIFont *)selectFont
{
    _selectFont = selectFont;
    [self setNeedsLayout];
}

-(void)setUnSelectFont:(UIFont *)unSelectFont
{
    _unSelectFont = unSelectFont;
    [self setNeedsLayout];
}

-(void)setSepWidth:(CGFloat)sepWidth
{
    _sepWidth = sepWidth;
    [self setNeedsLayout];
}

-(void)setSidesWidth:(CGFloat)sidesWidth
{
    _sidesWidth = sidesWidth;
    [self setNeedsLayout];
}

-(void)setIndicatorHeight:(CGFloat)indicatorHeight
{
    _indicatorHeight = indicatorHeight;
    [self setNeedsLayout];
}

-(void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    _indicatorView.backgroundColor = _indicatorColor;
    [self setNeedsLayout];
}

-(void)setShowIndicator:(BOOL)showIndicator
{
    _showIndicator = showIndicator;
    [self setNeedsLayout];
}

-(void)setScrollAnimationTime:(NSTimeInterval)scrollAnimationTime
{
    _scrollAnimationTime = scrollAnimationTime;
    [self setNeedsLayout];
}

-(void)setShowType:(MyTapbarShowType)showType
{
    _showType = showType;
    [self setNeedsLayout];
}

-(void)setDataArray:(NSArray *)dataArray
{
    if (dataArray != nil)
    {
        _dataArray = dataArray;
        
        /**
         *  移除非重用部分
         */
        for (id obj in _scrollView.subviews)
        {
            if (obj != _indicatorView)
            {
                [obj removeFromSuperview];
            }
        }
        
        /**
         *  创建非重用部分
         */
        for (int i = 0; i<dataArray.count; i++)
        {
            /**
             *  创建控件
             */
            UILabel *tpLabel = [[UILabel alloc]init];
            tpLabel.tag = 100 + i;
            tpLabel.backgroundColor = [UIColor clearColor];
            tpLabel.textAlignment = NSTextAlignmentCenter;
            tpLabel.userInteractionEnabled = YES;
            [_scrollView addSubview:tpLabel];
            
            /**
             *  添加tap手势
             */
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
            [tpLabel addGestureRecognizer:tapGes];
            
            /**
             *  数据分发 -- 这里只接受数组元素为字符串或字典（键为title）
             */
            id obj = [dataArray objectAtIndex:i];
            if ([obj isKindOfClass:[NSString class]])
            {
                tpLabel.text = obj;
            }
            else if ([obj isKindOfClass:[NSDictionary class]])
            {
                tpLabel.text = [obj getStringValueForKey:@"title"];
            }
        }
    }
    [self setNeedsLayout];
}


/**
 *  重置选中项的frame -- 以及指示器的位置
 *
 *  @param animation YES则采用动画,NO则不采用动画
 */
-(void)resetSelectItemFrame:(BOOL)animation
{
    NSTimeInterval scrollTime = 0.0;
    if (animation == YES)
    {
        scrollTime = _scrollAnimationTime;
    }
    else
    {
        scrollTime = 0.0;
    }
    if (_dataArray != nil)
    {
        /**
         *  获取目标item
         */
        UILabel *tpLabel = [_scrollView viewWithTag:100 + _selectIndex];
        
        /**
         *  获取目标item宽度
         */
        CGFloat tpWidthSelect = [tpLabel.text getStringSize:_selectFont maxWidth:CGFLOAT_MAX].width;
        
        CGFloat tpWidthUnSelect = [tpLabel.text getStringSize:_unSelectFont maxWidth:CGFLOAT_MAX].width;
        
        CGFloat tpLabelWidth = (tpWidthSelect>tpWidthUnSelect)?tpWidthSelect:tpWidthUnSelect;
        
        /**
         *  进行计算 -- 滚动到“指定”的位置
         */
        if (_scrollView.contentSize.width > self.width)
        {
            /**
             *  需要滚动
             */
            if (_showType == MyTapbarShowTypeDefault)
            {
                /**
                 *  居中对齐
                 */
                if (tpLabel.centerX<self.centerX)
                {
                    /**
                     *  目标label中心点偏左，达不到向中心移动要求 -- 切换指示器frame -- 需要知道上一次指示器的位置
                     */
                    
                    [UIView animateWithDuration:scrollTime animations:^{
                        _scrollView.contentOffset = CGPointMake(0, 0);
                        _indicatorView.frame = CGRectMake(tpLabel.left, self.height - _indicatorHeight, tpLabelWidth, _indicatorHeight);
                    }];
                }
                else
                {
                    /**
                     *  目标label中心点偏右，则需要计算剩下的区域是否可用
                     */
                    if ((_scrollView.contentSize.width - tpLabel.centerX)>self.width/2.0)
                    {
                        /**
                         *  可移动 -- 切换指示器frame -- 需要知道上一次指示器的位置
                         */
                        [UIView animateWithDuration:scrollTime animations:^{
                            _scrollView.contentOffset = CGPointMake(tpLabel.centerX - self.width/2.0, 0);
                            _indicatorView.frame = CGRectMake(tpLabel.left, self.height - _indicatorHeight, tpLabelWidth, _indicatorHeight);
                        }];
                    }
                    else
                    {
                        /**
                         *  不可移动 -- 切换指示器frame -- 需要知道上一次指示器的位置
                         */
                        [UIView animateWithDuration:scrollTime animations:^{
                            _scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width - self.width, 0);
                            _indicatorView.frame = CGRectMake(tpLabel.left, self.height - _indicatorHeight, tpLabelWidth, _indicatorHeight);
                        }];
                    }
                }
            }
            else
            {
                /**
                 *  居左对齐
                 */
                CGFloat tpSideWidth = 0.0;
                if (_selectIndex == 0)
                {
                    /**
                     *  第一项
                     */
                    tpSideWidth = _sidesWidth;
                }
                else
                {
                    /**
                     *  非第一项
                     */
                    tpSideWidth = _sepWidth;
                }
                if ((_scrollView.contentSize.width - tpLabel.left - tpSideWidth)>self.width)
                {
                    /**
                     *  可移动
                     */
                    [UIView animateWithDuration:scrollTime animations:^{
                        _scrollView.contentOffset = CGPointMake(tpLabel.left - tpSideWidth, 0);
                        _indicatorView.frame = CGRectMake(tpLabel.left, self.height - _indicatorHeight, tpLabelWidth, _indicatorHeight);
                    }];
                }
                else
                {
                    /**
                     *  不可移动
                     */
                    [UIView animateWithDuration:scrollTime animations:^{
                        _scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width - self.width, 0);
                        _indicatorView.frame = CGRectMake(tpLabel.left, self.height - _indicatorHeight, tpLabelWidth, _indicatorHeight);
                    }];
                }
            }
        }
        else
        {
            /**
             *  根据选中的索引切换指示器位置
             */
            [UIView animateWithDuration:scrollTime animations:^{
                _indicatorView.frame = CGRectMake(tpLabel.left, self.height - _indicatorHeight, tpLabelWidth, _indicatorHeight);
            }];
        }
    }
}

#pragma mark -- 标题Label手势点击

-(void)tapGes:(UITapGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded)
    {
        lastSelectIndex = _selectIndex;
        self.selectIndex = ges.view.tag - 100;
        if ([self.delegate respondsToSelector:@selector(myTapbar:itemIsTouch:)])
        {
            [self.delegate myTapbar:self itemIsTouch:_selectIndex];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_scrollView bringSubviewToFront:_indicatorView];
    if (_showIndicator == NO)
    {
        _indicatorView.hidden = YES;
    }
    else
    {
        _indicatorView.hidden = NO;
    }
    
    _scrollView.frame = CGRectMake(0, 0, self.width, self.height);
    
    if (_dataArray != nil)
    {
        /**
         *  确定各个标题的位置，同时累计scrollView的contentSize（需要同步设置颜色、字体）
         */
        CGFloat sunWidth = 0.0;
        for (int i = 0; i<_dataArray.count; i++)
        {
            UILabel *tpLabel = [_scrollView viewWithTag:100 + i];
            
            
            /**
             *  当_selectFont和_unSelectFont不一样的时候，则需要从2者中选出一个较大值作为当前item的值
             */
            CGFloat tpWidthSelect = [tpLabel.text getStringSize:_selectFont maxWidth:CGFLOAT_MAX].width;
            
            CGFloat tpWidthUnSelect = [tpLabel.text getStringSize:_unSelectFont maxWidth:CGFLOAT_MAX].width;
            
            CGFloat tpLabelWidth = (tpWidthSelect>tpWidthUnSelect)?tpWidthSelect:tpWidthUnSelect;
            sunWidth = sunWidth + tpLabelWidth;
        }
        sunWidth = sunWidth + _sepWidth*(_dataArray.count - 1) + _sidesWidth*2;
        if (sunWidth>self.width)
        {
            _scrollView.contentSize = CGSizeMake(sunWidth, self.height);
        }
        else
        {
            _scrollView.contentSize = CGSizeMake(self.width, self.height);
        }
        
        CGFloat tpSunWidth = 0.0;
        if (sunWidth > self.width)
        {
            /**
             *  按照设定方式处理 -- 依次显示（设定起点）
             */
            tpSunWidth = _sidesWidth;
            
        }
        else
        {
            /**
             *  按照“设定”方式处理 -- 依次显示（设定起点）
             */
            CGFloat tpSidesWidth = (self.width - (sunWidth - _sidesWidth*2.0))/2.0;
            tpSunWidth = tpSidesWidth;
        }
        
        /**
         *  顺序展示
         */
        for (int i = 0; i<_dataArray.count; i++)
        {
            UILabel *tpLabel = [_scrollView viewWithTag:100 + i];
            
            CGFloat tpWidthSelect = [tpLabel.text getStringSize:_selectFont maxWidth:CGFLOAT_MAX].width;
            
            CGFloat tpWidthUnSelect = [tpLabel.text getStringSize:_unSelectFont maxWidth:CGFLOAT_MAX].width;
            
            CGFloat tpLabelWidth = (tpWidthSelect>tpWidthUnSelect)?tpWidthSelect:tpWidthUnSelect;
            
            if (i == _selectIndex)
            {
                /**
                 *  发现选中item
                 */
                tpLabel.textColor = _selectColor;
                tpLabel.font = _selectFont;
                _indicatorView.frame = CGRectMake(tpLabel.left, self.height - _indicatorHeight, tpLabel.width, _indicatorHeight);
            }
            else
            {
                /**
                 *  普通item
                 */
                tpLabel.textColor = _unSelectColor;
                tpLabel.font = _unSelectFont;
            }
            tpLabel.frame = CGRectMake(tpSunWidth, 0, tpLabelWidth, self.height);
            tpSunWidth = tpSunWidth + tpLabelWidth + _sepWidth;
        }
        
        [self resetSelectItemFrame:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
