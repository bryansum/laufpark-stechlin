import Incremental_Mac

let arr: ArrayWithHistory<Int> = [1, 2, 3]

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
let arr = state.i.value.arr
let d2 = arr.observe(current: { current in
  print("current: \(current)")
}) { change in
  print("change: \(change)")
}
let count = state[\.count]
let d3 = count.observe {
  print("count: \($0)")
}

let i = state.dependsOn(arr)

let i = arr.latest.map { (val) -> Int in
    state.change {
        $0.count = val.count
    }
    return val.count
}

print("1---")
i.observe { val in
    print("i: \(val)")
}
print("3---")
arr.change(.insert(0, at: 0))
print("4---")
