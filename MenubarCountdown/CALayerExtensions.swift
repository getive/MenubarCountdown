//
//  CALayerExtensions.swift
//  MenubarCountdown
//
//  Copyright © 2009, 2015 Kristopher Johnson. All rights reserved.
//
//  This file is part of Menubar Countdown.
//
//  Menubar Countdown is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Menubar Countdown is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Menubar Countdown.  If not, see <http://www.gnu.org/licenses/>.
//

import Cocoa

// MARK: Create layer from image resource
extension CALayer {
    static func createImageNamed(name: String) -> CGImageRef? {
        var image: CGImageRef? = nil

        if let path = NSBundle.mainBundle().pathForResource(name, ofType: nil) {
            let url = NSURL.fileURLWithPath(path)
            if let imageSource = CGImageSourceCreateWithURL(url, nil) {
                image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            }
            else {
                Log.error("CGImageSourceCreateWithURL failed")
            }
        }
        else {
            Log.error("unable to load image from file \(name)")
        }

        return image
    }

    static func newLayerWithContentsFromFileNamed(name: String) -> CALayer {
        let newLayer = CALayer()
        newLayer.setContentsFromFileNamed(name)
        return newLayer
    }

    func setContentsFromFileNamed(name: String) {
        if let image = CALayer.createImageNamed(name) {
            let imageWidth = CGImageGetWidth(image)
            let imageHeight = CGImageGetHeight(image)

            self.bounds = CGRectMake(0.0, 0.0, CGFloat(imageWidth), CGFloat(imageHeight))
            self.contents = image
        }
        else {
            Log.error("unable to set contents from file \(name)")
        }
    }
}

// MARK: Layer coordinate system
extension CALayer {
    func orientBottomLeft() {
        self.anchorPoint = CGPointZero
        self.position = CGPointZero
        self.contentsGravity = kCAGravityBottomLeft
    }
}

// MARK: Add/remove blink animation
extension CALayer {
    @nonobjc static let BlinkAnimationKey = "CALayer_Additions_BlinkAnimation"

    func addBlinkAnimation() {
        if let _ = animationForKey(CALayer.BlinkAnimationKey) {
            return
        }

        let animation = CABasicAnimation(keyPath: "opacity")

        // Repeat forever, once per second
        animation.repeatCount = Float.infinity
        animation.duration = 0.5
        animation.autoreverses = true

        // Cycle between 0 and full opacity
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        addAnimation(animation, forKey: CALayer.BlinkAnimationKey)
    }

    func removeBlinkAnimation() {
        removeAnimationForKey(CALayer.BlinkAnimationKey)
    }
}
