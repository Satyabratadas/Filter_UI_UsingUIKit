//
//  TwoRangeSliderDelegate.swift
//  TwoRangeSlider
//
//  Created by Satyabrata Das on 01/03/24.
//

import CoreGraphics

public protocol TwoRangeSliderDelegate: AnyObject {

    /// Called when the TwoRangeSlider values are changed
    ///
    /// - Parameters:
    ///   - slider: TwoRangeSlider
    ///   - minValue: minimum value
    ///   - maxValue: maximum value
    func rangeSeekSlider(_ slider: TwoRangeSlider, didChange minValue: CGFloat, maxValue: CGFloat)

    /// Called when the user has started interacting with the TwoRangeSlider
    ///
    /// - Parameter slider: TwoRangeSlider
    func didStartTouches(in slider: TwoRangeSlider)

    /// Called when the user has finished interacting with the TwoRangeSlider
    ///
    /// - Parameter slider: TwoRangeSlider
    func didEndTouches(in slider: TwoRangeSlider)

    /// Called when the TwoRangeSlider values are changed. A return `String?` Value is displayed on the `minLabel`.
    ///
    /// - Parameters:
    ///   - slider: TwoRangeSlider
    ///   - minValue: minimum value
    /// - Returns: String to be replaced
    func rangeSeekSlider(_ slider: TwoRangeSlider, stringForMinValue minValue: CGFloat) -> String?

    /// Called when the TwoRangeSlider values are changed. A return `String?` Value is displayed on the `maxLabel`.
    ///
    /// - Parameters:
    ///   - slider: TwoRangeSlider
    ///   - maxValue: maximum value
    /// - Returns: String to be replaced
    func rangeSeekSlider(_ slider: TwoRangeSlider, stringForMaxValue: CGFloat) -> String?
}


// MARK: - Default implementation

public extension TwoRangeSliderDelegate {

    func rangeSeekSlider(_ slider: TwoRangeSlider, didChange minValue: CGFloat, maxValue: CGFloat) {}
    func didStartTouches(in slider: TwoRangeSlider) {}
    func didEndTouches(in slider: TwoRangeSlider) {}
    func rangeSeekSlider(_ slider: TwoRangeSlider, stringForMinValue minValue: CGFloat) -> String? { return nil }
    func rangeSeekSlider(_ slider: TwoRangeSlider, stringForMaxValue maxValue: CGFloat) -> String? { return nil }
}
