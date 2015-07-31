//
//  UserInputViewController.m
//  ImageCropView
//
//  Created by Aishwarya Krishnan on 7/29/15.
//
//

#import "UserInputViewController.h"
#import "ViewController.h"
#import "PosterController.h"

@interface UserInputViewController ()

@end

@implementation UserInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_imageView setImage:_image];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard {
    [_widthText resignFirstResponder];
    [_heightText resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@" The segue identifer %@",segue.identifier);
    
    if([segue.identifier isEqualToString:@"posterSegue"])
    {
        NSLog(@"inside");
       
        
        PosterController *controller = (PosterController *)segue.destinationViewController;
       // controller.widthString = widthText;
        //controller.heightString = heightText;
        controller.image = _imageView.image;
        controller.totalA4Width = _totalA4Width;
        controller.totalA4Height = _totalA4Height;
        controller.newWidth = [_widthText.text doubleValue];
        controller.newHeight = [_heightText.text doubleValue];
            
        //controller.stringForVC2 = @"some string";
        // here you have passed the value //
        
    }
    
    }

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    NSString *widthText = _widthText.text;
    NSString *heightText = _heightText.text;
    
    if(widthText.length == 0){
        //alert saying its not there
        NSLog(@"Width missing");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                                        message:@"Please fill in width"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
        
    }
    else if(heightText.length == 0) {
        //alert saying its not there
        NSLog(@"Height missing");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                                        message:@"Please fill in height"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    else {
        
        double widthDouble = [widthText doubleValue];
        NSString *message1 =[[NSString alloc] initWithFormat:@"%f",widthDouble];
        
        double heightDouble = [heightText doubleValue];
        NSString *message2 =[[NSString alloc] initWithFormat:@"%f",heightDouble];
        
        NSLog(@"the two are @%f @%f",widthDouble,heightDouble);
        [self cropImage:_image :widthDouble :heightDouble];
    }
    
   
    return YES;
    
}

- (void) cropImage:(UIImage *)croppedImage : (double) newWidth :(double) newHeight{
    
    
    NSLog(@"cutting image");
    
    CGSize size = [croppedImage size];
    
    CGFloat pageOffset = 0;
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *pdfFileName = [documentDirectory stringByAppendingPathComponent:@"mypdf.pdf"];
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    int a4Height = 11;
    double a4Width = 8.27;
    
    double oldWidth = size.width,oldHeight = size.height;
    //double newWidth=25,newHeight=33; //The size of the poster
    
    
    if(size.height > size.width) {
        newWidth = size.height;
        newHeight = size.width;
    }
    
    int totalA4Width = newWidth/a4Width;
    int totalA4Height = newHeight/a4Height;
    
    _totalA4Width = totalA4Width;
    _totalA4Height = totalA4Height;
    
    
    
    //imageDivision
    
    double loopWidth = oldWidth / totalA4Width;
    double loopHeight = oldHeight / totalA4Height;
    
    
    double edgeWidth = loopWidth * (totalA4Width - (int) totalA4Width);
    double edgeHeight = loopHeight * (totalA4Height - (int) totalA4Height);
    
    int xStart = 0, yStart = 0, xEnd = (int)(loopWidth), yEnd = (int)(loopHeight);
    bool isPartWidth = false;
    bool isPartHeight = false;
    
    for(int j = 0; j <= (int) totalA4Height; j++)
    {
        for(int i=0; i <= (int) totalA4Width; i++)
        {
            isPartWidth = false;
            isPartHeight = false;
            
            xEnd = (int)(loopWidth);
            yEnd = (int)(loopHeight);
            
            if(i == (int) totalA4Width)
            {
                isPartWidth = true;
                xEnd = (int)edgeWidth;
                //alignment = Image.LEFT;
            }
            if(j == (int) totalA4Height)
            {
                isPartHeight = true;
                yEnd = (int)edgeHeight;
                //alignment = Image.TOP;
            }
            xStart = (int)(i * (int)(loopWidth));
            yStart = (int)(j * (int)(loopHeight));
            
            [self makeRectangle :xStart :yStart :xEnd :yEnd :croppedImage];
            //Todo - write to PDF
            
        }
    }
    
    
    //imageDivision
    
    
    
    UIGraphicsEndPDFContext();
}



- (void) makeRectangle:(NSInteger) startX: (NSInteger) startY : (NSInteger) width : (NSInteger) height: (UIImage *) cutImage {
    
    UIImageView *cutImageView = [[UIImageView alloc] initWithImage:cutImage];
    CGSize size = [cutImage size];
    
    // Frame location in view to show original image
    [cutImageView setFrame:CGRectMake(0, 0, size.width, size.height)];
    
    // Create rectangle that represents a cropped image
    // from the middle of the existing image
    CGRect rect = CGRectMake(startX,startY ,
                             width, height);
    
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([cutImage CGImage], rect);
    
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    // Create and show the new image from bitmap data
    cutImageView = [[UIImageView alloc] initWithImage:img];
    [cutImageView setFrame:CGRectMake(startX,startY,width,height)];
    
    if(cutImageView.image!=nil) {
        NSLog(@"It should be saved");
        //792, 1122ß
        // UIImageWriteToSavedPhotosAlbum(cutImageView.image, self ,  @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
        [cutImageView.image drawInRect:CGRectMake(0, 0, 612,792)];
    }
}





@end
