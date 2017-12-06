import Incremental_Mac

struct ArrayWithChanges<A: Equatable>: Equatable, CustomDebugStringConvertible, ExpressibleByArrayLiteral {
  typealias ArrayLiteralElement = A

  let initial: [A]
  var changes: [ArrayChange<A>]
  var latest: [A]

  init(arrayLiteral elements: A...) {
    self.init(elements)
  }

  init(_ value: [A] = []) {
    initial = value
    changes = []
    latest = value
  }

  static func == (lhs: ArrayWithChanges<A>, rhs: ArrayWithChanges<A>) -> Bool {
    return lhs.latest == rhs.latest
  }

  mutating func append(value: A) {
    change(.insert(value, at: latest.count))
  }

  mutating func mutate(at index: Int, transform: (inout A) -> ()) {
    var value = latest[index]
    transform(&value)
    if latest[index] != value {
      change(.replace(with: value, at: index))
    }
  }

  mutating func change(_ change: ArrayChange<A>) {
    changes.append(change)
    latest.apply(change)
  }

  public var debugDescription: String {
    return "ArrayWithChanges(\(latest))"
  }
}

extension I {
  func observe<B>(current: ([B]) -> (), handleChange: @escaping (ArrayChange<B>) -> ()) -> Disposable where A == ArrayWithChanges<B> {
    current(value.latest)
    var changes = value.changes
    return observe { arr in
      for change in arr.changes[changes.count...] {
        handleChange(change)
      }
      changes = arr.changes
    }
  }
}

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

