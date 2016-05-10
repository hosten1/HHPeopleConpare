//
//  HHMyAnnoatation.h
//  HankowThamesCode
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 Hosten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface HHMyAnnoatation : NSObject<MKAnnotation>
// Center latitude and longitude of the annotation view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic,  copy) NSString *subtitle;
@end
