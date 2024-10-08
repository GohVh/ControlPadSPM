//
//  Extensions.swift
//  ControlPad
//
//  Created by hansoong on 23/9/24.
//

import Foundation
import SwiftUI

public extension View {
    func squareFrame(_ squareSide: CGFloat) -> some View {
        frame(width: squareSide, height: squareSide)
    }
}

extension CGRect {
    func offset(by off: CGSize) -> CGRect {
        offsetBy(dx: off.width, dy: off.height)
    }
}
