//
//  ViewController.h
//  ImageCropView
//
//  Created by Aishwarya Krishnan
//
//

#import <UIKit/UIKit.h>
#import "ImageCropView.h"
#import "EffectsView.h"

#pragma mark ViewController interface
@protocol ViewControllerDelegate <NSObject>


- (void)ViewControllerDidCancel:(UIViewController *)controller;

@end
@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,ImageCropViewControllerDelegate, EffectsViewControllerDelegate> {
    ImageCropView* imageCropView;
    UIImage* image;
    IBOutlet UIImageView *imageView;
}
- (IBAction)takeBarButtonClick:(id)sender;
- (IBAction)openBarButtonClick:(id)sender;
- (IBAction)cropBarButtonClick:(id)sender;
- (IBAction)effectOne:(id)sender;

- (IBAction)effectTwo:(id)sender;
- (IBAction)effectThree:(id)sender;
- (IBAction)effectFour:(id)sender;
- (IBAction)effectFive:(id)sender;

@property (nonatomic, weak) id<ViewControllerDelegate> delegate;
- (IBAction)saveBarButtonClick:(id)sender;
@property (nonatomic, strong) IBOutlet ImageCropView* imageCropView;
@property (weak, nonatomic) IBOutlet UIButton *camera;
@property (weak, nonatomic) IBOutlet UIButton *gallery;
@property (weak, nonatomic) IBOutlet UIButton *insta;
@property (weak, nonatomic) IBOutlet UILabel *posterize;
@property (strong, nonatomic) IBOutlet UIButton *crop;

@property (weak, nonatomic) IBOutlet UIButton *measure;


@property (copy, nonatomic) NSString * widthString;
@property (copy, nonatomic) NSString * heightString;
@property (nonatomic, strong) IBOutlet UIImageView* passedImage;

@end
