//
//  FlickrViewController.h
//  ImageCropView
//
//  Created by Arjun Santhanam on 8/2/15.
//
//

#import <UIKit/UIKit.h>




@interface FlickrViewController : UICollectionViewController 
{
    NSMutableArray *searchImages;
    NSMutableArray *imageArray;

}


- (IBAction)searchButton:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *authorizeDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *snapPictureDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIButton *snapPictureButton;
@property (nonatomic, retain) IBOutlet UIButton *authorizeButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@end


