//
//  SquareView.swift
//  XO
//
//  Copyright © 2016 Greg Heo. All rights reserved.
//

import Cocoa
import CoreGraphics

private let kStrokeWidth: CGFloat = 8.0

class SquareView: NSView {
  var squareState: Player? {
    didSet {
      setNeedsDisplay(bounds)
    }
  }

  override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()

    self.layer?.backgroundColor = NSColor.white.cgColor
  }

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)

    let insetPoints: CGFloat = bounds.size.width / 6.0
    NSColor.black.setStroke()
    NSColor.white.setFill()

    if squareState == .Nought {
      let path = NSBezierPath(ovalIn: bounds.insetBy(dx: insetPoints, dy: insetPoints))
      path.lineWidth = kStrokeWidth

      path.stroke()
    } else if squareState == .Cross {
      let path = NSBezierPath()
      path.lineWidth = kStrokeWidth
      path.move(to: NSPoint(x: insetPoints, y: insetPoints))
      path.line(to: NSPoint(x: bounds.size.width - insetPoints, y: bounds.size.height - insetPoints))
      path.move(to: NSPoint(x: insetPoints, y: bounds.size.height - insetPoints))
      path.line(to: NSPoint(x: bounds.size.width - insetPoints, y: insetPoints))

      path.stroke()
    } else {
      // empty square
      let path = NSBezierPath(rect: bounds)
      path.fill()
    }
  }

}
