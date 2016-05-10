//
//  HHAddressPosition.m
//  HankowThamesCode
//
//  Created by mac on 16/3/7.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHAddressPosition.h"
#import <CoreLocation/CoreLocation.h>

@implementation HHAddressPosition
//地理编码
-(void)addressGecode:(NSString*)address{
    // 1.取出用户输入的地址
   
    if (address.length == 0) {
        NSLog(@"输入地址不能为空");
        return ;
    }
    __block  NSDictionary *_addr;

    // 2.地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    while (_addr == nil) {
//        NSLog(@"_addr:%@",_addr);
            [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
            // 1.如果解析有错误,或者解析出的数组个数为0.直接返回
            if (placemarks.count == 0 || error) return;
            
            // 2.便利所有的地标对象(如果是实际开发,可以给用户以列表的形式展示)
            for (CLPlacemark *pm in placemarks) {
                // 2.1.取出用户的位置信息
                CLLocation *location = pm.location;
                // 2.2.取出用户的经纬度
                CLLocationCoordinate2D coordinate = location.coordinate;
                
                // 2.3.将信息设置到界面上
                NSString * Latitudetext = [NSString stringWithFormat:@"%.2f", coordinate.latitude];
                NSString * Longitudetext = [NSString stringWithFormat:@"%.2f",coordinate.longitude];
                NSString *nameText = pm.name;
                //            NSLog(@"latitude:%@,longTitude:%@",Latitudetext,Longitudetext);
                _addr = [NSDictionary dictionaryWithObjects:@[nameText,Longitudetext,Latitudetext] forKeys:@[@"addressName",@"longtitude",@"latitude"]];
                
                [self setAddressDict:_addr];
                
                NSLog(@" address:...%@",_addr);
            }
        }];
//    }
    
 
}
/*****地理反编码**/
-(void)addressRervsecodeWithLatitude:(NSString*)latitude longtitude:(NSString*)longitude{
    

    __block NSString *name;
    if (latitude.length == 0 || longitude.length == 0) {
        return ;
    }
      CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
    
//    while (_addressName == nil) {

        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            // 如果有错误,或者解析出来的地址数量为0
            if (placemarks.count == 0 || error) return ;
            
            // 取出地标,就可以取出地址信息,以及CLLocation对象
            CLPlacemark *pm = [placemarks firstObject];
            
#pragma mark -- 注意:如果是取出城市的话,需要判断locality属性是否有值(直辖市时,该属性为空)
            if (pm.locality) {
                name = pm.locality;
            } else {
                name = pm.administrativeArea;
            }
            [self setAddressName:name];
            //           dispatch_semaphore_signal(semaphore);
//            NSLog(@"...ddd%@",name);
            
        }];
   
    
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    return _addressName;
}

@end
