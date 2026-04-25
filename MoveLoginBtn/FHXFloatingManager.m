//
//  FHXFloatingManager.m
//  Frame
//
//  Created by imac on 2026/4/25.
//

#import "FHXFloatingManager.h"
#import "FHXFloatingButton.h"

@interface FHXFloatingManager ()<FHXFloatingButtonDelegate>

@property (nonatomic, strong) FHXFloatingButton *floatBtn;
@property (nonatomic, assign, readwrite) BOOL isShowing;

@end

@implementation FHXFloatingManager

+ (instancetype)shared {
    static FHXFloatingManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FHXFloatingManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _size = CGSizeMake(60, 60);
        _edgeInset = UIEdgeInsetsMake(100, 0, 100, 0);
        _autoHideWhenScroll = NO;
        // 默认动画时间
        _dragAnimationDuration = 0.5;
        // 拖拽吸边动画时间（透传给按钮）
        _moveAnimationDuration = 0.25;
    }
    return self;
}

- (void)setMoveAnimationDuration:(CGFloat)moveAnimationDuration {
    _moveAnimationDuration = moveAnimationDuration;
    
    self.floatBtn.moveAnimationDuration = moveAnimationDuration;
}

#pragma mark - Public

- (void)show {
    if (self.isShowing) return;
 
    UIWindow *window = [self getKeyWindow];
//    UIWindow *window = self.containerWindow ?: [self getKeyWindow];
//    if (!window) return;
    
    if (!window) {
        // ❗ 关键：延迟重试
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self show];
        });
        return;
    }
    
    if (!self.floatBtn) {
        [self setupButton];
    }
    
    [window addSubview:self.floatBtn];
    
    if (self.autoHideWhenScroll) {
        [self addScrollObserver];
    }
    
    self.isShowing = YES;
}

- (void)dismiss {
    if (!self.isShowing) return;
    
    [self.floatBtn removeFromSuperview];
    self.floatBtn = nil;
    
    [self removeScrollObserver];
    
    self.isShowing = NO;
}

#pragma mark - Setup

- (void)setupButton {
    
    CGFloat screenW = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenH = UIScreen.mainScreen.bounds.size.height;
    
    CGFloat x = screenW - self.size.width;
    CGFloat y = screenH - self.edgeInset.bottom - self.size.height;
    
    CGRect frame = CGRectMake(x, y, self.size.width, self.size.height);
    
    self.floatBtn = [[FHXFloatingButton alloc] initWithImage:self.imageName ?: @"" top:self.edgeInset.top bottom:self.edgeInset.bottom frame:frame];
    
    self.floatBtn.delegate = self;
    
    self.floatBtn.moveAnimationDuration = self.moveAnimationDuration;
}

#pragma mark - Delegate
// 点击悬浮按键触发
- (void)fhxFloatingButton:(nonnull FHXFloatingButton *)view btnClick:(nonnull NSString *)name {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

//“悬浮按钮当前的位置变化”实时回调给外部
- (void)fhxFloatingButton:(nonnull FHXFloatingButton *)view btnFrame:(CGRect)rect {
    
}

#pragma mark - Scroll监听

- (void)addScrollObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollBegin) name:@"FHXScrollBegin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollEnd) name:@"FHXScrollEnd" object:nil];
}

- (void)removeScrollObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Scroll监听

- (void)scrollBegin {
    [self.floatBtn hideToEdgeWithDuration:self.dragAnimationDuration];
}

- (void)scrollEnd {
    [self.floatBtn showFromEdgeWithDuration:self.dragAnimationDuration];
}

#pragma mark - Utils

- (UIWindow *)getKeyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    }
    return UIApplication.sharedApplication.keyWindow;
}

@end
