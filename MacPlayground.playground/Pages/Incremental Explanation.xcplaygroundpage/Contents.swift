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

  mutating func change(_ change: ArrayChange<A>) {
    changes.append(change)
    latest.apply(change)
  }

  public var debugDescription: String {
    return "ArrayWithChanges(\(latest))"
  }
}

struct State: Equatable {
  let arr: ArrayWithChanges<Int>

  static func == (lhs: State, rhs: State) -> Bool {
    return lhs.arr == rhs.arr
  }
}

var state = Input<State>(State(arr: [1, 2, 3]))

var arr: ArrayWithHistory<Int> = ArrayWithHistory(state.i.value.arr.latest)
let condition = Input<(Int) -> Bool>(alwaysPropagate: { $0 % 2 == 0 })
let result: ArrayWithHistory<Int> = arr.filter(condition.i)
let disposable2 = result.latest.observe {
    print("filtered: \($0)")
}
print("1---")
arr.change(.insert(4, at: 3))
print("2---")
condition.write { $0 > 1 }
print("3---")
arr.change(.insert(6, at: 3))
arr.change(.insert(5, at: 3))
condition.write { $0 > 3 }
condition.write { $0 > 0 }
arr.change(.remove(at: 4))
