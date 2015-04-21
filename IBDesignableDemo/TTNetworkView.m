//
//  TTNetworkView.m
//  Tutor
//
//  Created by maojj on 4/20/15.
//  Copyright (c) 2015 fenbi. All rights reserved.
//

#import "TTNetworkView.h"

static NSInteger LayerCount = 4;

@implementation TTNetworkView {
    NSMutableArray *shapeLayers;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customSetup];
    }
    return self;
}

- (void)setStrengh:(CGFloat)strengh {
    strengh = MIN(strengh, 1);
    strengh = MAX(strengh, 0);
    _strengh = strengh;
    [self setNeedsDisplay];
}

- (void)setstrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)customSetup {
    shapeLayers = [NSMutableArray arrayWithCapacity:LayerCount];
    for (NSInteger index = 0; index < LayerCount; index ++) {
        CAShapeLayer *layer = [self getLayerForIndex:index];
        [self.layer addSublayer:layer];
        [shapeLayers addObject:layer];
    }
}

- (void)layoutSubviews {
    // update layers' path
    [shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *layer, NSUInteger idx, BOOL *stop) {
        layer.path = [[self getPathForIndex:idx] CGPath];
    }];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [shapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer *layer, NSUInteger idx, BOOL *stop) {
        // 1. strokeColor
        layer.strokeColor = [[self strokeColor] CGColor];

        // 2. fillcolor
        CGFloat threshold = ((CGFloat)idx + 1.f) / ((CGFloat)LayerCount + 1.f);
        if (self.strengh >= threshold) {
            layer.fillColor = [self.fillColor CGColor];
        } else {
            layer.fillColor = [[UIColor clearColor] CGColor];
        }

        // 3. setNeedsDisplay
        [layer setNeedsDisplay];
    }];
}

- (CAShapeLayer *)getLayerForIndex:(NSInteger)index {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [self getPathForIndex:index];
    layer.path = [path CGPath];
    layer.strokeColor = [self strokeColor].CGColor;
    layer.fillColor = [self fillColor].CGColor;
    return layer;
}

- (UIBezierPath *)getPathForIndex:(NSInteger)index {
    CGFloat minWidth = MIN(self.frame.size.width, self.frame.size.height) * 0.8;
    CGFloat startAngle = M_PI * (1.5 - 0.25f);
    CGFloat endAngle = M_PI * (1.5 + 0.25f);
    CGFloat height = floorf(minWidth / 7);
    CGPoint center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height - height);
    CGFloat radius = (index * 2 - 1) * height;

    UIBezierPath *path;
    if (index == 0) {
        CGRect dotRect = CGRectMake(center.x - height / 2, center.y - height / 2, height, height);
        path = [UIBezierPath bezierPathWithOvalInRect:dotRect];
    } else {
        path = [self circleSectorPathForRadius:radius height:height center:center startAngle:startAngle endAngle:endAngle];
    }
    return path;
}


/**
 *  
 *          D
 *          /\
 *         /  \
 *        /    \
 *     A  \     \
 *         \     \
 *          \     \
 *         B \_____\  C
 *  
 */
- (UIBezierPath *)circleSectorPathForRadius:(CGFloat)radius height:(CGFloat)height center:(CGPoint)center startAngle:(CGFloat)startAngle endAngle:(CGFloat)endangle {
    UIBezierPath *sectorPath = [UIBezierPath bezierPath];
    // A->B
    [sectorPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endangle clockwise:YES];
    // C->D  (also include B->C)
    [sectorPath addArcWithCenter:center radius:(radius + height) startAngle:endangle endAngle:startAngle clockwise:NO];
    // D->A
    [sectorPath closePath];
    return sectorPath;
}

@end
