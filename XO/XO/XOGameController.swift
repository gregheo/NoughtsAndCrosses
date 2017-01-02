//
//  XOGameController.swift
//  XO
//
//  Copyright © 2016 Greg Heo. All rights reserved.
//

import Foundation

enum Player {
  case Nought
  case Cross
}

class XOGameController {
  private(set) var currentPlayer = Player.Cross
  private(set) var squares: [Player?] = Array(repeating: nil, count: 9)

  var moveCount: Int {
    return squares.reduce(0, { (a, p) in a + (p == nil ? 0 : 1) })
  }

  func playTurn(square: Int) {
    precondition(square >= 0 && square < squares.count, "selected square is out of bounds!")

    if squares[square] != nil {
      // square is already occupied!
      return
    }

    squares[square] = currentPlayer

    currentPlayer = (currentPlayer == .Cross) ? .Nought : .Cross
  }
}
