@interface KaarePlatform : NSObject

-(instancetype)initWithKaare:(Kaare*)kaare;

@end

@interface Kaare (KaarePlatform)

-(KaarePlatform*)platform;

@end

