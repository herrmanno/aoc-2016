import "dart:io";
//import "dart:async";


class Display {
  static final WIDTH = 50;
  static final HEIGHT = 6;
  
  final List<bool> display = new List(WIDTH * HEIGHT);

  Display() {
    for(var r = 0; r < HEIGHT; r++) {
      for(var c = 0; c < WIDTH; c++) {
        setAt(r, c, false);
      }
    }
  }
  
  getAt(int row, int col) {
    return display[row * WIDTH + col];
  }

  setAt(int row, int col, bool val) {
    try {
      display[row * WIDTH + col] = val;
    } catch(e) {
      print(e);
    }
  }

  rect(int width, int height) {
    for(var r = 0; r < height; r++) {
      for(var c = 0; c < width; c++) {
        setAt(r, c, true);
      }   
    }
  }

  rotateCol(int col, int by) {
    by %= HEIGHT;

    var colArr = new List<bool>();
    for(var r = 0; r < HEIGHT; r++) {
      colArr.add(this.getAt(r, col));
    }

    for(var b = 0; b < by; b++) {
      colArr.insert(0, colArr.removeLast());
    }

    for(var r = 0; r < HEIGHT; r++) {
      this.setAt(r, col, colArr[r]);
    }

  }

  rotateRow(int row, int by) {
    by %= WIDTH;

    var rowArr = new List<bool>();
    for(var c = 0; c < WIDTH; c++) {
      rowArr.add(this.getAt(row, c));
    }

    for(var b = 0; b < by; b++) {
      rowArr.insert(0, rowArr.removeLast());
    }

    for(var c = 0; c < WIDTH; c++) {
      this.setAt(row, c, rowArr[c]);
    }

  }

  getLightCount() {
    int count = 0;
    display.forEach((b) {
      count += b ? 1 : 0;
    });
    return count;
  }

}


main(List<String> args) {
  Display display = new Display();

  var file = new File(args[0]);
  var lines = file.readAsLinesSync();
  
  for(var line in lines) {
    var parts = line.split(" ");
    
    switch(parts.removeAt(0)) {
      case "rect":
        var wh = parts[0].split("x"); //return width, height
        var w = int.parse(wh[0]);
        var h = int.parse(wh[1]);
        display.rect(w, h);
        break;
      case "rotate":
        switch (parts.removeAt(0)) {
          case "row":
            var y = int.parse(parts[0].split("=")[1]);
            var by = int.parse(parts[2]);
            display.rotateRow(y, by);
            break;
          case "column":
            var x = int.parse(parts[0].split("=")[1]);
            var by = int.parse(parts[2]);
            display.rotateCol(x, by);
            break;
        }
      break;
    }

  }

  print("There are ${display.getLightCount()} lights on.");

}