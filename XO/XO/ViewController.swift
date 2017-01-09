//
//  ViewController.swift
//  XO
//
//  Copyright © 2016 Greg Heo. All rights reserved.
//

import Cocoa
import CoreGraphics

class ViewController: NSViewController {
  @IBOutlet var playBackgroundView: NSView!

  @IBOutlet var square0: SquareView!
  @IBOutlet var square1: SquareView!
  @IBOutlet var square2: SquareView!
  @IBOutlet var square3: SquareView!
  @IBOutlet var square4: SquareView!
  @IBOutlet var square5: SquareView!
  @IBOutlet var square6: SquareView!
  @IBOutlet var square7: SquareView!
  @IBOutlet var square8: SquareView!

  var squareViews: [SquareView] = []

  let gameController = XOGameController()

  override func viewDidAppear() {
    super.viewDidAppear()

    view.window?.backgroundColor = NSColor.white
    view.layer?.backgroundColor = NSColor.white.cgColor
    playBackgroundView.layer?.backgroundColor = NSColor.orange.cgColor

    squareViews = [square0, square1, square2, square3, square4, square5, square6, square7, square8]
  }

  override func mouseDown(with event: NSEvent) {
    for (i, squareView) in squareViews.enumerated() {
      if squareView.frame.contains(view.convert(event.locationInWindow, from: nil)) {
        gameController.playTurn(square: i)
        refreshSquareViews()
        checkForWinner()
        break
      }
    }
  }

  private func refreshSquareViews() {
    for (i, squareState) in gameController.squares.enumerated() {
      squareViews[i].squareState = squareState
    }
  }

  private func resetGame() {
    gameController.reset()
    refreshSquareViews()
  }

  private func checkForWinner() {
    if let winner = gameController.winner {
      let alert = NSAlert()
      alert.addButton(withTitle: "OK")
      alert.messageText = "Player \(winner.rawValue) has won!"
      alert.runModal()
      resetGame()
    } else if gameController.moveCount == 9 {
      let alert = NSAlert()
      alert.addButton(withTitle: "OK")
      alert.messageText = "No winner :("
      alert.runModal()
    }
  }
}
