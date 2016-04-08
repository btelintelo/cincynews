//
//  NewsItemTableViewCell.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/13/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit
import AlamofireImage
import MCSwipeTableViewCell

class NewsItemTableViewCell: MCSwipeTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    
    @IBOutlet weak var sourceLabel: UILabel!
    func setNewsItem(newsItem:NewsItem, hasRead:Bool)
    {
        if hasRead
        {
            self.mainImage.alpha = 0.35
            self.titleLabel.alpha = 0.35
        }
        else
        {
            self.mainImage.alpha = 1.0
            self.titleLabel.alpha = 1.0
        }
        titleLabel.text = newsItem.title
        if let imageUrl = newsItem.imageUrl
        {
            if let url = NSURL(string: imageUrl)
            {
                mainImage.af_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder"))
                
            }
        }
        if let label = descriptionLabel
        {
            label.text = newsItem.description
        }
        
        if let label = postDateLabel
        {
            
            var shortDate: String {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                return dateFormatter.stringFromDate(newsItem.publishedDate)
            }

            label.text = shortDate
            
        }
        
        if let label = sourceLabel
        {
            label.text = newsItem.source;
        }
//        if let cm = checkmark
//        {
//            cm.hidden = !hasRead
//        }
    }
    
    func imageHeight() -> CGFloat
    {
        if let image = mainImage
        {
             return (image.image?.size.height)!
        }
        return 0.0
    }
    
//    func convertToGrayScale(image: UIImage) -> UIImage {
//        let imageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
//        let colorSpace = CGColorSpaceCreateDeviceGray()
//        let width = image.size.width
//        let height = image.size.height
//        
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
//        let context = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, colorSpace, bitmapInfo.rawValue)
//        
//        CGContextDrawImage(context, imageRect, image.CGImage)
//        let imageRef = CGBitmapContextCreateImage(context)
//        let newImage = UIImage(CGImage: imageRef!)
//        
//        return newImage
//    }

}
