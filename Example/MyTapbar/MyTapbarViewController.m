//
//  MyTapbarViewController.m
//  MyTapbar
//
//  Created by 蔡成汉 on 03/28/2016.
//  Copyright (c) 2016 蔡成汉. All rights reserved.
//

#import "MyTapbarViewController.h"
#import "MyTapbar.h"

@interface MyTapbarViewController ()<MyTapbarDelegate>

@property (nonatomic , strong) MyTapbar *tapbar;

@end

@implementation MyTapbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _tapbar = [[MyTapbar alloc]init];
    _tapbar.backgroundColor = [UIColor greenColor];
    _tapbar.frame = CGRectMake(0, 100, self.view.frame.size.width, 60);
    _tapbar.delegate = self;
    _tapbar.showIndicator = YES;
    _tapbar.selectFont = [UIFont systemFontOfSize:18];
    _tapbar.unSelectFont = [UIFont systemFontOfSize:16];
    _tapbar.dataArray = [NSArray arrayWithObjects:@"我的数据一",@"我的数据二",@"我的超长数据三",@"我的数据四",@"我的数据五",@"我的数据六",@"我的数据七",@"我的数据八",@"我的超长数据九",@"我的数据十",@"我的数据十一",@"我的数据十二", nil];
    [self.view addSubview:_tapbar];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tapbar.frame = CGRectMake(0, 100, self.view.frame.size.width, 60);
}

#pragma mark - MyTapbarDelegate

-(void)myTapbar:(MyTapbar *)tapbar itemIsTouch:(NSInteger)index
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
