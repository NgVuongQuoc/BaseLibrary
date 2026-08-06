//
//  BaseBottomBarTossEngine.swift
//  BaseLibrary
//
//  The toss path and timing formulas in this file are adapted from AMTabView
//  0.1.2: https://github.com/Abedalkareem/AMTabView
//
//  Copyright (c) 2019 Abedalkareem <abedalkareem.omreyh@yahoo.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

enum BaseBottomBarTossEngine {
    static let totalDuration: TimeInterval = 1
    static let shapePhaseDuration = totalDuration * 0.2
    static let ballDuration = totalDuration * 0.4
    static let tintAndIconDuration = totalDuration * 0.4

    struct Metrics {
        let sectionWidth: CGFloat
        let sectionHeight: CGFloat
        let itemHeight: CGFloat
        let ballSize: CGFloat
        let iconSize: CGFloat
    }

    static func metrics(in bounds: CGRect, numberOfTabs: Int) -> Metrics {
        guard numberOfTabs > 0 else {
            return Metrics(
                sectionWidth: 0,
                sectionHeight: bounds.height,
                itemHeight: 0,
                ballSize: 0,
                iconSize: 0
            )
        }

        let sectionWidth = bounds.width / CGFloat(numberOfTabs)
        let itemWidth = min(sectionWidth, 100)
        let ballSize = itemWidth / 2
        return Metrics(
            sectionWidth: sectionWidth,
            sectionHeight: bounds.height,
            itemHeight: min(bounds.height, ballSize),
            ballSize: ballSize,
            iconSize: ballSize / 1.5
        )
    }

    static func ballPath(
        fromX: CGFloat,
        toX: CGFloat,
        in bounds: CGRect,
        numberOfTabs: Int
    ) -> CGPath {
        let metrics = metrics(in: bounds, numberOfTabs: numberOfTabs)
        var controlPointY = abs(fromX - toX)
        controlPointY = controlPointY != 0 ? controlPointY : 50

        let path = UIBezierPath()
        path.move(to: CGPoint(x: fromX, y: metrics.itemHeight * 0.5))
        path.addQuadCurve(
            to: CGPoint(x: toX, y: metrics.itemHeight * 0.25),
            controlPoint: CGPoint(
                x: (fromX + toX) / 2,
                y: -controlPointY
            )
        )
        return path.cgPath
    }

    static func notchPath(
        selectedIndex: Int,
        in bounds: CGRect,
        numberOfTabs: Int
    ) -> CGPath {
        let metrics = metrics(in: bounds, numberOfTabs: numberOfTabs)
        guard numberOfTabs > 0, (0..<numberOfTabs).contains(selectedIndex) else {
            return fullRectangle(in: bounds)
        }

        let beginningOfTheTab = CGFloat(selectedIndex) * metrics.sectionWidth
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(
            to: CGPoint(
                x: beginningOfTheTab - metrics.sectionWidth * 0.3,
                y: 0
            )
        )
        path.addQuadCurve(
            to: CGPoint(
                x: beginningOfTheTab + metrics.sectionWidth * 0.2,
                y: metrics.itemHeight * 0.5
            ),
            controlPoint: CGPoint(
                x: beginningOfTheTab + metrics.sectionWidth * 0.1,
                y: 0
            )
        )
        path.addCurve(
            to: CGPoint(
                x: beginningOfTheTab + metrics.sectionWidth * 0.8,
                y: metrics.itemHeight * 0.5
            ),
            controlPoint1: CGPoint(
                x: beginningOfTheTab + metrics.sectionWidth * 0.3,
                y: metrics.itemHeight
            ),
            controlPoint2: CGPoint(
                x: beginningOfTheTab + metrics.sectionWidth * 0.7,
                y: metrics.itemHeight
            )
        )
        path.addQuadCurve(
            to: CGPoint(
                x: beginningOfTheTab + metrics.sectionWidth * 1.3,
                y: 0
            ),
            controlPoint: CGPoint(
                x: beginningOfTheTab + metrics.sectionWidth * 0.9,
                y: 0
            )
        )
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.addLine(
            to: CGPoint(x: bounds.width, y: metrics.sectionHeight)
        )
        path.addLine(to: CGPoint(x: 0, y: metrics.sectionHeight))
        path.addLine(to: .zero)
        path.close()
        return path.cgPath
    }

    static func fullRectangle(in bounds: CGRect) -> CGPath {
        let path = UIBezierPath(rect: bounds)
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.addLine(to: .zero)
        path.close()
        return path.cgPath
    }
}
