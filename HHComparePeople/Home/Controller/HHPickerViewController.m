//
//  HHPickerViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHPickerViewController.h"
#import "HHAddressDatasDB.h"
#import "HHProvince.h"
#import "HHCity.h"
#import "HHtown.h"

@interface HHPickerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic, strong)NSArray *provinceArray;
@property(nonatomic, strong)NSArray *cityDic;
@property(nonatomic, strong)NSArray *countryDic;
@property(nonatomic, strong)HHAddressDatasDB *addre;
@end

@implementation HHPickerViewController
//懒加载初始化数据
//-(NSArray*)provinceArray{
//    if (_provinceArray == nil) {
//         HHAddressDatasDB *addre = [[HHAddressDatasDB alloc]init];
//        _cityDic = [NSArray array];
//        _countryDic = [NSArray array];
//        _provinceArray = [NSArray array];
//       
//        _addre = addre;
//        _provinceArray = [addre findProvinceOfAll];
////         NSLog(@"pro:....%@",_provinceArray);
//    }
//    return _provinceArray;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    HHAddressDatasDB *addre = [[HHAddressDatasDB alloc]init];
    _cityDic = [NSArray array];
    _countryDic = [NSArray array];
    _provinceArray = [NSArray array];
    
    _addre = addre;
    _provinceArray = [addre findProvinceOfAll];
//    NSLog(@"...hahah%@",_provinceArray);
    
//    //市
//    _cityDic = @{
//                 @"北京":@[@"朝阳区", @"东城区", @"西城区"],
//                 @"广西":@[@"桂林市", @"南宁市"],
//                 @"广东":@[@"惠州市", @"广州市", @"深圳市",@"东莞市"]
//                 };
//
//    //县区
//    _countryDic= @{
//                   @"朝阳区":@[@"朝阳区1", @"朝阳区2", @"朝阳区3"],
//                   @"东城区":@[@"东城区1", @"东城区2",@"东城区3",@"东城区4"],
//                   @"西城区":@[@"西城区1", @"西城区2", @"西城区3",@"西城区4"],
//                   @"桂林市":@[@"桂林市1", @"桂林市2", @"桂林市3"],
//                   @"南宁市":@[@"南宁市1", @"南宁市2",@"南宁市3",@"南宁市4"],
//                   @"惠州市":@[@"惠州市1", @"惠州市2", @"惠州市3",@"惠州市4"],
//                   @"广州市":@[@"广州市1", @"广州市2", @"广州市3"],
//                   @"深圳市":@[@"深圳市1", @"深圳市2",@"深圳市3",@"深圳市4"],
//                   @"东莞市":@[@"东莞市1", @"东莞市2", @"东莞市3",@"东莞市4"],
//                   };
//    NSLog(@"%@,%@,%@",_cityDic,_countryDic,_provinceArray);
    // 初始化数据
    [self initpickerView];
}
-(void)initpickerView{
    UIPickerView *pickView = [[UIPickerView alloc]init];
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.frame = CGRectMake(0, 0, 320, 70);
    [self.view addSubview:pickView];
}

#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}
#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (0 == component){
        return self.provinceArray.count;
    }else if(1 == component){
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        HHProvince *province = self.provinceArray[rowProvince];
        
        NSString *provinceCode = province.provinceCode;
      //根据省分查询市
        _cityDic = [_addre findCityOfAllWithProvinceCode:provinceCode];
        return _cityDic.count;
    }
    
    return 0;
}
//设置UIPickerView的代理方法，代码如下：

#pragma mark - 该方法返回的NSString将作为UIPickerView中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (0 == component) {
        HHProvince * province = self.provinceArray[row];
        
        return province.provinceName;
    }else if(1 == component){
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        HHProvince *province = self.provinceArray[rowProvince];
        NSString *provinceCode = province.provinceCode;
        if ([provinceCode isEqualToString:@"710000"] ||[provinceCode isEqualToString:@"810000"] ||[provinceCode isEqualToString:@"820000"]) {
         
                return @"未知";
           
        }
        //根据省分查询市
        _cityDic = [_addre findCityOfAllWithProvinceCode:provinceCode];
//        NSLog(@"provinceName:%@-------%@",provinceName,citys[row]);
       
        HHCity *ci = _cityDic[row];
        return ci.cityName;
    }
       return nil;
}
//当选中某行时，通过如下的代码即可获取到选中的城市地区，

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(0 == component){
       [pickerView reloadComponent:1];
    }else if (1 == component){
       NSInteger rowOne = [pickerView selectedRowInComponent:0];
       NSInteger rowTow = [pickerView selectedRowInComponent:1];
//    NSInteger rowThree = [pickerView selectedRowInComponent:2];
    
      HHProvince *procince = self.provinceArray[rowOne];
      NSString *provinCode = procince.provinceCode;
      NSString *provinceName = procince.provinceName;
      if ([provinCode isEqualToString:@"710000"] ||[provinCode isEqualToString:@"810000"] ||[provinCode isEqualToString:@"820000"]) {
        
         return ;
        
     }
     self.cityDic = [self.addre findCityOfAllWithProvinceCode:provinCode];
    
     HHCity *city = self.cityDic[rowTow];
     NSString *cityName = city.cityName;

//        NSLog(@"%@~%@",provinceName ,cityName );
        //存入沙盒 用户偏好设置中
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:cityName forKey:@"cityName"];
        [userDefault synchronize];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.view removeFromSuperview];
            //发送一个空的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameNotification" object:self userInfo:nil];
        });
        
    }
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
