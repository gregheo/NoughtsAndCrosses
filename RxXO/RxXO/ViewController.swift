//
//  ViewController.swift
//  XO
//
//  Copyright © 2016 Greg Heo. All rights reserved.
//

import Cocoa
import CoreGraphics

import RxCocoa
import RxSwift

private enum MouseDownError: Error {
  case NoPoint
  case NoSquare
}

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

  var gameController: XOGameController!

  let disposeBag = DisposeBag()

  var rx_click: Observable<Int> {
    return self.rx.sentMessage(#selector(NSResponder.mouseDown(with:)))
      .map({ (params) -> NSPoint? in
        if let event = params.first as? NSEvent {
          return self.view.convert(event.locationInWindow, from: nil)
        }
        return nil
      })
      .map({ (point) -> Int? in
        guard let point = point else { return nil }
        for (i, squareView) in self.squareViews.enumerated() {
          if squareView.frame.contains(point) {
            return i
          }
        }
        return nil
      })
      .unwrap()
  }

  override func viewDidAppear() {
    super.viewDidAppear()

    view.window?.backgroundColor = NSColor.white
    view.layer?.backgroundColor = NSColor.white.cgColor
    playBackgroundView.layer?.backgroundColor = NSColor.orange.cgColor

    squareViews = [square0, square1, square2, square3, square4, square5, square6, square7, square8]

    gameController = XOGameController(moves: rx_click)

    gameController
      .moveObservable
      .debug()
      .subscribe(onNext: { singleMove in
        self.squareViews[singleMove.square].squareState = singleMove.player
      })
      .disposed(by: disposeBag)

    gameController
      .resultObservable
      .debug()
      .subscribe(onNext: { moveResult in
        switch moveResult {
        case .win(let winner):
          let alert = NSAlert()
          alert.addButton(withTitle: "OK")
          alert.messageText = "Player \(winner.rawValue) has won!"
          alert.runModal()
        case .draw:
          let alert = NSAlert()
          alert.addButton(withTitle: "OK")
          alert.messageText = "No winner :("
          alert.runModal()
        default:
          // no-op
          break
        }
      })
      .disposed(by: disposeBag)
  }

}
