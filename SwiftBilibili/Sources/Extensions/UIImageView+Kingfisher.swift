//
//  UIImageView+Kingfisher.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import Foundation

import Kingfisher
import RxCocoa
import RxSwift

typealias ImageOptions = KingfisherOptionsInfo

enum ImageResult {
    case success(UIImage)
    case failure(Error)
    
    var image: UIImage? {
        if case .success(let image) = self {
            return image
        } else {
            return nil
        }
    }
    
    var error: Error? {
        if case .failure(let error) = self {
            return error
        } else {
            return nil
        }
    }
}

extension UIImageView {
    @discardableResult
    func setImage(
        with resource: Resource?,
        placeholder: UIImage? = nil,
        options: ImageOptions = [.transition(.fade(0.25))],
        progress: ((Int64, Int64) -> Void)? = nil,
        completion: ((ImageResult) -> Void)? = nil
        ) -> RetrieveImageTask {
        var options = options
        // GIF will only animates in the AnimatedImageView
        if self is AnimatedImageView == false {
            options.append(.onlyLoadFirstFrame)
        }
        let completionHandler: CompletionHandler = { image, error, cacheType, url in
            if let image = image {
                completion?(.success(image))
            } else if let error = error {
                completion?(.failure(error))
            }
        }
        return self.kf.setImage(
            with: resource,
            placeholder: placeholder,
            options: options,
            progressBlock: progress,
            completionHandler: completionHandler
        )
    }
}

extension Reactive where Base: UIImageView {
    func image(placeholder: UIImage? = nil, options: ImageOptions = [.transition(.fade(0.25))]) -> Binder<Resource?> {
        return Binder(self.base) { imageView, resource in
            imageView.setImage(with: resource, placeholder: placeholder, options: options)
        }
    }
}
