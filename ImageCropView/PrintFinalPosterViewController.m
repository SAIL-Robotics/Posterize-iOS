//
//  PrintFinalPosterViewController.m
//  ImageCropView
//
//  Created by Aishwarya Krishnan on 7/31/15.
//
//

#import "PrintFinalPosterViewController.h"

@interface PrintFinalPosterViewController ()

@end

@implementation PrintFinalPosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Loading printfinalposter");
    [_printposterView setImage:_image];
    

    NSLog(@"total papes %d",_totalPapers);
 
    _pagesLabel.text = [NSString stringWithFormat:@"%d", _totalPapers];
    _orientationLabel.text = _orientation;
    //[_orientationLabel setText:_orientation];
    
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    NSLog(@"The original poster size : width : %ff and height : %f",_totalA4Width,_totalA4Height);
    
    [self cropImage:_printposterView.image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) cropImage:(UIImage *)croppedImage {
    
    
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
    
    
    /*if(size.height > size.width) {
        newWidth = size.height;
        newHeight = size.width;
    }
    
    int totalA4Width = newWidth/a4Width;
    int totalA4Height = newHeight/a4Height;*/
    
    
    
    //imageDivision
    
    double loopWidth = oldWidth / _totalA4Width;
    double loopHeight = oldHeight / _totalA4Height;
    
    
    double edgeWidth = loopWidth * (_totalA4Width - (int) _totalA4Width);
    double edgeHeight = loopHeight * (_totalA4Height - (int) _totalA4Height);
    
    int xStart = 0, yStart = 0, xEnd = (int)(loopWidth), yEnd = (int)(loopHeight);
    bool isPartWidth = false;
    bool isPartHeight = false;
    
    for(int j = 0; j <= (int) _totalA4Height; j++)
    {
        for(int i=0; i <= (int) _totalA4Width; i++)
        {
            isPartWidth = false;
            isPartHeight = false;
            
            xEnd = (int)(loopWidth);
            yEnd = (int)(loopHeight);
            
            if(i == (int) _totalA4Width)
            {
                isPartWidth = true;
                xEnd = (int)edgeWidth;
                //alignment = Image.LEFT;
            }
            if(j == (int) _totalA4Height)
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
