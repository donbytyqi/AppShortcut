#import <objc/runtime.h>

@interface UIBlurEffect (Protected)
@property (nonatomic, readonly) id effectSettings;
@end

@interface AppShortcutBlur : UIBlurEffect
@end

@implementation AppShortcutBlur

+ (instancetype)effectWithStyle:(UIBlurEffectStyle)style
{
    id result = [super effectWithStyle:style];
    object_setClass(result, self);

    return result;
}

+ (void)_addBlurToEffectNode:(id)arg1 blurRadius:(double)arg2 scale:(double)arg3 options:(id)arg4 {

}

- (id)effectSettings
{
	// change blur intensity.
    id settings = [super effectSettings];
    [settings setValue:@0 forKey:@"blurRadius"];
    return settings;
}

- (id)copyWithZone:(NSZone*)zone
{
    id result = [super copyWithZone:zone];
    object_setClass(result, [self class]);
    return result;
}

@end
