//
//  UserInputViewController.h
//  ImageCropView
//
//  Created by Aishwarya Krishnan on 7/29/15.
//
//

#import <UIKit/UIKit.h>

@interface UserInputViewController : UIViewController {
    
}

@property (weak, nonatomic) IBOutlet UITextField *widthText;
@property (weak, nonatomic) IBOutlet UITextField *heightText;
@property (assign, nonatomic) NSInteger * totalA4Width;
@property (assign, nonatomic) NSInteger * totalA4Height;
@property (nonatomic,strong) UIImage * image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
