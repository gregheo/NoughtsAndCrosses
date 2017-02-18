//
//  XOEnums.swift
//  RxXO
//
//  Copyright © 2017 Greg Heo. All rights reserved.
//

import Foundation

enum XOPlayer: String {
  case nought
  case cross

  var next: XOPlayer {
    return self == .cross ? .nought : .cross
  }
}

enum XOMoveResult: Equatable {
  case success(nextPlayer: XOPlayer)
  case invalid(nextPlayer: XOPlayer)

  case win(winningPlayer: XOPlayer)
  case draw
}

func ==(lhs: XOMoveResult, rhs: XOMoveResult) -> Bool {
  switch (lhs, rhs) {
  case (let .success(l), let .success(r)):
    return l == r
  case (let .invalid(l), let .invalid(r)):
    return l == r
  case (let .win(l), let .win(r)):
    return l == r
  case (.draw, .draw):
    return true
  default:
    return false
  }
}

struct XOSingleMove: Equatable {
  let player: XOPlayer
  let square: Int
}

func ==(lhs: XOSingleMove, rhs: XOSingleMove) -> Bool {
  return lhs.player == rhs.player && lhs.square == rhs.square
}
