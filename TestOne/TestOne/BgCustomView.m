//
//  BgCustomView.m
//  TestOne
//
//  Created by 郭榜 on 16/7/20.
//  Copyright © 2016年 Learn. All rights reserved.
//

#import "BgCustomView.h"
#import <QuartzCore/QuartzCore.h>
#define PI 3.14159265358979323846
@implementation BgCustomView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    
    
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    

    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
//    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);//填充颜色
    //以10为半径围绕圆心画指定角度扇形
    CGContextMoveToPoint(context, 50, 50);
    CGContextAddArc(context, 50, 50, 50,  -60 * PI / 180, -120 * PI / 180, 1);
    // 画直线，关闭圆弧
    CGContextAddLineToPoint(context, 50, 50);
//    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    // 显示所绘制的图形
    CGContextFillPath(context);

    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
