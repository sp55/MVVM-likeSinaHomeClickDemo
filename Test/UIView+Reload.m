//
//  UIView+Reload.m
//  Test
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "UIView+Reload.h"

@implementation UIView (Reload)

/** 判断self和anotherView是否重叠 */
- (BOOL)hu_intersectsWithAnotherView:(UIView *)anotherView
{
    
    //如果anotherView为nil，那么就代表keyWindow
    if (anotherView == nil) anotherView = [UIApplication sharedApplication].keyWindow;
    
    
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    
    CGRect anotherRect = [anotherView convertRect:anotherView.bounds toView:nil];
    
    //CGRectIntersectsRect是否有交叉
    return CGRectIntersectsRect(selfRect, anotherRect);
}


@end
