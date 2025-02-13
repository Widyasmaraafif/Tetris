import 'package:flutter/material.dart';
import 'package:tetris/board.dart';
import 'package:tetris/values.dart';

class Piece {
  // Type oof tetris piece
  Tetromino type;

  Piece({required this.type});

  // The piece is just a list of integer
  List<int> position = [];

  // COLOR OF TETRIS
  Color get color {
    return tetrominoColors[type] ?? const Color(0xFFFFFFFF);
  }

  // generate the integers
  void initializedPiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetromino.J:
        position = [-25, -15, -5, -4];
        break;
      case Tetromino.I:
        position = [-4, -5, -6, -7];
        break;
      case Tetromino.O:
        position = [-15, -16, -5, -6];
        break;
      case Tetromino.S:
        position = [-15, -14, -4, -5];
        break;
      case Tetromino.Z:
        position = [-17, -16, -6, -5];
        break;
      case Tetromino.T:
        position = [-26, -16, -6, -15];
        break;
      default:
    }
  }

  // Move piece
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }

  // rotate pieces
  int rotationState = 1;
  void rotatePiece() {
    // new position
    List<int> newPosition = [];
    // rotate based on type
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength, // atas
              position[1], // tengah
              position[1] + rowLength, // bawah
              position[1] + rowLength + 1, // sudut kanan bawah
            ];
            break;
          case 1:
            newPosition = [
              position[1] - 1, // kiri
              position[1], // tengah
              position[1] + 1, // kanan
              position[1] + rowLength - 1, // sudut kiri bawah
            ];
            break;
          case 2:
            newPosition = [
              position[1] + rowLength, // bawah
              position[1], // tengah
              position[1] - rowLength, // atas
              position[1] - rowLength - 1, // sudut kiri atas
            ];
            break;
          case 3:
            newPosition = [
              position[1] - rowLength + 1, // sudut kanan atas
              position[1], // tengah
              position[1] + 1, // kanan
              position[1] - 1, // kiri
            ];
            break;
        }

        if (piecePositionIsValid(newPosition)) {
          position = newPosition;
          rotationState = (rotationState + 1) % 4;
        }
        break;

      case Tetromino.J:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength, // atas
              position[1], // tengah
              position[1] + rowLength, // bawah
              position[1] + rowLength - 1, // sudut kanan bawah
            ];
            break;
          case 1:
            newPosition = [
              position[1] - 1, // kiri
              position[1], // tengah
              position[1] + 1, // kanan
              position[1] - rowLength - 1, // sudut kiri bawah
            ];
            break;
          case 2:
            newPosition = [
              position[1] + rowLength, // bawah
              position[1], // tengah
              position[1] - rowLength, // atas
              position[1] - rowLength + 1, // sudut kiri atas
            ];
            break;
          case 3:
            newPosition = [
              position[1] + rowLength + 1, // sudut kanan atas
              position[1], // tengah
              position[1] + 1, // kanan
              position[1] - 1, // kiri
            ];
            break;
        }

        if (piecePositionIsValid(newPosition)) {
          position = newPosition;
          rotationState = (rotationState + 1) % 4;
        }
        break;

      case Tetromino.I:
        switch (rotationState) {
          case 0:
            /*
              
            0 0 0 0
            
            */
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
              
            0
            0
            0
            0
            
            */
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
              
            0 0 0 0
            
            */
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*
              
            0
            0
            0
            0
            
            */
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - 2 * rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
      case Tetromino.O:
        // no rotation
        break;
      case Tetromino.S:
        switch (rotationState) {
          case 0:
            /*
              
              0 0
            0 0

            */
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
              
            0
            0 0
              0
            
            */
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
              
            0 0
          0 0
            
            */
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*
              
          0
          0 0
            0
            
            */
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            /*
              
            0 0
              0 0

            */
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
              
              0
            0 0 
            0

            */
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
              
        0 0
          0 0
            
            */
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*

            0
          0 0
          0 
            
            */
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength,
              position[3] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
      case Tetromino.T:
        switch (rotationState) {
          case 0:
            /*
              
            0
            0 0
            0

            */
            newPosition = [
              position[2] - rowLength,
              position[2],
              position[2] + 1,
              position[2] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
              
            0 0 0
              0

            */
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] - rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
            
              0
            0 0
              0

            */
            newPosition = [
              position[1] - rowLength,
              position[1] - 1,
              position[1],
              position[1] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*

              0
            0 0 0
            
            */
            newPosition = [
              position[2] - rowLength,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
      default:
    }
  }

  // check if valid position
  bool positionIsValid(int position) {
    // get the row and col of position
    int row = (position / rowLength).floor();
    int col = position % rowLength;

    // if the position is taken, return false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    } else {
      return true;
    }
  }

  // check if pisse is valid position
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePosition) {
      // return false if any positiopn is already taken
      if (!positionIsValid(pos)) {
        return false;
      }

      // get the col of position
      int col = pos % rowLength;

      // check if the first or last column is occupied
      if (col == 0) {
        firstColOccupied = true;
      }
      if (col == rowLength - 1) {
        lastColOccupied = true;
      }
    }
    // if there is a pplace in the first col and last col, it is going through the wall
    return !(firstColOccupied && lastColOccupied);
  }
}
