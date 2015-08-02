//
//  CameraRuler.m
//  ImageCropView
//
//  Created by Preethi Baskar Baskaran on 8/1/15.
//
//
#import "CameraRuler.h"
@interface CameraRuler ()

@end

@implementation CameraRuler
NSMutableArray *touchPointsArray;
double knownRealDistance, unknownRealDistance;
-(void)viewDidLoad{
    [_resetButton setEnabled:NO];
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//            {
//                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//                [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//                [imagePicker setDelegate:self];
//                [self presentViewController:imagePicker animated:YES completion:nil];
//            }
//            else
//            {
//                [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//

    
    //Temporarily choose image from gallery - to check in simulator. Uncomment the above code before deploying.
    _touchCount = 0;
    touchPointsArray =  [[NSMutableArray alloc]init];
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];

}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _rulerImage = [info valueForKey:UIImagePickerControllerOriginalImage];

    _rulerImageView.image = _rulerImage;
    _tempImage = _rulerImage;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
//                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                             target:self
//                                             action:@selector(cancel:)];
    [picker dismissViewControllerAnimated:NO completion:nil];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Handle tap!");
    _touchCount++;
    [_resetButton setEnabled:YES];
    if(_touchCount <= 4){
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView: _rulerImageView];
        [self drawOverImage:touchPoint :touchPoint];
        [touchPointsArray addObject:[NSValue valueWithCGPoint:touchPoint]];
        if(_touchCount %2 == 0){
            
            
            CGPoint startPoint = [[touchPointsArray objectAtIndex:_touchCount - 1] CGPointValue];
            CGPoint endPoint = [[touchPointsArray objectAtIndex : _touchCount - 2 ] CGPointValue];
            
            [self drawOverImage:startPoint :endPoint];
            
        }
    }
}
-(void)drawOverImage: (CGPoint)startPoint: (CGPoint)endPoint{
    UIGraphicsBeginImageContext(_rulerImageView.frame.size);
    [_rulerImageView.image drawInRect:CGRectMake(0, 0, _rulerImageView.frame.size.width, _rulerImageView.frame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2);
    
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
    
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),(int) startPoint.x, (int)startPoint.y);
    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),(int) endPoint.x, (int)endPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    _rulerImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

double coordinateDistance(CGPoint p1, CGPoint p2)
{
    double dist = pow(p2.x - p1.x, 2.0) + pow(p2.y - p1.y, 2.0);
    return sqrt(dist);
}

 double calculateDistance()
{
    CGPoint startPoint = [[touchPointsArray objectAtIndex:0] CGPointValue];
    CGPoint endPoint = [[touchPointsArray objectAtIndex :1] CGPointValue];
    double knownCoordinateDistance = coordinateDistance(startPoint , endPoint);
    CGPoint unknownStartPoint = [[touchPointsArray objectAtIndex:2] CGPointValue];
    CGPoint unknownEndPoint = [[touchPointsArray objectAtIndex :3] CGPointValue];
    double unknownCoordinateDistance = coordinateDistance(unknownStartPoint, unknownEndPoint);
    
    double unknownRealDistance = (knownRealDistance * unknownCoordinateDistance) / knownCoordinateDistance;
    
    return unknownRealDistance;
}


- (IBAction)resetButton:(id)sender {
    _rulerImageView.image = _tempImage;
    [touchPointsArray removeAllObjects];
    _touchCount = 0;
    [_resetButton setEnabled:NO];
}
@end


