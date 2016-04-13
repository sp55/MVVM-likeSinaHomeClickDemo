//
//  CustomTabBarController.m
//  Test
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "CustomTabBarController.h"
#import "ViewController.h"
#import "SingersViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) /255.0) alpha:1.0]


//http://www.jianshu.com/p/5b84f871bf7e

@interface CustomTabBarController ()<UITabBarControllerDelegate>
/** 记录上一次被点击按钮的tag */
@property (nonatomic, assign) NSInteger previousClickedTag;

@end

@implementation CustomTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self addChildViewController:@"SingersViewController" title:@"Singer" image:@"" selectedImage:@""];
    [self addChildViewController:@"ViewController" title:@"Test" image:@"" selectedImage:@""];
}
- (void)addChildViewController:(NSString *)childController title:(NSString *)title image:(NSString *)normalImg selectedImage:(NSString *)selectedImg {
    Class class = NSClassFromString(childController);
    UIViewController *controller = [[class alloc] init];
    controller.title = title;

    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [navi.tabBarItem setImage:[[UIImage imageNamed:normalImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [navi.tabBarItem setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [navi.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [navi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1.0f]} forState:UIControlStateNormal];
    [navi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(37, 175, 153)} forState:UIControlStateSelected];
    [self addChildViewController:navi];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    NSLog(@"点击了tabBarController");
    NSInteger index = tabBarController.selectedIndex;
    
    //判断当前按钮是否为上一个按钮
    if (self.previousClickedTag == index) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:
         @"TabbarButtonClickDidRepeatNotification" object:nil];
    }
    self.previousClickedTag = index;

}


@end
