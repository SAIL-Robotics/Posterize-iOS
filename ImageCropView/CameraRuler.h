//
//  CameraRuler.h
//  ImageCropView
//
//  Created by Preethi Baskar Baskaran on 8/1/15.
//
//
#import <UIKit/UIKit.h>

@interface CameraRuler : UIViewController{
}

@property (strong, nonatomic) IBOutlet UIImageView *rulerImageView;
@property (nonatomic,strong) UIImage * rulerImage;
@property (nonatomic,strong) UIImage * tempImage;
@property (nonatomic,strong) UIImage * originalImage;
@property (assign,nonatomic) int touchCount;
- (IBAction)resetButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)calculate:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *knownValue;
@property (weak, nonatomic) IBOutlet UIButton *calculate;

- (IBAction)retakePhoto:(id)sender;



@end
