//
//  FilterService.swift
//  CameraFilter
//
//  Created by Алия on 15.12.2022.
//  Copyright © 2022 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    private var context: CIContext
    
    init(context: CIContext) {
        self.context = context
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            return Disposables.create()
        }
    }
    
    private func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        if let filter = CIFilter(name: "CIHatchedScreen") {
            filter.setValue(5.0, forKey: kCIInputWidthKey)
            if let sourceImage = CIImage(image: inputImage) {
                filter.setValue(sourceImage, forKey: kCIInputImageKey)
                if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                    let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                    completion(processedImage)
                }
            }
        }
    }
}
