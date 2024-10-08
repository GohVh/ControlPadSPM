//
//  PlanarGeometry.swift
//  ControlPad
//
//  Created by hansoong on 23/9/24.
//
import SwiftUI

/// Geometry defines how the touch point's location affect the control values
public enum PlanarGeometry {
    /// Most sliders, both horizontal and vertical, where you expect
    /// your touch point to always represent the control point
    case rectilinear

    /// Knobs, or small control areas
    case relativeRectilinear(xSensitivity: Double = 1.0,
                             ySensitivity: Double = 1.0)

    /// Larger knobs with a more skeumorphic drag and twist motif.
    /// For non relative the values change immediately to match the touch.
    case polar(angularRange: ClosedRange<Angle> = Angle.zero ... Angle(degrees: 360))

    /// This version gives the user control in the radial direction
    /// and doesn't change the angle immediately to match the touch
    case relativePolar(radialSensitivity: Double = 1.0)

    func calculateValuePair(value1: Float,
                            value2: Float,
                            xPosition: Float,
                            yPosition: Float,
                            range1: ClosedRange<Float> = 0 ... 1,
                            range2: ClosedRange<Float> = 0 ... 1,
                            from oldValue: CGPoint,
                            to touchLocation: CGPoint,
                            inRect rect: CGRect,
                            padding: CGSize) -> ((Float, Float),(Float, Float))
    {
        guard touchLocation != .zero else { return ((xPosition, yPosition), (value1, value2)) }
        
        let defaultXrange: ClosedRange<Float> = 0 ... 1
        let defaultYrange: ClosedRange<Float> = 0 ... 1
        let defaultXrangeRatio = defaultXrange.upperBound - defaultXrange.lowerBound
        let defaultYrangeRatio = defaultYrange.upperBound - defaultYrange.lowerBound
        
        let xrangeRatio = range1.upperBound - range1.lowerBound
        let yrangeRatio = range2.upperBound - range2.lowerBound
        
        let xoffset = value1 - defaultXrange.lowerBound
        let yoffset = value2 - defaultYrange.lowerBound

        _ = Float(range1.lowerBound) + (xoffset / defaultXrangeRatio) * Float(xrangeRatio)
        _ = Float(range2.lowerBound) + (yoffset / defaultYrangeRatio) * Float(yrangeRatio)

        let positionX = touchLocation.x - padding.width
        let positionY = touchLocation.y - padding.height
        
//        print("xrange ratio: \(xrangeRatio), yrange ratio: \(yrangeRatio)")
//        print("x: \(x), y: \(y)")

        var newXPosition: Float = value1
        var newYPosition: Float = value2

        switch self {
        case .rectilinear:
            newXPosition = Float(positionX / (rect.size.width - 2 * padding.width)) * defaultXrangeRatio + defaultXrange.lowerBound
            newYPosition = Float(1.0 - positionY / (rect.size.height - 2 * padding.height)) * defaultYrangeRatio + defaultYrange.lowerBound

        case let .relativeRectilinear(xSensitivity: xSensitivity, ySensitivity: ySensitivity):
            guard oldValue != .zero else { return ((value1, value2), (value1, value2)) }
            newXPosition += Float((touchLocation.x - oldValue.x) * xSensitivity / rect.size.width)
            newYPosition -= Float((touchLocation.y - oldValue.y) * ySensitivity / rect.size.height)

        case let .polar(angularRange: angularRange):
            let polar = polarCoordinate(point: touchLocation, rect: rect)
            let width = angularRange.upperBound.radians - angularRange.lowerBound.radians
            newXPosition = polar.radius
            newYPosition = Float((polar.angle.radians - angularRange.lowerBound.radians) / width)

        case let .relativePolar(radialSensitivity: radialSensitivity):
            guard oldValue != .zero else { return ((value1, value2), (value1, value2)) }
            let oldPolar = polarCoordinate(point: oldValue, rect: rect)
            let newPolar = polarCoordinate(point: touchLocation, rect: rect)

            newXPosition += (newPolar.radius - oldPolar.radius) * Float(radialSensitivity)
            newYPosition += Float((newPolar.angle.radians - oldPolar.angle.radians) / (2.0 * .pi))
        }

        newXPosition = max(defaultXrange.lowerBound, min(defaultXrange.upperBound, newXPosition))
        newYPosition = max(defaultYrange.lowerBound, min(defaultYrange.upperBound, newYPosition))

        let newX = Float(range1.lowerBound) + ((newXPosition - defaultXrange.lowerBound) / defaultXrangeRatio) * Float(xrangeRatio)
        let newY = Float(range2.lowerBound) + ((newYPosition - defaultYrange.lowerBound) / defaultYrangeRatio) * Float(yrangeRatio)

//        print("new X position: \(newXPosition), new Y position2: \(newYPosition)")
//        print("new x: \(newX), new y: \(newY)")

        return ((newXPosition, newYPosition), (newX, newY))
    }


    func polarCoordinate(point: CGPoint, rect: CGRect) -> PolarCoordinate {
        // Calculate the x and y distances from the center
        let deltaX = (point.x - rect.midX) / (rect.width / 2.0)
        let deltaY = (point.y - rect.midY) / (rect.height / 2.0)

        // Convert to polar
        let radius = max(0.0, min(1.0, sqrt(pow(deltaX, 2) + pow(deltaY, 2))))
        var theta = atan(deltaY / deltaX)

        // Rotate to clockwise polar from -y axis (most like a knob)
        theta += .pi * (deltaX > 0 ? 1.5 : 0.5)

        return PolarCoordinate(radius: Float(radius), angle: Angle(radians: theta))
    }
}

struct PolarCoordinate {
    var radius: Float
    var angle: Angle
}
