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

let clips = ArrayWithHistory([1, 2, 3])

struct State: Equatable {
  static func == (lhs: State, rhs: State) -> Bool {
    return true
  }
}

var state = Input<State>(State())

let d3 = clips.observe(current: { current in
  print("current: \(current)")
}, handleChange: { change in
  print("change: \(change)")
})

clips.change(.insert(4, at: 3))
