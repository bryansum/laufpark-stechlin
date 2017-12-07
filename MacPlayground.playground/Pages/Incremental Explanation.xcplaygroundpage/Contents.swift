import Incremental_Mac

var arr = ArrayWithHistory<Int>([1, 2, 3])

struct State: Equatable {
  var count: Int

  static func == (lhs: State, rhs: State) -> Bool {
    return lhs.count == rhs.count
  }
}

var state = Input<State>(State(count: 0))

let d = state.i.observe {
    print("state: \($0)")
}
let d2 = arr.observe(current: { current in
  print("current: \(current)")
}) { change in
  print("change: \(change)")
}
let count = state[\.count]
let d3 = count.observe {
  print("count: \($0)")
}

let i = arr.latest.flatMap { (_) -> I<Int> in
    print("flatMap")
    return count
}

print("1---")
i.observe { val in
    print("i: \(val)")
}
print("2---")
state.write(State(count: 1))
print("3---")
arr.change(.insert(0, at: 0))
print("4---")
