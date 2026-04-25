//
//  FHXFloatingButton.m
//  Frame
//
//  Created by imac on 2026/4/25.
//

#import "FHXFloatingButton.h"

@interface FHXFloatingButton()
{
    CGFloat minTop;
    CGFloat maxTop;
    CGPoint lastPoint;
}
@property (nonatomic, assign) BOOL isLeft;

@end

@implementation FHXFloatingButton

- (instancetype)initWithImage:(NSString *)name top:(CGFloat)top bottom:(CGFloat)bottom frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        minTop = top;
        maxTop = UIScreen.mainScreen.bounds.size.height - bottom;
        
        // 默认动画时间
        _moveAnimationDuration = 0.25;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:name];
        imageView.userInteractionEnabled = NO;
        [self addSubview:imageView];
    }
    return self;
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    lastPoint = [[touches anyObject] locationInView:self.superview];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint current = [[touches anyObject] locationInView:self.superview];
    
    CGFloat dx = current.x - lastPoint.x;
    CGFloat dy = current.y - lastPoint.y;
    
    self.center = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    lastPoint = current;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (fabs(point.x - self.bounds.size.width/2) < 5 &&
        fabs(point.y - self.bounds.size.height/2) < 5) {
        
        if ([self.delegate respondsToSelector:@selector(fhxFloatingButton:btnClick:)]) {
            [self.delegate fhxFloatingButton:self btnClick:@""];
        }
    }
    
    [self moveToEdge];
}

#pragma mark - 吸边

- (void)moveToEdge {
    
    CGRect frame = self.frame;
    CGFloat screenW = UIScreen.mainScreen.bounds.size.width;
    
    if (frame.origin.x < screenW / 2) {
        frame.origin.x = 0;
        self.isLeft = YES;
    } else {
        frame.origin.x = screenW - frame.size.width;
        self.isLeft = NO;
    }
    
    if (frame.origin.y < minTop) {
        frame.origin.y = minTop;
    } else if (frame.origin.y > maxTop - frame.size.height) {
        frame.origin.y = maxTop - frame.size.height;
    }
    
    [UIView animateWithDuration:self.moveAnimationDuration animations:^{
        self.frame = frame;
    }];
    
    if ([self.delegate respondsToSelector:@selector(fhxFloatingButton:btnFrame:)]) {
        [self.delegate fhxFloatingButton:self btnFrame:frame];
    }
}

#pragma mark - 隐藏动画（滑出屏幕）

- (void)hideToEdgeWithDuration:(CGFloat)duration {
    
    [self moveToEdge];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGRect frame = self.frame;
        CGFloat width = frame.size.width;
        
        if (self.isLeft) {
            frame.origin.x = -width;
        } else {
            frame.origin.x = UIScreen.mainScreen.bounds.size.width;
        }
        
        [UIView animateWithDuration:duration animations:^{
            self.frame = frame;
        }];
    });
}

#pragma mark - 显示动画（滑入）

- (void)showFromEdgeWithDuration:(CGFloat)duration {
    
    CGRect frame = self.frame;
    CGFloat width = frame.size.width;
    
    if (self.isLeft) {
        frame.origin.x = -width;
    } else {
        frame.origin.x = UIScreen.mainScreen.bounds.size.width;
    }
    
    self.frame = frame;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGRect target = self.frame;
        
        if (self.isLeft) {
            target.origin.x = 0;
        } else {
            target.origin.x = UIScreen.mainScreen.bounds.size.width - width;
        }
        
        [UIView animateWithDuration:duration animations:^{
            self.frame = target;
        }];
    });
}


@end
