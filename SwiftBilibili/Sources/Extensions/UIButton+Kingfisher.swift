//
//  UIButton+Kingfisher.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/3.
//  Copyright © 2018年 罗文. All rights reserved.
//

import Foundation

import Kingfisher

extension UIButton {
    
    @discardableResult
    func setImage(
        with resource: Resource?,
        for state: UIControlState,
        placeholder: UIImage? = nil,
        options: ImageOptions = [.transition(.fade(0.25))],
        progress: ((Int64, Int64) -> Void)? = nil,
        completion: ((ImageResult) -> Void)? = nil
        ) -> RetrieveImageTask {

        let completionHandler: CompletionHandler = { image, error, cacheType, url in
            if let image = image {
                completion?(.success(image))
            } else if let error = error {
                completion?(.failure(error))
            }
        }
        return self.kf.setImage(with: resource, for: state, placeholder: placeholder, options: options, progressBlock: progress, completionHandler: completionHandler)
    }
    
    @discardableResult
    func setBackgroundImage(
        with resource: Resource?,
        for state: UIControlState,
        placeholder: UIImage? = nil,
        options: ImageOptions = [.transition(.fade(0.25))],
        progress: ((Int64, Int64) -> Void)? = nil,
        completion: ((ImageResult) -> Void)? = nil
        ) -> RetrieveImageTask {
        
        let completionHandler: CompletionHandler = { image, error, cacheType, url in
            if let image = image {
                completion?(.success(image))
            } else if let error = error {
                completion?(.failure(error))
            }
        }
        return self.kf.setBackgroundImage(with: resource, for: state, placeholder: placeholder, options: options, progressBlock: progress, completionHandler: completionHandler)
    }
    
    
    
}
