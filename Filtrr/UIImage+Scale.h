

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

-(UIImage*)scaleToSize:(CGSize)size;
-(UIImage *)crop:(CGRect) cropRect;

@end
