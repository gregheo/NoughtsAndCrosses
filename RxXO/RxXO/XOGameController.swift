//
//  XOGameController.swift
//  RxXO
//
//  Copyright © 2017 Greg Heo. All rights reserved.
//

import Foundation
import RxSwift

class XOGameController {
  private var moves: Observable<Int>

  private var currentPlayer = XOPlayer.cross
  private var squares: [XOPlayer?] = Array(repeating: nil, count: 9)

  private var gameObservable: Observable<XOSingleMove?>!

  var moveCount: Int {
    return squares.reduce(0, { (a, p) in a + (p == nil ? 0 : 1) })
  }

  init(moves: Observable<Int>) {
    self.moves = moves

    /// Observable that maps the incoming stream of moves to a stream of XOSingleMove objects.
    /// Nil means it was an invalid move.
    self.gameObservable = moves
      .map { square in
        guard square >= 0 && square < self.squares.count else {
          // out of bounds
          return nil
        }

        guard self.squares[square] == nil else {
          // square is already occupied
          return nil
        }

        let move = XOSingleMove(player: self.currentPlayer, square: square)
        self.playTurn(square: square)

        return move
      }
      .share()
  }

  /// Observable of results from each move.
  var resultObservable: Observable<XOMoveResult> {
    return gameObservable
      .map { [unowned self] singleMove in
        guard singleMove != nil else {
          // invalid move
          return .invalid(nextPlayer: self.currentPlayer)
        }

        // winner?
        if let winner = self.winner {
          return XOMoveResult.win(winningPlayer: winner)
        }

        // draw?
        if self.moveCount == self.squares.count {
          return XOMoveResult.draw
        }

        return XOMoveResult.success(nextPlayer: self.currentPlayer)
      }
  }

  /// Observable of all valid moves.
  var moveObservable: Observable<XOSingleMove> {
    return gameObservable.unwrap()
  }

  private func playTurn(square: Int) {
    squares[square] = currentPlayer
    currentPlayer = currentPlayer.next
  }

  private var winner: XOPlayer? {
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
