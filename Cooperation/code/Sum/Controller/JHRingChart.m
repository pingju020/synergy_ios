//
//  JHRingChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/7/5.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHRingChart.h"
#define k_COLOR_STOCK @[[UIColor colorWithRed:1.000 green:0.783 blue:0.371 alpha:1.000], [UIColor colorWithRed:1.000 green:0.562 blue:0.968 alpha:1.000],[UIColor colorWithRed:0.313 green:1.000 blue:0.983 alpha:1.000],[UIColor colorWithRed:0.560 green:1.000 blue:0.276 alpha:1.000],[UIColor colorWithRed:0.239 green:0.651 blue:0.170 alpha:1.000]]

@interface JHRingChart ()

//环图间隔 单位为π
@property (nonatomic,assign)CGFloat itemsSpace;

//数值和
@property (nonatomic,assign) CGFloat totolCount;

@property (nonatomic,assign) CGFloat redius;

@property (assign , nonatomic) CGFloat  chartArcLength ;

@property (assign , nonatomic) NSInteger  allValueCount ;

@end


@implementation JHRingChart



-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.chartOrigin = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)/2);
        _redius = (CGRectGetHeight(self.frame) -60*k_Width_Scale)/4;
        _ringWidth = 40;
        _showDescripotion = YES;
        _chartArcLength = 8;
    }
    return self;
}

- (void)countAllValue{
    _allValueCount = 0;
    for (NSString *obj in _valueDataArr) {
        
        _allValueCount += obj.integerValue;
        
    }
}

-(void)setValueDataArr:(NSArray *)valueDataArr{
    
    
    _valueDataArr = valueDataArr;
    
    [self configBaseData];
    
}

- (void)configBaseData{
    
    _totolCount = 0;
    _itemsSpace =  (M_PI * 2.0 * 10 / 360)/_valueDataArr.count ;
    for (id obj in _valueDataArr) {
        
        _totolCount += [obj floatValue];
        
    }

}



//开始动画
- (void)showAnimation{
    
    /*        动画开始前，应当移除之前的layer         */
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    
    CGFloat lastBegin = -M_PI/2;
    
    CGFloat totloL = 0;
    NSInteger  i = 0;
    for (id obj in _valueDataArr) {
        
        CAShapeLayer *layer = [CAShapeLayer layer] ;

        UIBezierPath *path = [UIBezierPath bezierPath];
        
        layer.fillColor = [UIColor clearColor].CGColor;
        
        if (i<_fillColorArray.count) {
            layer.strokeColor =[_fillColorArray[i] CGColor];
        }else{
             layer.strokeColor =[k_COLOR_STOCK[i%k_COLOR_STOCK.count] CGColor];
        }
        CGFloat cuttentpace = [obj floatValue] / _totolCount * (M_PI * 2 - _itemsSpace * _valueDataArr.count);
        totloL += [obj floatValue] / _totolCount;

        [path addArcWithCenter:self.chartOrigin radius:_redius startAngle:lastBegin  endAngle:lastBegin  + cuttentpace clockwise:YES];
        
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        layer.lineWidth = _ringWidth;
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basic.fromValue = @(0);
        basic.toValue = @(1);
        basic.duration = 0.5;
        basic.fillMode = kCAFillModeForwards;
        
        [layer addAnimation:basic forKey:@"basic"];
        lastBegin += (cuttentpace+_itemsSpace);
        i++;

    }

}


