//
//  XOGameController.swift
//  XO
//
//  Copyright © 2016 Greg Heo. All rights reserved.
//

import Foundation

enum Player: String {
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

  func reset() {
    currentPlayer = .Cross
    squares = Array(repeating: nil, count: 9)
  }

  var winner: Player? {
    // horizontals
    for index in [0, 3, 6] {
      if squares[index] != nil && squares[index] == squares[index+1] && squares[index] == squares[index+2] {
        return squares[index]
      }
    }

    // verticals
    for index in 0...2 {
      if squares[index] != nil && squares[index] == squares[index+3] && squares[index] == squares[index+6] {
        return squares[index]
      }
    }

    // diagonals
    if squares[4] != nil &&
      (squares[4] == squares[0] && squares[4] == squares[8]) || (squares[4] == squares[2] && squares[4] == squares[6]) {
      return squares[4]
    }

    return nil
  }
}
