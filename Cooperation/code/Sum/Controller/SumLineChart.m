

#import "SumLineChart.h"
//控件自身宽度 和 高度
#define kWidth self.frame.size.width
#define kHeight self.frame.size.height
//折点的 x 和 y
#define kPointX ((kWidth - self.leftSpace - self.rightSpace) / self.valueArray.count * (0.5 + i) + self.leftSpace)
#define kPointY ((kHeight - self.topSpace - self.bottomSpace) / a * (max - [self.valueArray[i] intValue]) + self.topSpace)

//默认数据
//默认边距
#define kDefaultPadding 20
//默认线宽
#define kDefaultLineWidth 3.0
//默认颜色
#define kDefaultColor [UIColor blackColor]
//默认折点宽度 （采用折点中心到正上方的距离 ）
#define kDefaultLineJoinPointWidth 5.0
//默认文本到折点中心的距离
#define kDefaultValueStringPadding 10.0
//默认文本位置 文本在上
#define kDefaultValueSituation LPValueSituationTop
//默认四周边距
#define kDefaultEdge UIEdgeInsetsMake(kDefaultPadding, kDefaultPadding, kDefaultPadding, kDefaultPadding)

@implementation SumLineChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认数据 如下
        self.valueArray = @[@26,@27,@29,@22,@25,@31,@26];
        //默认线宽 3.0
        self.lineWidth = kDefaultLineWidth;
        //默认线颜色 黑色
        self.lineColor = kDefaultColor;
        //默认拐点样式 圆形
        self.linejoinStyle = LPLineJoinRound;
        //默认拐点颜色 黑色
        self.lineJoinPointColor = kDefaultColor;
        //默认拐点宽度 5.0
        self.lineJoinPointWidth = kDefaultLineJoinPointWidth;
        //默认上间距 20
        self.topSpace = kDefaultPadding;
        //默认下间距 20
        self.bottomSpace = kDefaultPadding;
        //默认左间距 20
        self.leftSpace = kDefaultPadding;
        //默认右间距 20
        self.rightSpace = kDefaultPadding;
        //默认边距
        self.edge = kDefaultEdge;
        //文字默认位置 上
        self.valueSituation = kDefaultValueSituation;
        //默认文字距离拐点的垂直距离 20
        self.valueStringPadding = kDefaultValueStringPadding;
        //默认前缀 空
        self.prefixString = @"";
        //默认后缀 空
        self.suffixString = @"";
        //默认格式
        self.valueTextAttribute = @{
                                    NSForegroundColorAttributeName:[UIColor whiteColor]
                                    };
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    [self.lineColor set]; //设置折线颜色
    linePath.lineWidth = self.lineWidth;//设置线宽
    linePath.lineJoinStyle = kCGLineJoinRound;
    int max = [[self.valueArray valueForKeyPath:@"@max.intValue"] intValue];
    int min = [[self.valueArray valueForKeyPath:@"@min.intValue"] intValue];
    
    int a = max - min;
    
    CGPoint point;//定义一个起点
    NSMutableArray *pointArrM = [NSMutableArray array];
    
    for (int i = 0 ; i < self.valueArray.count; i++) {
        
        point = CGPointMake(kPointX, kPointY);
        
        if (i == 0) {
            
            UIBezierPath *linePathLeft = [UIBezierPath bezierPath];
            linePathLeft.lineWidth = self.lineWidth;
            linePathLeft.lineJoinStyle = kCGLineJoinRound;
            [linePathLeft moveToPoint:(CGPoint){0,point.y+2.f}];
            [linePathLeft addLineToPoint:point];
            [[self.lineColor colorWithAlphaComponent:.5f] set];
            [linePathLeft stroke];
            [self.lineColor set];

            [linePath moveToPoint:point];
            
        }else{
            
            [linePath addLineToPoint:point];
            
            if (i == self.valueArray.count - 2) {
                
                [linePath stroke];
                
//                UIBezierPath *linePathCenter = [UIBezierPath bezierPath];
//                linePathCenter.lineWidth = self.lineWidth;
//                linePathCenter.lineJoinStyle = kCGLineJoinRound;
//                [linePathCenter moveToPoint:point];
//                [linePathCenter addLineToPoint:(CGPoint){rect.origin.x+rect.size.width,point.y-2.f}];
//                [linePathCenter stroke];
                
                UIBezierPath *linePathRight = [UIBezierPath bezierPath];
                linePathRight.lineWidth = self.lineWidth;
                linePathRight.lineJoinStyle = kCGLineJoinRound;
                [linePathRight moveToPoint:point];
                [linePathRight addLineToPoint:(CGPoint){rect.origin.x+rect.size.width,point.y-2.f}];
                CGFloat dash[] = {linePathRight.lineWidth,linePathRight.lineWidth};
                [linePathRight setLineDash:dash count:2 phase:0];
                [linePathRight stroke];
            }
        }
        
        [pointArrM addObject:[NSValue valueWithCGPoint:point]];
        
    }
    self.pointArray = pointArrM.copy;
    
    [self.lineJoinPointColor set];
    for (int i = 0 ; i < self.valueArray.count; i++) {
        
        CGPoint point = [self.pointArray[i] CGPointValue];
        UIBezierPath *pointPath;
        if (self.linejoinStyle == LPLineJoinRound) {
            //画小圆点
            if (i == self.valueArray.count - 1) {
                
                CGPoint prePoint = [self.pointArray[i-1] CGPointValue];
                
                [[UIColor whiteColor] set];
                pointPath = [UIBezierPath bezierPathWithArcCenter:(CGPoint){point.x,prePoint.y-2.f} radius:self.lineJoinPointWidth startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                pointPath.lineWidth = 1.f;
                
                [pointPath fill];
                
                [self.lineJoinPointColor set];
                pointPath = [UIBezierPath bezierPathWithArcCenter:(CGPoint){point.x,prePoint.y-2.f} radius:self.lineJoinPointWidth startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                pointPath.lineWidth = 1.f;
                
                [pointPath stroke];
            }
            else{
                
                pointPath = [UIBezierPath bezierPathWithArcCenter:point radius:self.lineJoinPointWidth startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                
                
                [pointPath fill];
            }
        }else if(self.linejoinStyle == LPLineJoinSquare){
            
            pointPath = [UIBezierPath bezierPathWithRect:CGRectMake(point.x - self.lineJoinPointWidth, point.y - self.lineJoinPointWidth, self.lineJoinPointWidth * 2, self.lineJoinPointWidth * 2)];
            
            
            [pointPath fill];
        }else{
            pointPath = [UIBezierPath bezierPath];
            [pointPath moveToPoint:CGPointMake(point.x, point.y - self.lineJoinPointWidth)];
            [pointPath addLineToPoint:CGPointMake(point.x + self.lineJoinPointWidth * 0.5 * sqrt(3), point.y + self.lineJoinPointWidth * 0.5)];
            
            [pointPath addLineToPoint:CGPointMake(point.x - self.lineJoinPointWidth * 0.5 * sqrt(3), point.y + self.lineJoinPointWidth * 0.5)];
            [pointPath closePath];
            
            
            [pointPath fill];
        }
        
        
    }
    
    
    [self drawTextWithValueArray:self.valueArray];

}

/**
 *  画折线  折点宽1.6倍线宽/颜色/无前后缀/文本到折点10/无格式/文本在上/默认边距
 *
 *  @param valueArray         数据数组
 *  @param lineWidth          折线宽度
 *  @param tintColor          填充颜色
 *  @param linejoinStyle      折点类型
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth tintColor:(UIColor *)tintColor lineJionStyle:(LPLineJoinStyle) linejoinStyle{

    [self drawLineChartWithValueArray:valueArray lineWidth:lineWidth tintColor:tintColor lineJionStyle:linejoinStyle lineJoinPointWidth:lineWidth * 1.6];
}

/**
 *  画折线  颜色/无前后缀/文本到折点10/无格式/文本在上/默认边距
 *
 *  @param valueArray         数据数组
 *  @param lineWidth          折线宽度
 *  @param tintColor          填充颜色
 *  @param linejoinStyle      折点类型
 *  @param lineJoinPointWidth 折点宽度
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth tintColor:(UIColor *)tintColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointWidth:(CGFloat) lineJoinPointWidth {
    
    [self drawLineChartWithValueArray:valueArray lineWidth:lineWidth lineColor:tintColor lineJionStyle:linejoinStyle lineJoinPointColor:tintColor lineJoinPointWidth:lineJoinPointWidth topPadding:kDefaultPadding rightPadding:kDefaultPadding bottomPadding:kDefaultPadding leftPadding:kDefaultPadding valueSituation:LPValueSituationTop prefixString:nil suffixString:nil valueStringPadding:kDefaultValueStringPadding valueTextAttributes:@{NSForegroundColorAttributeName:tintColor}];
    
}

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
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth {

    [self drawLineChartWithValueArray:valueArray lineWidth:lineWidth lineColor:lineColor lineJionStyle:linejoinStyle lineJoinPointColor:lineJoinPointColor lineJoinPointWidth:lineJoinPointWidth edgeInsets:kDefaultEdge];
}

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
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth edgeInsets:(UIEdgeInsets)edge{
    
    [self drawLineChartWithValueArray:valueArray lineWidth:lineWidth lineColor:lineColor lineJionStyle:linejoinStyle lineJoinPointColor:lineJoinPointColor lineJoinPointWidth:lineJoinPointWidth topPadding:edge.top rightPadding:edge.right bottomPadding:edge.bottom leftPadding:edge.left];
}

/**
 *  画折线  无前后缀/文本到折点10/无格式/文本在上/边距
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
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth topPadding:(CGFloat ) topPadding rightPadding:(CGFloat) rightPadding bottomPadding:(CGFloat ) bottomPadding leftPadding:(CGFloat ) leftPadding {

    [self drawLineChartWithValueArray: valueArray lineWidth: lineWidth lineColor: lineColor lineJionStyle: linejoinStyle lineJoinPointColor: lineJoinPointColor lineJoinPointWidth: lineJoinPointWidth topPadding: topPadding rightPadding:  rightPadding bottomPadding: bottomPadding leftPadding: leftPadding valueSituation: kDefaultValueSituation];

}
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
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth topPadding:(CGFloat ) topPadding rightPadding:(CGFloat) rightPadding bottomPadding:(CGFloat ) bottomPadding leftPadding:(CGFloat ) leftPadding valueSituation:(LPValueSituation )valueSituation {
    
    [self drawLineChartWithValueArray: valueArray lineWidth: lineWidth lineColor: lineColor lineJionStyle: linejoinStyle lineJoinPointColor: lineJoinPointColor lineJoinPointWidth: lineJoinPointWidth topPadding: topPadding rightPadding:  rightPadding bottomPadding: bottomPadding leftPadding: leftPadding valueSituation: valueSituation valueTextAttributes: nil];
}

/**
 *  画折线 无前后缀 默认文本到折点距离10.0
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth topPadding:(CGFloat ) topPadding rightPadding:(CGFloat) rightPadding bottomPadding:(CGFloat ) bottomPadding leftPadding:(CGFloat ) leftPadding valueSituation:(LPValueSituation )valueSituation valueTextAttributes:(NSDictionary *)valueTextAttribute{

    [self drawLineChartWithValueArray: valueArray lineWidth: lineWidth lineColor: lineColor lineJionStyle: linejoinStyle lineJoinPointColor: lineJoinPointColor lineJoinPointWidth: lineJoinPointWidth topPadding: topPadding rightPadding:  rightPadding bottomPadding: bottomPadding leftPadding: leftPadding valueSituation: valueSituation valueStringPadding: kDefaultValueStringPadding valueTextAttributes: valueTextAttribute];
    
}
/**
 *  画折线 不带前缀 不带后缀
 */
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth topPadding:(CGFloat ) topPadding rightPadding:(CGFloat) rightPadding bottomPadding:(CGFloat ) bottomPadding leftPadding:(CGFloat ) leftPadding valueSituation:(LPValueSituation )valueSituation valueStringPadding:(CGFloat )valueStringPadding valueTextAttributes:(NSDictionary *)valueTextAttribute{
    
    [self drawLineChartWithValueArray:valueArray lineWidth:lineWidth lineColor:lineColor lineJionStyle:linejoinStyle lineJoinPointColor:lineJoinPointColor lineJoinPointWidth:lineJoinPointWidth topPadding:topPadding rightPadding:rightPadding bottomPadding:bottomPadding leftPadding:leftPadding valueSituation:valueSituation prefixString:nil suffixString:nil valueStringPadding:valueStringPadding valueTextAttributes:valueTextAttribute];
}

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
- (void)drawLineChartWithValueArray:(NSArray *)valueArray lineWidth:(CGFloat) lineWidth lineColor:(UIColor *)lineColor lineJionStyle:(LPLineJoinStyle) linejoinStyle lineJoinPointColor:(UIColor *)lineJoinPointColor lineJoinPointWidth:(CGFloat) lineJoinPointWidth topPadding:(CGFloat ) topPadding rightPadding:(CGFloat) rightPadding bottomPadding:(CGFloat ) bottomPadding leftPadding:(CGFloat ) leftPadding valueSituation:(LPValueSituation )valueSituation prefixString:(NSString *)prefixString suffixString:(NSString *)suffixString valueStringPadding:(CGFloat )valueStringPadding valueTextAttributes:(NSDictionary *)valueTextAttribute{
//    赋值
    if (valueArray.count > 0) {
        self.valueArray = valueArray;
    }
    
    if (lineWidth) {
        self.lineWidth = lineWidth;
    }
    
    if (lineColor) {
        self.lineColor = lineColor;
    }
    
    if (linejoinStyle) {
        self.linejoinStyle = linejoinStyle;
    }
    
    if (lineJoinPointColor) {
        self.lineJoinPointColor = lineJoinPointColor;
    }
    
    if (lineJoinPointWidth) {
        self.lineJoinPointWidth = lineJoinPointWidth;
    }
    
    if (topPadding) {
        self.topSpace = topPadding;
    }
    
    if (leftPadding) {
        self.leftSpace = leftPadding;
    }
    
    if (bottomPadding) {
        self.bottomSpace = bottomPadding;
    }
    
    if (rightPadding) {
        self.rightSpace = rightPadding;
    }
    
    if (valueSituation) {
        self.valueSituation = valueSituation;
    }
    
    if (prefixString) {
        self.prefixString = prefixString;
    }
    
    if (suffixString) {
        self.suffixString = suffixString;
    }
    
    if (valueStringPadding) {
        self.valueStringPadding = valueStringPadding;
    }
    
    if (valueTextAttribute){
        
        self.valueTextAttribute = valueTextAttribute;
        
    }
    
    [self setNeedsDisplay];
    
}

/**
 *  画文本
 *
 *  @param valueArray 数据数组
 *  @param attribute  文本格式
 */
- (void)drawTextWithValueArray:(NSArray *)valueArray{

    if (self.valueSituation != LPValueSituationNone) {
        
        
        for (int i = 0 ; i < self.valueArray.count; i++) {
            
            NSMutableString *str = [NSMutableString string];
            //拼接前后缀
            [str appendString:self.prefixString];
            [str appendString:[NSString stringWithFormat:@"%@",self.valueArray[i]]];
            [str appendString:self.suffixString];
            
            //最终文本
            NSString *string = str.copy;
            //计算文本size
            CGSize stringSize =[string sizeWithAttributes:self.valueTextAttribute];
            //取折点
            CGPoint point = [self.pointArray[i] CGPointValue];
            
            //画文字
            if (self.valueSituation == LPValueSituationTop) {//文字在上
                //描述
                {
                    //最终文本
                    NSString *desc = self.descArray[i];
                    //计算文本size
                    CGSize descSize =[desc sizeWithAttributes:self.valueTextAttribute];
                    //取折点
                    CGPoint descPoint = [self.pointArray[i] CGPointValue];
                    
                    CGPoint descPointBottom = CGPointMake(descPoint.x - descSize.width / 2, self.frame.size.height-descSize.height-3.f);
                    
                    [desc drawAtPoint:descPointBottom withAttributes:self.valueTextAttribute];
                }
                //排除最后一个
                if (i == self.valueArray.count - 1) {continue;}
                
                
                CGPoint textPointTop = CGPointMake(point.x - stringSize.width / 2, point.y - stringSize.height - self.valueStringPadding);
                
                [string drawAtPoint:textPointTop withAttributes:self.valueTextAttribute];
                
                
                
            }else{//文字在下
                
                CGPoint textPointBottom = CGPointMake(point.x - stringSize.width / 2, point.y + self.valueStringPadding);
                
                [string drawAtPoint:textPointBottom withAttributes:self.valueTextAttribute];
            }
        }
    }
}

@end


















