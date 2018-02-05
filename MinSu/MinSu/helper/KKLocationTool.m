//
//  KKLocationTool.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/4.
//

#import "KKLocationTool.h"
#import <CoreLocation/CoreLocation.h>

@interface  KKLocationTool()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager* locationManager;
@end

@implementation KKLocationTool

-(void)startLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        [KKAlert showAnimateWithStauts:@"定位中"];
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];//开始定位
        
    }else{
        //不能定位用户的位置的情况再次进行判断，并给与用户提示
        
        
    }
}
- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [KKAlert dismiss];
    [self.locationManager stopUpdatingLocation];
    //当前所在城市的坐标值
    CLLocation *currLocation = [locations lastObject];
    
    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSString * city;
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *address = [placemark addressDictionary];
            //  Country(国家)  State(省) City（市）
            city = [address objectForKey:@"City"];
            if (city) {
                [UserDefaults saveCityName:city];
                if (self.getCityBlock) {
                    self.getCityBlock();
                }
                return;
            }
        }
        if (city == nil) {
            [self.locationManager stopUpdatingLocation];
            [UserDefaults saveCityName:@"北京"];
            if (self.getCityBlock) {
                self.getCityBlock();
            }
        }
    }];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
//    if ([error code] == kCLErrorDenied){
//        [KKAlert showErrorHint:@"您拒绝了民宿访问您的位置,可以在设置中打开"];
//    } else {
//        [KKAlert showErrorHint:@"获取位置信息失败"];
//    }
    [KKAlert dismiss];
    [UserDefaults saveCityName:@"北京"];
    [self.locationManager stopUpdatingLocation];
    if (self.getCityBlock) {
        self.getCityBlock();
    }
}

@end
