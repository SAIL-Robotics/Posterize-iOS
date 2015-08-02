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
@property (assign,nonatomic) int touchCount;
- (IBAction)resetButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;

@end
