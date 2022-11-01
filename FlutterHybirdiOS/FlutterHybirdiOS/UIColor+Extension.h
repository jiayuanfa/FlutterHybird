//
//  UIColor+WXExtension.h
//  EthPlanet
//
//  Created by 赵玉堂 on 2019/7/4.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GradientStyleFromLeftToRight,
    GradientStyleFromTopToBottom,
    GradientStyleFromRadial,//径向的
    GradientStyleFromDiagonal,//对角线
} GradientStyle;

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;
// 颜色渐变
+ (UIColor *)colorWithGradientStyle:(GradientStyle)gradientStyle Frame:(CGRect)frame Colors:(NSArray<UIColor *>*)colors;

/**
 * 在第一色和第二色之间按指定比例渐变:
 *
 *    @ ratio 0.0 - fully firstColor
 *    @ ratio 0.5 - halfway between firstColor and secondColor
 *    @ ratio 1.0 - fully secondColor
 *
 */

+ (UIColor *)colorForFadeBetweenFirstColor:(UIColor *)firstColor
                               secondColor:(UIColor *)secondColor
                                   atRatio:(CGFloat)ratio;

/**
 * 和上面一样，但是允许关闭颜色空间比较
 * 以提高性能.
 */

+ (UIColor *)colorForFadeBetweenFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor atRatio:(CGFloat)ratio compareColorSpaces:(BOOL)compare;

/**
 * 一个[steps]颜色数组，从firstColor开始，继续线性插值
 * 介于firstColor和lastColor之间，最后以lastColor结尾
 */
+ (NSArray *)colorsForFadeBetweenFirstColor:(UIColor *)firstColor
                                lastColor:(UIColor *)lastColor
                                    inSteps:(NSUInteger)steps;

/**
 * 一个由[steps]颜色组成的数组，从firstColor开始，按照指定的顺序进行插值
 * by the equation block，在firstColor和lastColor之间，最后以lastColor结束 The equation block
 * 必须接受一个浮点数作为输入，返回一个浮点数作为输出。产出将被认为介于两者之间
 * 比率为0.0和1.0。为方程传递nil将导致一个线性关系.
 */
+ (NSArray *)colorsForFadeBetweenFirstColor:(UIColor *)firstColor
                                  lastColor:(UIColor *)lastColor
                          withRatioEquation:(float (^)(float input))equation
                                    inSteps:(NSUInteger)steps;
    

/**
 * 转换UIColor到RGBA色彩空间。用于跨颜色空间插值.
 */
+ (UIColor *)colorConvertedToRGBA:(UIColor *)colorToConvert;


/**
 * Creates a CAKeyframeAnimation for the given key path, duration, and first/last colors that can be
 * applied to an appropriate CALayer property (i.e. backgroundColor). See the demo for example usage.
 */
+ (CAKeyframeAnimation *)keyframeAnimationForKeyPath:(NSString *)keyPath
                                            duration:(NSTimeInterval)duration
                                   betweenFirstColor:(UIColor *)firstColor
                                           lastColor:(UIColor *)lastColor;


/**
 * Same as above, but allows setting a ratio equation (for non-linear transitions between colors) and
 * the number of steps to calculate. Decreasing steps may improve performance as it decreases the number
 * of cross-fade calculations necessary.
 */
+ (CAKeyframeAnimation *)keyframeAnimationForKeyPath:(NSString *)keyPath
                                            duration:(NSTimeInterval)duration
                                   betweenFirstColor:(UIColor *)firstColor
                                           lastColor:(UIColor *)lastColor
                                   withRatioEquation:(float (^)(float))equation
                                             inSteps:(NSUInteger)steps;

@end

NS_ASSUME_NONNULL_END
