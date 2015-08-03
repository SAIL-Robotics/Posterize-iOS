//
//  PrintFinalPosterViewController.h
//  ImageCropView
//
//  Created by Aishwarya Krishnan on 7/31/15.
//
//

#import <UIKit/UIKit.h>

@interface PrintFinalPosterViewController : UIViewController {
    
}


@property (assign, nonatomic) double totalA4Width;
@property (assign, nonatomic) double totalA4Height;


@property (nonatomic,strong) UIImage * image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *printposterView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@property (assign, nonatomic) NSString*  orientation;
@property (assign,nonatomic) int totalPapers;

@property (weak, nonatomic) IBOutlet UILabel *pagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *orientationLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileLabel;

@property (copy, nonatomic) NSString * fileName;


- (IBAction)uploadServerAction:(UIButton *)sender;
- (IBAction)uploadFacebookAction:(UIButton *)sender;

@end
