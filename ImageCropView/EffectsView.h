//
//  EffectsView.h
//  ImageCropView
//
//  Created by Preethi Baskar Baskaran on 7/29/15.
//
//
//
//  Created by Preethi Baskar
//

#import <UIKit/UIKit.h>


#pragma mark ControlPointView interface

#pragma mark EffectsViewController interface
@protocol EffectsViewControllerDelegate <NSObject>

//- (void)ImageCropViewController:(UIViewController* )controller didFinishCroppingImage:(UIImage *)croppedImage;
//- (void)ImageCropViewControllerDidCancel:(UIViewController *)controller;

@end

@interface EffectsViewController : UIViewController  <UIActionSheetDelegate > {
    UIImageView * croppedView;
   // UIActionSheet * actionSheet;
}
@property (nonatomic, weak) id<EffectsViewControllerDelegate> delegate;
//@property (nonatomic) BOOL blurredBackground;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) UIImage* cropView;
//
- (id)initWithImage:(UIImage*)image;
//- (IBAction)cancel:(id)sender;
//- (IBAction)done:(id)sender;

@end

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;

@end


