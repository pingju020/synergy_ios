

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LPLineJoinRound = 0,//圆形
    LPLineJoinSquare,//正方形
    LPLineJoinTriangle,//正三角形
} LPLineJoinStyle;

typedef enum : NSUInteger {
    LPValueSituationNone = 0,
    LPValueSituationTop,
    LPValueSituationBottom,
} LPValueSituation;

@interface SumLineChart : UIView
/**  数据  */
@property (nonatomic, strong) NSArray *valueArray;
/**  折线宽度  */
@property (nonatomic, assign) CGFloat lineWidth;
/**  折线颜色  */
@property (nonatomic, strong) UIColor *lineColor;
/**  折点样式  */
@property (nonatomic, assign) LPLineJoinStyle linejoinStyle;
/**  折点颜色  */
@property (nonatomic, strong) UIColor *lineJoinPointColor;
/**  折点宽度（采用折点中心到正上方的距离）  */
@property (nonatomic, assign) CGFloat lineJoinPointWidth;
/**  折点数组  */
@property (nonatomic, strong) NSArray *pointArray;
/**  上边距  */
@property (nonatomic, assign) CGFloat topSpace;
/**  下边距  */
@property (nonatomic, assign) CGFloat bottomSpace;
/**  左边距  */
@property (nonatomic, assign) CGFloat leftSpace;
/**  右边距  */
@property (nonatomic, assign) CGFloat rightSpace;
/**  边距  */
@property (nonatomic, assign) UIEdgeInsets edge;
/**  文本位置  */
@property (nonatomic, assign) LPValueSituation valueSituation;
/**  文本格式  */
@property (nonatomic, strong) NSDictionary *valueTextAttribute;
/**  文本到折点中心的垂直距离  */
@property (nonatomic, assign) CGFloat valueStringPadding;
/**  前缀  */
@property (nonatomic, copy) NSString *prefixString;
/**  后缀  */
@property (nonatomic, copy) NSString *suffixString;
//底部描述
@property (nonatomic, strong) NSArray *descArray;

/**
 *  画折线  折点宽1.6倍线宽/颜色/无前后缀/文本到折点10/无格式/文本在上/默认边距
 *
 *  @param valueArray         数据数组
 *  @param lineWidth          折线宽度
 *  @param tintColor          填充颜色
 *  @param linejoinStyle      折点类型
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth tintColor:(UIColor *)tintColor lineJionStyle:(LPLineJoinStyle) linejoinStyle;


/**
 *  画折线  无前后缀/文本到折点10/无格式/文本在上/默认边距
 *
 *  @param valueArray         数据数组
 *  @param lineWidth          折线宽度
 *  @param tintColor          填充颜色
 *  @param linejoinStyle      折点类型
 *  @param lineJoinPointWidth 折点宽度
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth tintColor:(UIColor *)tintColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointWidth:(CGFloat) lineJoinPointWidth;
/**
 *  画折线  无前后缀/文本到折点10/无格式/文本在上/默认边距
 *
 *  @param valueArray         数据数组
 *  @param lineWidth          折线宽度
 *  @param lineColor          折线颜色
 *  @param linejoinStyle      折点类型
 *  @param lineJoinPointColor 折点颜色
 *  @param lineJoinPointWidth 折点宽度
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth;

/**
 *  画折线  无前后缀/文本到折点10/无格式/文本在上/egde边距
 *
 *  @param valueArray         数据数组
 *  @param lineWidth          折线宽度
 *  @param lineColor          折线颜色
 *  @param linejoinStyle      折点类型
 *  @param lineJoinPointColor 折点颜色
 *  @param lineJoinPointWidth 折点宽度
 *  @param edge               四周边距
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth edgeInsets:(UIEdgeInsets)edge;

/**
 *  画折线  无前后缀/文本到折点10/无格式/文本在上
 *
 *  @param valueArray         数据数组
 *  @param lineWidth          折线宽度
 *  @param lineColor          折线颜色
 *  @param linejoinStyle      折点类型
 *  @param lineJoinPointColor 折点颜色
 *  @param lineJoinPointWidth 折点宽度
 *  @param topPadding         顶部间距
 *  @param rightPadding       右间距
 *  @param bottomPadding      底部间距
 *  @param leftPadding        左间距
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth topPadding:(CGFloat ) topPadding rightPadding:(CGFloat) rightPadding bottomPadding:(CGFloat ) bottomPadding leftPadding:(CGFloat ) leftPadding;
/**
 *  画折线  无前后缀/文本到折点10/无格式
 *
 *  @param valueArray         数据数组
 *  @param lineWidth          折线宽度
 *  @param lineColor          折线颜色
 *  @param linejoinStyle      折点类型
 *  @param lineJoinPointColor 折点颜色
 *  @param lineJoinPointWidth 折点宽度
 *  @param topPadding         顶部间距
 *  @param rightPadding       右间距
 *  @param bottomPadding      底部间距
 *  @param leftPadding        左间距
 *  @param valueSituation     文本位置
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth topPadding:(CGFloat ) topPadding rightPadding:(CGFloat) rightPadding bottomPadding:(CGFloat ) bottomPadding leftPadding:(CGFloat ) leftPadding valueSituation:(LPValueSituation )valueSituation;

/**
 *  画折线 无前后缀 默认文本到折点距离10.0
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth topPadding:(CGFloat ) topPadding rightPadding:(CGFloat) rightPadding bottomPadding:(CGFloat ) bottomPadding leftPadding:(CGFloat ) leftPadding valueSituation:(LPValueSituation )valueSituation valueTextAttributes:(NSDictionary *)valueTextAttribute;

/**
 *  画折线 无前后缀
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth topPadding:(CGFloat ) topPadding rightPadding:(CGFloat) rightPadding bottomPadding:(CGFloat ) bottomPadding leftPadding:(CGFloat ) leftPadding valueSituation:(LPValueSituation )valueSituation valueStringPadding:(CGFloat )valueStringPadding valueTextAttributes:(NSDictionary *)valueTextAttribute;
/**
 *  画折线
 *
 *  @param valueArray         数据数组
 *  @param lineWidth          折线宽度
 *  @param lineColor          折线颜色
 *  @param linejoinStyle      折点类型
 *  @param lineJoinPointColor 折点颜色
 *  @param lineJoinPointWidth 折点宽度
 *  @param topPadding         顶部间距
 *  @param rightPadding       右间距
 *  @param bottomPadding      底部间距
 *  @param leftPadding        左边距
 *  @param valueSituation     文本位置
 *  @param prefixString       文本前缀
 *  @param suffixString       文本后缀
 *  @param valueStringPadding 文本与折点的垂直距离
 *  @param valueTextAttribute 文本格式
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth topPadding:(CGFloat ) topPadding rightPadding:(CGFloat) rightPadding bottomPadding:(CGFloat ) bottomPadding leftPadding:(CGFloat ) leftPadding valueSituation:(LPValueSituation )valueSituation prefixString:(NSString *)prefixString suffixString:(NSString *)suffixString valueStringPadding:(CGFloat )valueStringPadding valueTextAttributes:(NSDictionary *)valueTextAttribute;

@end
