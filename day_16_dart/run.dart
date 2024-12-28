import 'dart:io';
import 'dart:math';

class Bot {
  static final DIRS = [(0, -1), (1, 0), (0, 1), (-1, 0)], BOARD = <List<bool>>[], VALID = <(int, int)>{}, BOTS = <Bot>[], VISITED = <(int, int, int)>{};
  static var DEST = (x: 0, y: 0), MIN_WAIT = 0, MIN_WAIT_CURRENT = 0;
  int x, y, wait, steps;
  final int dx, dy, dir;
  final Set<(int, int)> prev;
  Bot(this.x, this.y, this.dx, this.dy, this.dir, this.wait, this.prev, this.steps);

  (int, List<Bot>?) tick() {
    var nextBot = null;
    if (this.wait > 1) this.wait -= MIN_WAIT > 1 ? (MIN_WAIT - 1) : 1;
    else if (this.x == DEST.x && this.y == DEST.y) {
      this.prev.forEach((c) => VALID.add(c));
      return (this.steps, null);
    } else {
      nextBot = <Bot>[];
      if (!this.prev.contains((this.x, this.y))) {
        this.prev.add((this.x, this.y));
        VISITED.add((this.x, this.y, this.dir));
        var (dx1, dy1) = DIRS[(this.dir + 1) & 3];
        if (BOARD[this.y + dy1][this.x + dx1]) nextBot.add(Bot.new(this.x, this.y, dx1, dy1, (this.dir + 1) & 3, 1000, {...this.prev}, this.steps + 1000));
        var (dx2, dy2) = DIRS[(this.dir + 3) & 3];
        if (BOARD[this.y + dy2][this.x + dx2]) nextBot.add(Bot.new(this.x, this.y, dx2, dy2, (this.dir + 3) & 3, 1000, {...this.prev}, this.steps + 1000));
      }
      this.steps++;
      if (!BOARD[this.y += this.dy][this.x += this.dx] || this.prev.contains((this.x, this.y)) || VISITED.contains((this.x, this.y, this.dir))) return (1, nextBot);
    }
    MIN_WAIT_CURRENT = min(MIN_WAIT_CURRENT, this.wait);
    return (0, nextBot);
  }
}

void main() async {
  await File('in.txt').readAsString().then((f) => f.split("\n").forEach((s) => Bot.BOARD.add(s.runes.map((s) => s != 35).toList())));
  Bot.DEST = (x: Bot.BOARD[0].length - 2, y: 1);
  var stop = 0, pt = false, board = <String>[], hash = {};
  Bot.BOTS.add(Bot.new(1, Bot.BOARD.length - 2, 1, 0, 1, 1, {}, 0));
  while (stop <= 1) {
    Bot.MIN_WAIT_CURRENT = 1000;
    if (pt) {
      stdin.readLineSync();
      board = <String>[];
      hash = {};
    }
    var next = <Bot>[];
    if (pt) Bot.BOARD.forEach((el) {
      String s = "";
      el.forEach((el2) => s += el2 ? '.' : '#');
      board.add(s);
    });
    Bot.BOTS.removeWhere((bot) {
      if (pt) hash.update((x: bot.x, y: bot.y), (v) => "M", ifAbsent: () => ['^', '>', 'v', '<'][bot.dir]);
      var (i, nx) = bot.tick();
      if (nx != null) nx.forEach((n) => next.add(n));
      stop = max(stop, i);
      return i == 1;
    });
    next.forEach((n) => Bot.BOTS.add(n));
    if (pt) {
      hash.forEach((k, v) => board[k.y] = board[k.y].substring(0, k.x) + v + board[k.y].substring(k.x + 1));
      board.forEach((el) => print(el));
    }
    Bot.MIN_WAIT = Bot.MIN_WAIT_CURRENT;
  }
  print(stop);
  print(Bot.VALID.length + 1);
}