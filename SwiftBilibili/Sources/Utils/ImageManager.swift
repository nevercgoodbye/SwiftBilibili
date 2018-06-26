//
//  ImageManager.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/6/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import Kingfisher

class ImageManager {
    class func cachePathForKey(_ key: String) -> String? {
        let fileName = key
        return (KingfisherManager.shared.cache.diskCachePath as NSString).appendingPathComponent(fileName)
    }
    class func storeImage(urlString:String,completionHandler: (() -> ())?) {
        guard let imageURL = URL(string: urlString) else {
            return
        }
        let downloader = KingfisherManager.shared.downloader
        downloader.downloadImage(with: imageURL) { (image, error, _, data) in
            if image != nil {
                KingfisherManager.shared.cache.removeImage(forKey: urlString)
                KingfisherManager.shared.cache.store(image!,forKey: urlString, toDisk: true, completionHandler: completionHandler)
            }
        }
    }
    class func removeImage(key:String) {
        KingfisherManager.shared.cache.removeImage(forKey:key)
    }
    
    class func retrieveImage(key:String) -> UIImage? {
        
        let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: key)
        
        return image
    }
    
}

