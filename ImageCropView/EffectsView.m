//
//  EffectsView.m
//  ImageCropView
//
//  Created by Preethi Baskar Baskaran on 7/29/15.
//
//

#import "EffectsView.h"

@implementation EffectsViewController

@synthesize delegate;

-(id)initWithImage:(UIImage*) image{
    NSLog(@"Effects!");
    self =  [super init];
    if (self){
        self.image = [image fixOrientation];
        croppedView.image = self.image;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
}
- (void)viewDidLoad
{
    NSLog(@"viewDid load");
    [super viewDidLoad];
//    if (self){
//        UIView *contentView = [[UIView alloc] init];
//        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        contentView.backgroundColor = [UIColor whiteColor];
//        
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
//                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                 target:self
//                                                 action:@selector(cancel:)];
//        
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
//                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                                  target:self
//                                                  action:@selector(done:)];
//        CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
//        CGRect view = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - [[self navigationController] navigationBar].bounds.size.height - statusBarSize.height);
//        self.cr  = [[ImageCropView alloc] initWithFrame:view blurOn:self.blurredBackground];
//        self.view = contentView;
//        [contentView addSubview:cropView];
//        [cropView setImage:self.image];
//    }
}


@end

@implementation UIImage (fixOrientation)

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
