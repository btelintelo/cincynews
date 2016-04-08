//
//  RSSParser.swift
//  CincinnatiInbox
//
//  Created by Brian Telintelo on 3/13/16.
//  Copyright © 2016 Brian Telintelo. All rights reserved.
//

import UIKit

public class RSSParser: NSObject, NSXMLParserDelegate {
    
    
    var callbackClosure: ((feed: [NewsItem]?, error: NSError?) -> Void)?
    var currentElement: String = ""
    var currentItem: NewsItem?
    var dict : [String : String]?
    var feed: [NewsItem] = [NewsItem]()
    
    // node names
    let node_item: String = "item"
    
    let node_title: String = "title"
    let node_link: String = "link"
    let node_guid: String = "guid"
    let node_publicationDate: String = "pubDate"
    let node_description: String = "description"
    let node_content: String = "content:encoded"
    let node_language: String = "language"
    let node_lastBuildDate = "lastBuildDate"
    let node_generator = "generator"
    let node_copyright = "copyright"
    // wordpress specifics
    let node_commentsLink = "comments"
    let node_commentsCount = "slash:comments"
    let node_commentRSSLink = "wfw:commentRss"
    let node_author = "dc:creator"
    let node_category = "category"
    
    var source :String?
    
    func parseFeedForRequest(request: NSURLRequest, source:String, callback: (feed: [NewsItem]?, error: NSError?) -> Void)
    {
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            self.source = source
            
            if ((error) != nil)
            {
                callback(feed: nil, error: error)
            }
            else
            {
                self.callbackClosure = callback
                
                let parser : NSXMLParser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.shouldResolveExternalEntities = false
                parser.parse()
            }
        }
    }
    
    // MARK: NSXMLParserDelegate
    public func parserDidStartDocument(parser: NSXMLParser)
    {
    }
    
    public func parserDidEndDocument(parser: NSXMLParser)
    {
        if let closure = self.callbackClosure
        {
            closure(feed: self.feed, error: nil)
        }
    }
    
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == node_item
        {
            self.currentItem = NewsItem()
            self.currentItem?.source = source
        }
        
        self.dict = attributeDict
        
        if elementName == "enclosure" || elementName == "media:content"
        {
            self.currentItem!.imageUrl = dict!["url"]
            
        }
        
        
        self.currentElement = ""
    }
    
    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == node_item
        {
            if let item = self.currentItem
            {
                self.feed.append(item)
            }
            
            self.currentItem = nil
            return
        }
        
        if let item = self.currentItem
        {
            if elementName == node_title
            {
                item.title = self.currentElement
            }
            
            if elementName == node_link
            {
                item.link = self.currentElement
            }
            //
            if elementName == node_guid
            {
                item.key = self.currentElement
            }
            
            if elementName == node_publicationDate
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZ"
                let date = dateFormatter.dateFromString(self.currentElement)
                if let d = date{
                    item.publishedDate = d
                }
                else
                {
                    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                    let date2 = dateFormatter.dateFromString(self.currentElement)
                    if let dt = date2
                    {
                        item.publishedDate = dt
                    }
                    
                }
            }
            //
            if elementName == node_description
            {
                item.descriptionHTML = self.currentElement
                item.description = self.currentElement.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil).stringByReplacingOccurrencesOfString("\n", withString: "")
            }
            
            
            
            //
            //            if elementName == node_content
            //            {
            //                item.content = self.currentElement
            //            }
            //
            //            if elementName == node_commentsLink
            //            {
            //                item.setCommentsLink(self.currentElement)
            //            }
            //
            //            if elementName == node_commentsCount
            //            {
            //                item.commentsCount = self.currentElement.toInt()
            //            }
            //
            //            if elementName == node_commentRSSLink
            //            {
            //                item.setCommentRSSLink(self.currentElement)
            //            }
            //
            //            if elementName == node_author
            //            {
            //                item.author = self.currentElement
            //            }
            //
            //            if elementName == node_category
            //            {
            //                item.categories.append(self.currentElement)
            //            }
            
        }
        else
        {
            //            if elementName == node_title
            //            {
            //                feed.title = self.currentElement
            //            }
            //
            //            if elementName == node_link
            //            {
            //                feed.setLink(self.currentElement)
            //            }
            //
            //            if elementName == node_description
            //            {
            //                feed.feedDescription = self.currentElement
            //            }
            //
            //            if elementName == node_language
            //            {
            //                feed.language = self.currentElement
            //            }
            //
            //            if elementName == node_lastBuildDate
            //            {
            //                feed.setlastBuildDate(self.currentElement)
            //            }
            //            
            //            if elementName == node_generator
            //            {
            //                feed.generator = self.currentElement
            //            }
            //            
            //            if elementName == node_copyright
            //            {
            //                feed.copyright = self.currentElement
            //            }
        }
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String) {
        self.currentElement += string
    }
    
    public func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
        if let closure = self.callbackClosure
        {
            closure(feed: nil, error: parseError)
        }
    }
    
}