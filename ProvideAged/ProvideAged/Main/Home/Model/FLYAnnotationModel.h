//
//  FLYAnnotationModel.h
//  ProvideAged
//
//  Created by fly on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYAnnotationModel : NSObject < MKAnnotation >

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
