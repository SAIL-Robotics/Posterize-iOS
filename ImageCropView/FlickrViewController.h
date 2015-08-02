//
//  FlickrViewController.h
//  ImageCropView
//
//  Created by Arjun Santhanam on 8/2/15.
//
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"



@interface FlickrViewController : UIViewController <OFFlickrAPIRequestDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    OFFlickrAPIRequest *flickrRequest;
    
    UIImagePickerController *imagePicker;
    
    UILabel *authorizeDescriptionLabel;
    UILabel *snapPictureDescriptionLabel;
    UIButton *authorizeButton;
    UIButton *snapPictureButton;
}
- (IBAction)authorizeAction;
//- (IBAction)snapPictureAction;
- (IBAction)searchButton:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *authorizeDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *snapPictureDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIButton *snapPictureButton;
@property (nonatomic, retain) IBOutlet UIButton *authorizeButton;

@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@end


