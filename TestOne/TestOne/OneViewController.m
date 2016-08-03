//
//  OneViewController.m
//  TestOne
//
//  Created by 郭榜 on 16/7/26.
//  Copyright © 2016年 Learn. All rights reserved.
//

#import "OneViewController.h"
#import "ARViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    
    //
    ARViewController *overView = [[ARViewController alloc] init];

    [self.navigationController pushViewController:overView animated:NO];
//
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
