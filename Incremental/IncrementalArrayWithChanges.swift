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

    public init(_ initial: [A] = [], _ changes: [ArrayChange<A>]) {
        self.initial = initial
        self.changes = changes
        latest = changes.reduce(into: initial) { (r, change) in
            r.apply(change)
        }
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
    public func map<B, C>(_ transform: @escaping (B) -> C) -> I<ArrayWithChanges<C>> where A == ArrayWithChanges<B> {
        return map(eq: ==, transform)
    }

    public func map<B, C>(eq: @escaping (ArrayWithChanges<C>, ArrayWithChanges<C>) -> Bool, _ transform: @escaping (B) -> C) -> I<ArrayWithChanges<C>> where A == ArrayWithChanges<B> {
        let result = I<ArrayWithChanges<C>>(eq: eq)
        let reader = MapReader(source: self, transform: { arr in
            ArrayWithChanges(arr.initial.map(transform),
                             arr.changes.map { change in
                                switch change {
                                case let .insert(el, at: i):
                                    return .insert(transform(el), at: i)
                                case let .remove(at: i):
                                    return .remove(at: i)
                                case let .replace(with: el, at: i):
                                    return .replace(with: transform(el), at: i)
                                case let .move(at: i, to: j):
                                    return .move(at: i, to: j)
                                }
            })
        }, target: result)
        result.strongReferences.add(addReader(reader))
        return result
    }

    public func observe<B>(current: ([B]) -> (), handleChange: @escaping (ArrayChange<B>) -> ()) -> Disposable where A == ArrayWithChanges<B> {
        precondition(value != nil, "Must have an initial value")
        current(value.latest)
        var changes = value.changes
        return observe { arr in
            print("_observerFire3")
            print("_value.changes: \(self.value.latest), \(self.value.changes)")
            print("_handleChange: \(arr.latest), \(arr.changes)")
            for change in arr.changes[changes.count...] {
                print("_handleChange: \(change)")
                handleChange(change)
            }
            changes = arr.changes
        }
    }
}
