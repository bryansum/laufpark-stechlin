import Incremental_Mac

struct State: Equatable {
  var arr: ArrayWithChanges<Int>
  var count: Int

  static func == (lhs: State, rhs: State) -> Bool {
    return lhs.arr == rhs.arr
  }
}

var state = Input<State>(State(arr: [1, 2, 3], count: 0))

let d = state.i.observe {
    print("state: \($0)")
}
let arr = state[\.arr]
let d2 = arr.observe(current: { current in
  print("current: \(current)")
}) { change in
  print("change: \(change)")
}
let d3 = state[\.count].observe {
  print("count: \($0)")
}

state.change { $0.arr.change(.insert(4, at: 3)) }
state.change {
  $0.count = 2
  $0.arr.change(.insert(5, at: 4))
}
