//
//  RxXOTests.swift
//  RxXOTests
//
//  Copyright © 2017 Greg Heo. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking

class RxXOTests: XCTestCase {
  let disposeBag = DisposeBag()

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testMoves() {
    let game = XOGameController(moves: Observable.from([2, 2, 3, 4, 2, 5]))
    let result = try! game.moveObservable.toBlocking().toArray()
    let expected: [XOSingleMove] = [
      XOSingleMove(player: .cross, square: 2),
      XOSingleMove(player: .nought, square: 3),
      XOSingleMove(player: .cross, square: 4),
      XOSingleMove(player: .nought, square: 5)
      ]

    XCTAssertEqual(result, expected, "Test winning game")
  }

  func testWin() {
    let game = XOGameController(moves: Observable.from([0, 1, 2, 3, 4, 5, 6]))
    let result = try! game.resultObservable.toBlocking().toArray()
    let expected: [XOMoveResult] = [.success(nextPlayer: .nought), .success(nextPlayer: .cross), .success(nextPlayer: .nought), .success(nextPlayer: .cross), .success(nextPlayer: .nought), .success(nextPlayer: .cross), .win(winningPlayer: .cross)]

    XCTAssertEqual(result, expected, "Test winning game")
  }

  func testDraw() {
    let game = XOGameController(moves: Observable.from([0, 1, 3, 6, 4, 5, 2, 8, 7]))
    let result = try! game.resultObservable.toBlocking().toArray()
    let expected: [XOMoveResult] = [.success(nextPlayer: .nought), .success(nextPlayer: .cross), .success(nextPlayer: .nought), .success(nextPlayer: .cross), .success(nextPlayer: .nought), .success(nextPlayer: .cross), .success(nextPlayer: .nought), .success(nextPlayer: .cross), .draw]

    XCTAssertEqual(result, expected, "Test draw game")
  }

  func testOutOfBoundsMoveMax() {
    let game = XOGameController(moves: Observable.from([4, 9]))
    let result = try! game.resultObservable.toBlocking().toArray()
    let expected: [XOMoveResult] = [.success(nextPlayer: .nought), .invalid(nextPlayer: .nought)]

    XCTAssertEqual(result, expected, "Test move to out-of-bounds square")
  }

  func testOutOfBoundsMoveMin() {
    let game = XOGameController(moves: Observable.from([0, -1]))
    let result = try! game.resultObservable.toBlocking().toArray()
    let expected: [XOMoveResult] = [.success(nextPlayer: .nought), .invalid(nextPlayer: .nought)]

    XCTAssertEqual(result, expected, "Test move to out-of-bounds square")
  }

  func testInvalidMove() {
    let game = XOGameController(moves: Observable.from([3, 3]))
    let result = try! game.resultObservable.toBlocking().toArray()
    let expected: [XOMoveResult] = [.success(nextPlayer: .nought), .invalid(nextPlayer: .nought)]

    XCTAssertEqual(result, expected, "Test move to already-occupied square")
  }

  func testValidMoves() {
    let game = XOGameController(moves: Observable.from([0, 1, 2]))
    let result = try! game.resultObservable.toBlocking().toArray()
    let expected: [XOMoveResult] = [.success(nextPlayer: .nought), .success(nextPlayer: .cross), .success(nextPlayer: .nought)]

    XCTAssertEqual(result, expected, "Test successful moves")
  }
}
