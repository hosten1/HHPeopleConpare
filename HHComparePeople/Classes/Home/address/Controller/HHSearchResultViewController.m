//
//  HHSearchResultViewController.m
//  HankowThamesCode
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import "HHSearchResultViewController.h"
#import "HHAddressDatasDB.h"
#define mScreenSize [UIScreen mainScreen].bounds.size

@interface HHSearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, weak)UITableView *searchTableView;
@property(nonatomic, strong)HHAddressDatasDB *nameDB;
@property(nonatomic, strong)NSArray *nameArray;
@end

@implementation HHSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithRed:(245/255.0) green:245/255.0 blue:245/255.0 alpha:0.9];
//    NSLog(@"接受改变的值：%@",self.FiledText);
    if (self.nameDB == nil)
    {
        _nameDB = [[HHAddressDatasDB alloc]init];
    }
    self.nameArray = [self.nameDB findAllCityNameAndTownNameWithName:self.FiledText];
//    NSLog(@"%@nameArray:%@",self.FiledText,self.nameArray);
     [self addTableView];
}
-(void)addTableView{
    //tableView
    CGFloat tabY = 10;
    CGFloat heithy = mScreenSize.height - tabY;
    /*
     
     */
    UITableView *homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tabY, mScreenSize.width, heithy) style:UITableViewStylePlain];
    homeTableView.backgroundColor = [UIColor clearColor];
    homeTableView.delegate = self;
    homeTableView.dataSource = self;
    self.searchTableView = homeTableView;
    [self.view addSubview:homeTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *searchID = @"searchID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchID];
    }
    NSString *name = self.nameArray[indexPath.row];
    cell.textLabel.text = name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    选中第一个
    //    NSLog(@"ffffff");
    UITableViewCell  *cell = [self.searchTableView  cellForRowAtIndexPath:indexPath];
    NSString *name = cell.textLabel.text;
    //发送一个空的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAddressNotification" object:self userInfo:@{@"addressChange":name}];
//    NSLog(@"点击的cell>>>>>>%@",name);
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
