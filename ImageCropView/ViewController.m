//
//  ViewController.m
//  ImageCropView
//
//  Created by Aishwarya Krishnan
//
//

#import "ViewController.h"
#import "UserInputViewController.h"
#import "UIImage+FiltrrCompositions.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize imageCropView;
@synthesize delegate;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [_crop setHidden:YES];
    [_measure setHidden:YES];
    [_camera setHidden:NO];
    [_posterize setHidden:NO];
    [_gallery setHidden:NO];
    [_insta setHidden:NO];
    
    imageView.image = nil;
    //Setting up the loading screen
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];

    
    UIImage *imagePosterize = [UIImage imageNamed:@"posterize.png"];
    [_PosterizeImageView setImage:imagePosterize];
    
    //UIImage *btnImage = [UIImage imageNamed:@"camera_fade.png"];
    //[_camera setImage:btnImage forState:UIControlStateNormal];
    self.navigationItem.title = @"";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *imagebgTop = [UIImage imageNamed:@"background.jpg"];
    [navBar setBackgroundImage:imagebgTop forBarMetrics:UIBarMetricsDefault];
    //Setting image for nav bar
    
    NSLog(@"The newly loadde string is %@ %@",_widthString,_heightString);
}


- ( void )didReceiveMemoryWarning
{
    //image = nil;
    
    [ super didReceiveMemoryWarning ];
}

- (IBAction)takeBarButtonClick:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)openBarButtonClick:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}



- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.navigationItem.title = @"Image Preview";
    [_PosterizeImageView setImage:nil];
    
    imageView.image = image;
    [_camera setHidden:YES];
    [_posterize setHidden:YES];
    [_gallery setHidden:YES];
    [_insta setHidden:YES];
    [_crop setHidden:NO];
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
//    self.navigationItem.leftBarButtonItem = backButton;
    
    
    
    UIButton *leftbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(10.0, 2.0, 45.0, 40.0)];
    [leftbutton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton setImage:[UIImage imageNamed:@"backward_arrow.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *leftbarbutton = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    
    self.navigationItem.leftBarButtonItem = leftbarbutton;

    
    
    /*self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self
                                             action:@selector(cancel:)];*/
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
}
- (void)backButtonPressed
{
    
    NSLog(@"Back button pressed called.");
    [_camera setHidden:NO];
    [_posterize setHidden:NO];
    [_gallery setHidden:NO];
    [_insta setHidden:NO];
    
    imageView.image = nil;

}
- (IBAction)cancel:(id)sender
{
    
    NSLog(@"Cancel being called.");
    //[self.navigationController popViewControllerAnimated:YES];
    [self.view setNeedsDisplay];
    UIStoryboard* _initalStoryboard;
    _initalStoryboard = self.storyboard;
    for (UIView* view in self.view.subviews)
    {
        
        [view removeFromSuperview];
    }
    
    UIViewController* initialScene = [_initalStoryboard instantiateInitialViewController];
    self.view.window.rootViewController = initialScene;
    

}

- (IBAction)cropBarButtonClick:(id)sender {
    
    BOOL hasMeasurementDone = [self isMeasurement];
    if(!hasMeasurementDone) {
        if(image != nil){
            NSLog(@"Crop view controller called!");
            ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:image];
            controller.delegate = self;
            controller.blurredBackground = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    } else {
        //call the set measurements controller
        
        //call the segue
        [self performSegueWithIdentifier: @"UserInputScreen" sender: self];
        
    }
    
    
}

- (IBAction)effectOne:(id)sender {
    imageView.image = [image e1];
}

- (IBAction)effectTwo:(id)sender {
    imageView.image = [image e2];
}

- (IBAction)effectThree:(id)sender {
    imageView.image = [image e3];
}

- (IBAction)effectFour:(id)sender {
    imageView.image = [image e4];
}

- (IBAction)effectFive:(id)sender {
    imageView.image = [image e5];
}

-(void)ImageCropViewController:(UIViewController *)controller ImageCropViewControllerDidCancel:(UIImage *)croppedImage {
    NSLog(@"cancel.");
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    
    NSLog(@"Back!");
    self.navigationItem.title = @"Add effects";
    [_PosterizeImageView setImage:nil];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
   image = croppedImage;
   imageView.image = croppedImage;
    CGFloat compression = 0.9f;
    //CGFloat maxCompression = 0.1f;
    //int maxFileSize = 250*1024;
    UIImage *thumbnail = image;
    
    //NSData *imageData = UIImageJPEGRepresentation(thumbnail, compression);
    
   
        compression -= 4;
        NSData *imageData = UIImageJPEGRepresentation(thumbnail, compression);
    
    thumbnail = [UIImage imageWithData:imageData];
//    EffectsViewController *con = [[EffectsViewController alloc] initWithImage:image];
//    con.delegate = self;
//    [self.navigationController pushViewController:con animated:YES];

    
    //[self cropImage :croppedImage];
    
   [[self navigationController] popViewControllerAnimated:YES];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    int x = 0;
    for (int i = 1; i < 8; i++) {
        NSLog(@"Loop %d",i);

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 100, 50)];
        NSString* aString = [NSString stringWithFormat:@"e%d", i];
        [button setImage:[thumbnail valueForKey:aString] forState:UIControlStateNormal];
        //[button setTitle:aString forState:UIControlStateNormal];
        [button addTarget:self
                   action:NSSelectorFromString(aString)
                    forControlEvents:UIControlEventTouchUpInside];
      // [button setWidth:20];
        
        [scrollView addSubview:button];
        
       x += button.frame.size.width +10;
    }
    
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor grayColor];
    
    
    [self setIsMeasurement:YES];
    
    [_measure setHidden:YES];
    [self.view addSubview:scrollView];
}

- (void)e1{
    imageView.image = [image e1];
}
- (void)e2{
    imageView.image = [image e2];
}
- (void)e3{
    imageView.image = [image e3];
}
- (void)e4{
    imageView.image = [image e4];
}
- (void)e5{
    imageView.image = [image e5];
}
- (void)e6{
    imageView.image = [image e6];
}
- (void)e7{
    imageView.image = [image e7];
}


- (IBAction)saveBarButtonClick:(id)sender {
    //TODO - uncomment this
    //if (image != nil){
    //    UIImageWriteToSavedPhotosAlbum(image, self ,  @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
    //}
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@" From view controller The segue identifer %@",segue.identifier);
    
    if([segue.identifier isEqualToString:@"UserInputScreen"])
    {
        NSLog(@"UserInputScreen");
        
        UserInputViewController *controller = (UserInputViewController *)segue.destinationViewController;
        controller.image = imageView.image;
        
        
        
        /*UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Return", returnbuttontitle) style:     UIBarButtonItemStyleBordered target:nil action:nil];
        
        self.navigationItem.backBarButtonItem = backButton;*/
        

        
        //self.navigationItem.backBarButtonItem.image = [UIImage imageNamed:@"backward_arrow.png"];
        
                
        //controller.stringForVC2 = @"some string";
        // here you have passed the value //
        
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
     NSLog(@" From view controller should perform segue");
    
    return YES;
    
}


@end
