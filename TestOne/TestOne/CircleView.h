//
//  CircleView.h
//  TestOne
//
//  Created by 郭榜 on 16/7/20.
//  Copyright © 2016年 Learn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView
-(id)initWithFrame:(CGRect)frame andArray:(NSArray *)array;
@property (strong, nonatomic) NSArray *array;
@end
