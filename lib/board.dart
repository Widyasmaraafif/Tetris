import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/values.dart';

List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L);

  int currentScore = 0;

  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    // start game when app starts
    startGame();
  }

  void startGame() {
    currentPiece.initializedPiece();

    // Frame refresh rate
    Duration frameRate = const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  // game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      if (gameOver) {
            timer.cancel();
            return;
        }
      setState(() {
        // clear lines
        clearLines();
        // Check landing
        checkLanding();

        if (gameOver == true) {
          timer.cancel();
          showGameOverDialog();
        }
        // Move current piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  // game over masage
  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text("Your score is: $currentScore"),
        actions: [
          TextButton(
              onPressed: () {
                resetGame();
                Navigator.pop(context);
              },
              child: Text('Play again'))
        ],
      ),
    );
  }

  void resetGame() {
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );
    // new game
    gameOver = false;
    currentScore = 0;
    // new piece
    createNewPiece();
    startGame();
  }

  // check collision
  // return true if collision
  // return false if no collision
  bool checkCollision(Direction direction) {
    // loop through each position of the piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and column of the current postion
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // check if the piece is out of bounds (either too low or too far to the left or right)
      if (row >= colLength || col < 0 || col >= rowLength || (row >= 0 && gameBoard[row][col] != null)) {
        return true;
      }
    }
    // if no collision
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      // mark position as occu[ied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    // create random object generated
    Random rand = Random();

    // create a piece with randomtype
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializedPiece();
    if (isGameOver()) {
      gameOver = true;
    }
  }

  // move left
  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  // move right
  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  // rotate
  void rotatePiece() {
    currentPiece.rotatePiece();
  }

  // clear lines
  void clearLines() async {
    for (int row = colLength - 1; row >= 0; row--) {
        bool rowIsFull = true;
        for (int col = 0; col < rowLength; col++) {
            if (gameBoard[row][col] == null) {
                rowIsFull = false;
                break;
            }
        }

        if (rowIsFull) {
            // Efek putih sebentar
            setState(() {
                for (int col = 0; col < rowLength; col++) {
                    gameBoard[row][col] = Tetromino.O; // Warna putih sementara
                }
            });
            await Future.delayed(Duration(milliseconds: 200));

            // Geser semua baris ke bawah
            for (int r = row; r > 0; r--) {
                gameBoard[r] = List.from(gameBoard[r - 1]);
            }
            gameBoard[0] = List.generate(rowLength, (index) => null);
            currentScore++;
        }
    }
}


  // game over
  bool isGameOver() {
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Game Grid
          Expanded(
            child: GridView.builder(
              itemCount: rowLength * colLength,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength,
              ),
              itemBuilder: (context, index) {
                // get row of each index
                int row = (index / rowLength).floor();
                int col = index % rowLength;

                // current piece
                if (currentPiece.position.contains(index)) {
                  return Pixel(
                    color: Colors.yellow,
                  );
                }
                // landed pieces
                else if (gameBoard[row][col] != null) {
                  final Tetromino? tetrominoType = gameBoard[row][col];
                  return Pixel(
                      color: tetrominoColors[tetrominoType]);
                }
                // blank pixel
                else {
                  return Pixel(
                    color: Colors.grey[900],
                  );
                }
              },
            ),
          ),

          // Score
          Text(
            'Score: $currentScore',
            style: TextStyle(color: Colors.white),
          ),
          // Game Control
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Left
                IconButton(
                  onPressed: moveLeft,
                  icon: Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
                // rotate
                IconButton(
                  onPressed: rotatePiece,
                  icon: Icon(
                    Icons.rotate_right,
                  ),
                ),
                // right
                IconButton(
                  onPressed: moveRight,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
