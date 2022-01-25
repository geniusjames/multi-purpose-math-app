//
//  MenuHelper.swift
//  Apprtc
//
//  Created by Aashish Adhikari on 1/30/18.
//  Copyright © 2018 Aashish Adhikari. All rights reserved.
//

import Foundation
import UIKit

public enum Direction {
    case up
    case down
    case left
    case right
}

public class MenuHelper {

    static let menuWidth: CGFloat = 0.8

    static let percentThreshold: CGFloat = 0.3

    static let snapshotNumber = 12345

    public static func calculateProgress(translationInView: CGPoint, viewBounds: CGRect, direction: Direction) -> CGFloat {
        let pointOnAxis: CGFloat
        let axisLength: CGFloat
        switch direction {
        case .up, .down:
            pointOnAxis = translationInView.y
            axisLength = viewBounds.height
        case .left, .right:
            pointOnAxis = translationInView.x
            axisLength = viewBounds.width
        }
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis: Float
        let positiveMovementOnAxisPercent: Float
        switch direction {
        case .right, .down: // positive
            positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        case .up, .left: // negative
            positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
            return CGFloat(-positiveMovementOnAxisPercent)
        }
    }

    public static func mapGestureStateToInteractor(gestureState: UIGestureRecognizer.State, progress: CGFloat, interactor: Interactor?, triggerSegue: () -> Void) {
        guard let interactor = interactor else { return }
        switch gestureState {
        case .began:
            interactor.hasStarted = true
            triggerSegue()
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }

}
