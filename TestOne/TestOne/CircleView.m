//
//  CircleView.m
//  TestOne
//
//  Created by 郭榜 on 16/7/20.
//  Copyright © 2016年 Learn. All rights reserved.
//

#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>
#import "math.h"

#define toRad(X) (X*M_PI/180.0)
#define toDeg(X) (X*180.0/M_PI)
#define PI 3.14159265358979323846
@implementation CircleView
- (id)initWithFrame:(CGRect)frame andArray:(NSArray *)array
{
    _array = array;
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


    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);//填充颜色
    CGContextAddArc(context, 50, 50, 50, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);
    CGContextAddArc(context,50, 50, 50 - 1, 0, 2 * PI, 0);
    CGContextSetLineWidth(context, 1.0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);
    CGContextAddArc(context,50, 50, 100 / 4, 0, 2 * PI, 0);
    CGContextSetLineWidth(context, 1.0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);
    CGContextAddArc(context,50, 50, 100 / 3, 0, 2 * PI, 0);
    CGContextSetLineWidth(context, 1.0);
    CGContextDrawPath(context, kCGPathStroke);
    


    
    float r = 200;

 
    for (NSDictionary *tmp in _array) {
        
        float point1 = [[tmp objectForKey:@"r"] floatValue];
        float pointAngle1 = [[tmp objectForKey:@"angel"] floatValue];
        
        CGFloat x1 = 50 * point1 / r * sin(2*PI/360*pointAngle1);
        CGFloat y1 = 50 * point1 / r * cos(2*PI/360*pointAngle1);
        
        
        NSLog(@"====   %f %f", x1, y1);
        
        
        // 画最后圆
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);//填充颜色
        CGContextAddArc(context,50 + x1 - 2, 50 - y1 - 2, 2, 0, 2 * PI, 0);
        CGContextDrawPath(context, kCGPathFill);
        
    }
    
    

    


    
//    CGContextAddArc(context,75, 15, 2, 0, 2 * PI, 0);
//    CGContextClosePath(context);
//    
//    CGContextAddArc(context,55, 80, 2, 0, 2 * PI, 0);
//    CGContextClosePath(context);

    CGContextDrawPath(context, kCGPathFill);
    
    // 显示所绘制的图形
//    CGContextFillPath(context);
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