-(void)drawRect:(CGRect)rect{
    
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    CGFloat lastBegin = 0;
    CGFloat longLen = _redius +30*k_Width_Scale;
    for (NSInteger i = 0; i<_valueDataArr.count; i++) {
        id obj = _valueDataArr[i];
        CGFloat currentSpace = [obj floatValue] / _totolCount * (M_PI * 2 - _itemsSpace * _valueDataArr.count);;
        NSLog(@"%f",currentSpace);
        CGFloat midSpace = lastBegin + currentSpace / 2;
        
        CGPoint begin = CGPointMake(self.chartOrigin.x + sin(midSpace) * _redius, self.chartOrigin.y - cos(midSpace)*_redius);
        CGPoint endx = CGPointMake(self.chartOrigin.x + sin(midSpace) * longLen, self.chartOrigin.y - cos(midSpace)*longLen);
        
        NSLog(@"%@%@",NSStringFromCGPoint(begin),NSStringFromCGPoint(endx));
        lastBegin += _itemsSpace + currentSpace;
        
        UIColor *color;
        
        if (_fillColorArray.count<_valueDataArr.count) {
            color = k_COLOR_STOCK[i%k_COLOR_STOCK.count];
        }else{
            color = _fillColorArray[i];
        }
        
        [self drawLineWithContext:contex andStarPoint:begin andEndPoint:endx andIsDottedLine:NO andColor:color];
        
        
        CGPoint secondP = CGPointZero;
        
        CGSize size = [[NSString stringWithFormat:@"%.02f%c",[obj floatValue] / _totolCount * 100,'%'] boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10*k_Width_Scale]} context:nil].size;
        
        if (midSpace<M_PI) {
            secondP =CGPointMake(endx.x + 20*k_Width_Scale, endx.y);
          [self drawText:[NSString stringWithFormat:@"%@个",obj] andContext:contex atPoint:CGPointMake(secondP.x + 3, secondP.y - size.height / 2) WithColor:color andFontSize:10*k_Width_Scale];

        }else{
             secondP =CGPointMake(endx.x - 20*k_Width_Scale, endx.y);
            [self drawText:[NSString stringWithFormat:@"%@个",obj] andContext:contex atPoint:CGPointMake(secondP.x - size.width - 3, secondP.y - size.height/2) WithColor:color andFontSize:10*k_Width_Scale];
        }
          [self drawLineWithContext:contex andStarPoint:endx andEndPoint:secondP andIsDottedLine:NO andColor:color];
        [self drawPointWithRedius:3*k_Width_Scale andColor:color andPoint:secondP andContext:contex];
       
        
    }
    
    if (_descArr.count==_valueDataArr.count&&_descArr.count>0) {
        
        
        [self countAllValue];
        
        CGFloat wid = self.frame.size.width-20;
        self.chartOrigin = P_M(10 + wid / 2, 15 + wid / 2);
        if (_descArr.count>0) {
            
            NSInteger i = _descArr.count/2 + _descArr.count%2;
            
            wid = self.frame.size.height - 10 - i*25;
            
        }
        
        _chartArcLength = wid/2;
        
        NSArray *colors = nil;
        
        if (_fillColorArray.count==_valueDataArr.count) {
            colors = _fillColorArray;
        }else{
            colors = k_COLOR_STOCK;
        }
        
        if (!self.showDescripotion) {
            return;
        }
        
        for (NSInteger i = 0; i<_descArr.count; i++) {
            
            CGFloat seg = self.frame.size.width/5;
            
            [self drawQuartWithColor:colors[i%colors.count] andBeginPoint:(CGPoint){seg*i+10,self.frame.size.height-20} andContext:contex];
            [self drawText:_descArr[i] andContext:contex atPoint:(CGPoint){seg*i+25,self.frame.size.height-20} WithColor:[UIColor blackColor] andTextFontSize:8];
            
//            [self drawQuartWithColor:colors[i%colors.count] andBeginPoint:P_M(15+self.frame.size.width/2*(i%2), 20*(i/2  )+25+_chartArcLength*2) andContext:contex];
//            CGFloat present = [_valueDataArr[i] floatValue]/_allValueCount*100;
//            [self drawText:[NSString stringWithFormat:@"%@",_descArr[i]] andContext:contex atPoint:P_M(30+self.frame.size.width/2*(i%2), 20*(i/2  )+25+_chartArcLength*2) WithColor:[UIColor blackColor] andTextFontSize:8];
        }
        
        
    }
    
    
}

- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )rect WithColor:(UIColor *)color andTextFontSize:(CGFloat )fontSize{
    
    
    [[NSString stringWithFormat:@"%@",text] drawAtPoint:rect withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"CourierNewPSMT" size:fontSize],NSForegroundColorAttributeName:color}];
    
    
    [color setFill];
    CGContextDrawPath(context, kCGPathFill);
    
}


@end
