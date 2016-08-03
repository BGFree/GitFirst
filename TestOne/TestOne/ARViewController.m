//
//  ARViewController.m
//  ARtest
//
//  Created by admin on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ARViewController.h"
#import <CoreLocation/CoreLocation.h>
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
@interface ARViewController ()<CLLocationManagerDelegate,BMKLocationServiceDelegate>
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
    
    UIImageView *imageV;
    
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) UIImageView *compassView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDirection currentHeading;
@end
@implementation ARViewController
@synthesize compassView;

@synthesize currentHeading;


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor clearColor];

    dataArray = [NSMutableArray array];
    
    
    
    gifstartangle = 360;
    label = [[UILabel alloc] init];
    [self.view addSubview:label];
    labelx = [[UILabel alloc] init];
    [self.view addSubview:label];
    gifloader = [[UIWebView alloc] init];
    [self.view addSubview:gifloader];
    mikuloader = [[UIWebView alloc] init];
    [self.view addSubview:mikuloader];
    imageV = [[UIImageView alloc] init];
    [self.view addSubview:imageV];
    imageV.backgroundColor = [UIColor redColor];
    
    
    
    showLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50)];
    [self.view addSubview:showLable];
    showLable.textAlignment = NSTextAlignmentCenter;
    
    showLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 50)];
    [self.view addSubview:showLable1];
    showLable1.textAlignment = NSTextAlignmentCenter;
    

    
    [self changeLocation];
    [self customInitialize];
    [self startacce];
    [self loadgif];
    
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.mediaTypes = temp_MediaTypes;
        
        picker.showsCameraControls = NO;

        picker.cameraOverlayView = self.view;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat aspectRatio = 4.0/3.0;
        CGFloat scale = screenSize.height/screenSize.width * aspectRatio;
        picker.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
    }
    
    
    [self presentViewController:picker animated:NO completion:nil];

}


- (void)customInitialize {
    
    cityHeading = 0.0;
    currentHeading = 0.0;

    array = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"288" forKey:@"angel"];
    [dic setObject:@"100" forKey:@"r"];
    

    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:@"111" forKey:@"angel"];
    [dic2 setObject:@"88" forKey:@"r"];
    [array addObject:dic];
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
    gpshead = theHeading;
    label.text = [NSString stringWithFormat:@"地理朝向：%f",gpshead];
    self.currentHeading = theHeading;
    [self changegifangle];

    [self updateHeadingDisplays];
}

-(void)startacce{
    UIAccelerometer *acce = [UIAccelerometer sharedAccelerometer];
    acce.delegate = self;
    acce.updateInterval = 1.0f/60.0f;
}
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    accez = acceleration.z;
    //    NSLog(@"acceleration = %f", acceleration.z);
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


-(void)changegifangle{

    
    for (int i = 0; i < dataArray.count; i++) {
        UIWebView *webview = dataArray[i];
        NSDictionary *dic = array[i];
        float r = [[dic objectForKey:@"r"] floatValue];
        float pointAngle1 = [[dic objectForKey:@"angel"] floatValue];
        mikustart = pointAngle1;
        
        scale = r / 200 * 50;//根据AR物体模拟的距离来定
        if (gpshead < 180) {
            mikuanglex = -gpshead + mikustart;
        }else{
            mikuanglex = 360-gpshead + mikustart;
        }
        
        
        if (mikuanglex < 180) {//初音酱是固定在朝向角度0方向的，这种都能自己调
            mikux = mikuanglex * scale;
        }else{
            mikux = (mikuanglex - 360) * scale;
        }
        
        angley = 240 * accez * 2;//“2”这个修正值也是根据AR物体模拟的距离来定
        
        [webview setFrame:CGRectMake(mikux, angley + 100, gifsize.width, gifsize.height)];
        NSLog(@"mikuloader = %@", webview);
        
        
        
        
        
    }
    
    
    

}

-(void)loadgif{
    
    NSData *gifdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yt" ofType:@"gif"]];
    CGRect gifframe = CGRectMake(0, 0, 0, 0);
    gifsize = [UIImage imageNamed:@"yt.gif"].size;
    gifframe.size = gifsize;
    [gifloader setFrame:gifframe];
    gifloader.backgroundColor = [UIColor clearColor];
    gifloader.opaque = NO;
    [gifloader loadData:gifdata MIMEType:@"image/gif" textEncodingName:nil baseURL:Nil];
    
    gifdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"miku" ofType:@"gif"]];
    gifsize = [UIImage imageNamed:@"miku.gif"].size;
    gifframe.size = gifsize;
    [mikuloader setFrame:gifframe];
    mikuloader.backgroundColor = [UIColor clearColor];
    mikuloader.opaque = NO;
    [mikuloader loadData:gifdata MIMEType:@"image/gif" textEncodingName:nil baseURL:Nil];
    [dataArray addObject:gifloader];
    [dataArray addObject:mikuloader];
    
    
}





- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
