//
//  PosterController.h
//  ImageCropView
//
//  Created by Arjun Santhanam on 7/30/15.
//
//
#import <UIKit/UIKit.h>
@interface PosterController : UIViewController{
}
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) UIImage * tempImage;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
//@property (assign, nonatomic) NSInteger * totalA4Width;
- (IBAction)optimizeButtonClick:(id)sender;
//@property (assign, nonatomic) NSInteger * totalA4Height;

@property (assign, nonatomic) double  newWidth;
@property (assign, nonatomic) double  newHeight;

@property (assign, nonatomic) double  a4Width;
@property (assign, nonatomic) double  a4Height;

@property (assign, nonatomic) double  totalA4Width;
@property (assign, nonatomic) double  totalA4Height;

@property (assign, nonatomic) double  finalWidth;
@property (assign, nonatomic) double  finalHeight;

@property (assign, nonatomic) NSString*  orientation;
@property (assign,nonatomic) int totalPapers;

@end