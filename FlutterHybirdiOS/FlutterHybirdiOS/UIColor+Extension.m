//
//  UIColor+Extension.m
//  EthPlanet
//
//  Created by 赵玉堂 on 2019/7/4.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1];
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}


+ (UIColor *)colorFromHexString:(NSString *)hexString {
   return [self colorFromHexString:hexString alpha:1.0];
}
+ (UIColor *)colorWithGradientStyle:(GradientStyle)gradientStyle Frame:(CGRect)frame Colors:(NSArray<UIColor *>*)colors{
    
    CAGradientLayer *backgroundGradientLayer = [CAGradientLayer layer];
    backgroundGradientLayer.frame = frame;
    
    NSMutableArray *cgColors = [[NSMutableArray alloc] init];
    for (UIColor *color in colors) {
        [cgColors addObject:(id)[color CGColor]];
    }
    
    switch (gradientStyle) {
            
        case GradientStyleFromLeftToRight: {
            
            backgroundGradientLayer.colors = cgColors;
            [backgroundGradientLayer setStartPoint:CGPointMake(0.0, 0.5)];
            [backgroundGradientLayer setEndPoint:CGPointMake(1.0, 0.5)];
            
            UIGraphicsBeginImageContextWithOptions(backgroundGradientLayer.bounds.size,NO, [UIScreen mainScreen].scale);
            [backgroundGradientLayer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return [UIColor colorWithPatternImage:backgroundColorImage];
        }
            
        case GradientStyleFromRadial: {
            
            UIGraphicsBeginImageContextWithOptions(frame.size,NO, [UIScreen mainScreen].scale);
            CGFloat locations[2] = {0.0, 1.0};
            CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
            CFArrayRef arrayRef = (__bridge CFArrayRef)cgColors;
            
            CGGradientRef myGradient = CGGradientCreateWithColors(myColorspace, arrayRef, locations);
            CGPoint myCentrePoint = CGPointMake(0.5 * frame.size.width, 0.5 * frame.size.height);
            float myRadius = MIN(frame.size.width, frame.size.height) * 0.5;
            
            CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, myCentrePoint,
                                         0, myCentrePoint, myRadius,
                                         kCGGradientDrawsAfterEndLocation);
            UIImage *backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext();
            
            CGColorSpaceRelease(myColorspace);
            CGGradientRelease(myGradient);
            UIGraphicsEndImageContext();
            
            return [UIColor colorWithPatternImage:backgroundColorImage];
        }
            
        case GradientStyleFromDiagonal: {
            
            backgroundGradientLayer.colors = cgColors;
            [backgroundGradientLayer setStartPoint:CGPointMake(0.0, 1.0)];
            [backgroundGradientLayer setEndPoint:CGPointMake(1.0, 0.0)];
            
            UIGraphicsBeginImageContextWithOptions(backgroundGradientLayer.bounds.size,NO, [UIScreen mainScreen].scale);
            [backgroundGradientLayer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return [UIColor colorWithPatternImage:backgroundColorImage];
        }
            
        case GradientStyleFromTopToBottom:
            
        default: {
            
            backgroundGradientLayer.colors = cgColors;
            
            UIGraphicsBeginImageContextWithOptions(backgroundGradientLayer.bounds.size,NO, [UIScreen mainScreen].scale);
            [backgroundGradientLayer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return [UIColor colorWithPatternImage:backgroundColorImage];
        }
            
    }
}
+ (UIColor *)colorForFadeBetweenFirstColor:(UIColor *)firstColor
                               secondColor:(UIColor *)secondColor
                                   atRatio:(CGFloat)ratio {
    return [self colorForFadeBetweenFirstColor:firstColor secondColor:secondColor atRatio:ratio compareColorSpaces:YES];
    
}

+ (UIColor *)colorForFadeBetweenFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor atRatio:(CGFloat)ratio compareColorSpaces:(BOOL)compare {
    // Eliminate values outside of 0 <--> 1
    ratio = MIN(MAX(0, ratio), 1);
    
    // Convert to common RGBA colorspace if needed
    if (compare) {
        if (CGColorGetColorSpace(firstColor.CGColor) != CGColorGetColorSpace(secondColor.CGColor))
        {
            firstColor = [UIColor colorConvertedToRGBA:firstColor];
            secondColor = [UIColor colorConvertedToRGBA:secondColor];
        }
    }
    
    // Grab color components
    const CGFloat *firstColorComponents = CGColorGetComponents(firstColor.CGColor);
    const CGFloat *secondColorComponents = CGColorGetComponents(secondColor.CGColor);
    
    // Interpolate between colors
    CGFloat interpolatedComponents[CGColorGetNumberOfComponents(firstColor.CGColor)] ;
    for (NSUInteger i = 0; i < CGColorGetNumberOfComponents(firstColor.CGColor); i++)
    {
        interpolatedComponents[i] = firstColorComponents[i] * (1 - ratio) + secondColorComponents[i] * ratio;
    }
    
    // Create interpolated color
    CGColorRef interpolatedCGColor = CGColorCreate(CGColorGetColorSpace(firstColor.CGColor), interpolatedComponents);
    UIColor *interpolatedColor = [UIColor colorWithCGColor:interpolatedCGColor];
    CGColorRelease(interpolatedCGColor);
    
    return interpolatedColor;
}

+ (NSArray *)colorsForFadeBetweenFirstColor:(UIColor *)firstColor
                                lastColor:(UIColor *)lastColor
                                    inSteps:(NSUInteger)steps {
    
    return [self colorsForFadeBetweenFirstColor:firstColor lastColor:lastColor withRatioEquation:nil inSteps:steps];
}

+ (NSArray *)colorsForFadeBetweenFirstColor:(UIColor *)firstColor lastColor:(UIColor *)lastColor withRatioEquation:(float (^)(float input))equation inSteps:(NSUInteger)steps {
    // Handle degenerate cases
    if (steps == 0)
        return nil;
    if (steps == 1)
        return [NSArray arrayWithObject:firstColor];
    if (steps == 2)
        return [NSArray arrayWithObjects:firstColor, lastColor, nil];
    
    // Assume linear if no equation is passed
    if (equation == nil) {
        equation = ^(float input) {
            return input;
        };
    }
    
    // Calculate step size
    CGFloat stepSize = 1.0f / (steps - 1);
    
    // Array to store colors in steps
    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:steps];
    [colors addObject:firstColor];
    
    // Compute intermediate colors
    CGFloat ratio = stepSize;
    for (int i = 2; i < steps; i++)
    {
        [colors addObject:[self colorForFadeBetweenFirstColor:firstColor secondColor:lastColor atRatio:equation(ratio)]];
        ratio += stepSize;
    }
    
    [colors addObject:lastColor];
    return colors;
}

+ (CAKeyframeAnimation *)keyframeAnimationForKeyPath:(NSString *)keyPath
                                            duration:(NSTimeInterval)duration
                                   betweenFirstColor:(UIColor *)firstColor
                                           lastColor:(UIColor *)lastColor
{
    return [UIColor keyframeAnimationForKeyPath:keyPath
                                       duration:duration
                              betweenFirstColor:firstColor
                                      lastColor:lastColor
                              withRatioEquation:^float(float input) {
                                  return input;
                              } inSteps:floorf(duration * 30.0f)];
}

+ (CAKeyframeAnimation *)keyframeAnimationForKeyPath:(NSString *)keyPath
                                            duration:(NSTimeInterval)duration
                                   betweenFirstColor:(UIColor *)firstColor
                                           lastColor:(UIColor *)lastColor
                                   withRatioEquation:(float (^)(float input))equation
                                             inSteps:(NSUInteger)steps
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    
    NSArray *colorRefs = [[self colorsForFadeBetweenFirstColor:firstColor lastColor:lastColor withRatioEquation:equation inSteps:steps] valueForKeyPath:@"CCF_CGColor"];
    
    animation.values = colorRefs;
    return animation;
}

#pragma mark - Helpers
                       
+ (UIColor *)colorConvertedToRGBA:(UIColor *)colorToConvert;
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    // Convert color to RGBA with a CGContext. UIColor's getRed:green:blue:alpha: doesn't work across color spaces. Adapted from http://stackoverflow.com/a/4700259

    alpha = CGColorGetAlpha(colorToConvert.CGColor);
    
    CGColorRef opaqueColor = CGColorCreateCopyWithAlpha(colorToConvert.CGColor, 1.0f);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[CGColorSpaceGetNumberOfComponents(rgbColorSpace)];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, opaqueColor);
    CGColorRelease(opaqueColor);
    CGContextFillRect(context, CGRectMake(0.f, 0.f, 1.f, 1.f));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    red = resultingPixel[0] / 255.0f;
    green = resultingPixel[1] / 255.0f;
    blue = resultingPixel[2] / 255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (id)valueForUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"CCF_CGColor"]) {
        return (id)self.CGColor;
    }
    
    return [super valueForUndefinedKey:key];
}


@end
