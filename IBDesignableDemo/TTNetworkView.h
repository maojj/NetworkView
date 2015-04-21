//
//  TTNetworkView.h
//  Tutor
//
//  Created by maojj on 4/20/15.
//  Copyright (c) 2015 fenbi. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface TTNetworkView : UIView

@property (nonatomic) IBInspectable CGFloat strengh;
@property (nonatomic, strong) IBInspectable UIColor *strokeColor;
@property (nonatomic, strong) IBInspectable UIColor *fillColor;

@end
