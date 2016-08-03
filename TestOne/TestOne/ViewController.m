//
//  ViewController.m
//  TestOne
//
//  Created by 郭榜 on 16/7/15.
//  Copyright © 2016年 Learn. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CLHeading.h>
#import "BgCustomView.h"
#import "CircleView.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件


#import "math.h"

#define toRad(X) (X*M_PI/180.0)
#define toDeg(X) (X*180.0/M_PI)
#define PI 3.14159265358979323846


@interface ViewController ()<CLLocationManagerDelegate,BMKLocationServiceDelegate>
{
    UIImageView   *compassView;
    
    CLLocationCoordinate2D  currentLocation;
    CLLocationDirection     currentHeading;
    
    CLLocationCoordinate2D  cityLocation;
    CLLocationDirection     cityHeading;
    UILabel *showLable;
    UILabel *showLable1;
    NSMutableArray *array;
    CircleView *circleV;
}

@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) UIImageView *compassView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDirection currentHeading;
@end


@implementation ViewController
@synthesize compassView;

@synthesize currentHeading;

- (void)customInitialize {
    
    cityHeading = 0.0;
    currentHeading = 0.0;

//    compassView = [[UIImageView alloc] initWithFrame:CGRectMake(375 - 100 - 10, 64, 100, 100)];
//    compassView.image = [UIImage imageNamed:@"compass"];
//    [self.view addSubview:compassView];
//
//    UIImageView * needleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(375 - 10 - 50 - 6, 64, 12, 100)];
//    needleImageV.image = [UIImage imageNamed:@"needle"];
//    [self.view addSubview:needleImageV];
    array = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"288" forKey:@"angel"];
    [dic setObject:@"100" forKey:@"r"];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:@"266" forKey:@"angel"];
    [dic1 setObject:@"70" forKey:@"r"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:@"111" forKey:@"angel"];
    [dic2 setObject:@"88" forKey:@"r"];
    [array addObject:dic];
    [array addObject:dic1];
    [array addObject:dic2];
    
    circleV = [[CircleView alloc] initWithFrame:CGRectMake(375 - 100 - 10, 64, 100, 100) andArray:array];
    [self.view addSubview:circleV];
    
    BgCustomView *customV = [[BgCustomView alloc] initWithFrame:CGRectMake(375 - 100 - 10, 64, 100, 100)];
    [self.view addSubview:customV];
    customV.alpha = 0.4;
    
    

}



- (void)updateHeadingDisplays {
    // Animate Compass
    [UIView     animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             CGAffineTransform headingRotation;
                             headingRotation = CGAffineTransformRotate(CGAffineTransformIdentity, (CGFloat)-toRad(currentHeading));
                             circleV.transform = headingRotation;
                             NSLog(@"currentHeading = %f", currentHeading);
                         }
                         completion:^(BOOL finished) {
                             
                         }];

    
    

    [self isContainArray];
    
    
    
    
    
}

-(void)isContainArray {
    NSString *str  = @"";
    showLable.text = @"";

    showLable1.text = @"";
    for (int i = 0; i < array.count; i++) {
        
        NSDictionary *tmp = array[i];

        

        float pointAngle1 = [[tmp objectForKey:@"angel"] floatValue];
        
        
        float angle = fabs (currentHeading - pointAngle1);
        if (angle <= 32) {
            
            showLable.text = @"在区域内";
            
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%d", i]];
            showLable1.text = str;
            
        }
    
    }
    
    
    
}

#pragma mark CLLocationManagerDelegate
/**
 * 获取经纬度
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currLocation=[locations lastObject];
    currentLocation = currLocation.coordinate;
    [self updateHeadingDisplays];
//    NSLog(@"la---%f, lo---%f",currLocation.coordinate.latitude,currLocation.coordinate.longitude);
}
/**
 *定位失败，回调此方法
 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

        NSLog(@"无法获取位置信息");

}


- (void)startLocationHeadingEvents {
    if (!self.locationManager) {
        CLLocationManager* theManager = [[CLLocationManager alloc] init];
        
        // Retain the object in a property.
        self.locationManager = theManager;
        self.locationManager.delegate = self;
    }
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=1.0;//十米定位一次
    // Start location services to get the true heading.
    self.locationManager.distanceFilter = distance;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
    
    // Start heading updates.
    if ([CLLocationManager headingAvailable]) {
        self.locationManager.headingFilter = 1;
        [self.locationManager startUpdatingHeading];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0)
        return;
    [self.locationManager startUpdatingLocation];
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
    self.currentHeading = theHeading;
    [self updateHeadingDisplays];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startLocationHeadingEvents];
    
    [self updateHeadingDisplays];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.locationManager) {
        [self.locationManager stopUpdatingHeading];
        [self.locationManager stopUpdatingLocation];
    }
    [super viewWillDisappear:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    showLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50)];
    [self.view addSubview:showLable];
    showLable.textAlignment = NSTextAlignmentCenter;
    
    showLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 50)];
    [self.view addSubview:showLable1];
    showLable1.textAlignment = NSTextAlignmentCenter;
    
    
    [self changeLocation];
    [self customInitialize];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(38.915,115.404));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    
    NSLog(@"distance =  %f", distance);
    
}

/**
 *  @author 郭榜
 *
 *  百度地图 获取空间位置
 */
-(void)changeLocation {

    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;

    [_locService startUserLocationService];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
