// Copyright: 2017, Bryan Summersett. All rights reserved.

public struct ArrayWithChanges<A: Equatable>: Equatable, CustomDebugStringConvertible, ExpressibleByArrayLiteral {
  public typealias ArrayLiteralElement = A

  let initial: [A]
  var changes: [ArrayChange<A>]
  var latest: [A]

  public init(arrayLiteral elements: A...) {
    self.init(elements)
  }

  public init(_ value: [A] = []) {
    initial = value
    changes = []
    latest = value
  }

  public static func == (lhs: ArrayWithChanges<A>, rhs: ArrayWithChanges<A>) -> Bool {
    return lhs.latest == rhs.latest
  }

  public mutating func append(value: A) {
    change(.insert(value, at: latest.count))
  }

  public mutating func mutate(at index: Int, transform: (inout A) -> ()) {
    var value = latest[index]
    transform(&value)
    if latest[index] != value {
      change(.replace(with: value, at: index))
    }
  }

  public mutating func change(_ change: ArrayChange<A>) {
    changes.append(change)
    latest.apply(change)
  }

  public var debugDescription: String {
    return "ArrayWithChanges(\(latest))"
  }
}

extension I {
  public func observe<B>(current: ([B]) -> (), handleChange: @escaping (ArrayChange<B>) -> ()) -> Disposable where A == ArrayWithChanges<B> {
    precondition(value != nil, "Must have an initial value")
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
