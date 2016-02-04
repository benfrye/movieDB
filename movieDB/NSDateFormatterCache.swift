//
//  NSDateFormatterCache.swift
//  movieDB
//
//  Created by Ben Frye on 2/4/16.
//  Copyright © 2016 benhamine. All rights reserved.
//

import Foundation


class NSDateFormatterCache: NSObject {
    
    static let sharedCache = NSDateFormatterCache()
    let mainThreadCache = NSCache()
    let backgroundThreadCache = NSCache()
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLocaleDidChange:", name: NSCurrentLocaleDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSCurrentLocaleDidChangeNotification, object: nil)
    }
    
    func onLocaleDidChange(notification: NSNotification) {
        self.mainThreadCache.removeAllObjects()
        self.backgroundThreadCache.removeAllObjects()
    }
    
    static func formatter(format: String) -> NSDateFormatter {
        
        let formatter: NSDateFormatter
        let sharedCache = self.sharedCache
        let threadCache = NSThread.isMainThread() ? sharedCache.mainThreadCache : sharedCache.backgroundThreadCache
        
        if let chachedFormatter = threadCache.objectForKey(format) as? NSDateFormatter {
            
            formatter = chachedFormatter
            
        } else {
            
            formatter = NSDateFormatter()
            formatter.locale = NSLocale.currentLocale()
            formatter.timeZone = NSTimeZone.localTimeZone()
            formatter.dateFormat = format
            threadCache.setObject(formatter, forKey: format)
            
        }
        
        return formatter
    }
    
}