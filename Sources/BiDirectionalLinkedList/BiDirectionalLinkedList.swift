/*****************************************************************************************************************************//**
 *     PROJECT: BiDirectionalLinkedList
 *    FILENAME: BiDirectionalLinkedList.swift
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: August 16, 2021
 *
  * Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided
 * that the above copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
 * NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *//*****************************************************************************************************************************/

import Foundation
import CoreFoundation

open class BiDirectionalLinkedList<Element>: Sequence, ExpressibleByArrayLiteral {

    @usableFromInline var firstNode: LinkedListNode<Element>? = nil
    @usableFromInline var lastNode:  LinkedListNode<Element>? = nil

    public init() {}

    public init<S>(contentsOf seq: S) where S: Sequence, Element == S.Element { for e: Element in seq { append(e) } }

    public convenience required init(arrayLiteral elements: Element...) { self.init(contentsOf: elements) }

    public required init(from decoder: Decoder) throws where Element: Codable {
        var c = try decoder.unkeyedContainer()
        if !c.isAtEnd {
            var pNode = try c.decode(LinkedListNode<Element>.self)
            firstNode = pNode

            while !c.isAtEnd {
                let node = try c.decode(LinkedListNode<Element>.self)
                pNode.nextNode = node
                node.prevNode = pNode
                pNode = node
            }

            lastNode = pNode
        }
    }

    open func append(_ e: Element) {
        if let n = lastNode {
            let nn = LinkedListNode<Element>(value: e)
            lastNode = nn
            n.nextNode = nn
            nn.prevNode = n
        }
        else {
            lastNode = LinkedListNode<Element>(value: e)
            firstNode = lastNode
        }
    }

    open func prepend(_ e: Element) {
        if let n = firstNode {
            let nn = LinkedListNode<Element>(value: e)
            firstNode = nn
            n.prevNode = nn
            nn.nextNode = n
        }
        else {
            firstNode = LinkedListNode<Element>(value: e)
            lastNode = firstNode
        }
    }

    open func removeAll() {
        forEachNode(reverse: false) {
            $0.nextNode = nil
            $0.prevNode = nil
        }
        firstNode = nil
        lastNode = nil
    }

    @usableFromInline func node(reverse: Bool, where predicate: (LinkedListNode<Element>) throws -> Bool) rethrows -> LinkedListNode<Element>? {
        var _n = (reverse ? lastNode : firstNode)
        while let n = _n {
            _n = (reverse ? n.prevNode : n.nextNode)
            if try predicate(n) { return n }
        }
        return nil
    }

    @discardableResult @usableFromInline func removeNode(node: LinkedListNode<Element>) -> Element {
        let prev = node.prevNode
        let next = node.nextNode
        if node === firstNode { firstNode = next }
        if node === lastNode { lastNode = prev }
        if let nx = next { nx.prevNode = prev }
        if let pv = prev { pv.nextNode = next }
        node.prevNode = nil
        node.nextNode = nil
        return node.value
    }

    @frozen public struct Iterator: IteratorProtocol {

        @usableFromInline let reverse: Bool
        @usableFromInline var node:    LinkedListNode<Element>?

        @inlinable init(reverse: Bool = false, firstNode: LinkedListNode<Element>?) {
            node = firstNode
            self.reverse = reverse
        }

        @inlinable public mutating func next() -> Element? {
            guard let n = node else { return nil }
            node = (reverse ? n.prevNode : n.nextNode)
            return n.value
        }
    }
}

extension BiDirectionalLinkedList {

    @inlinable public var first: Element? { firstNode?.value }
    @inlinable public var last:  Element? { lastNode?.value }

    @inlinable func forEachNode(reverse: Bool, _ body: (LinkedListNode<Element>) throws -> Void) rethrows { _ = try node(reverse: reverse) { try body($0); return false } }

    @inlinable public func push(_ e: Element) { append(e) }

    @inlinable public func queue(_ e: Element) { prepend(e) }

    @inlinable public func pop() -> Element? { popLast() }

    @inlinable public func dequeue() -> Element? { popFirst() }

    @inlinable public func forEach(reverse: Bool, _ body: (Element) throws -> Void) rethrows { try forEachNode(reverse: reverse) { n in try body(n.value) } }

    @inlinable public func forEach(_ body: (Element) throws -> Void) rethrows { try forEach(reverse: false, body) }

    @inlinable public func first(where predicate: (Element) throws -> Bool) rethrows -> Element? { try node(reverse: false, where: { try predicate($0.value) })?.value }

    @inlinable public func last(where predicate: (Element) throws -> Bool) rethrows -> Element? { try node(reverse: true, where: { try predicate($0.value) })?.value }

    @inlinable public func dropLast(_ k: Int = 1) -> [Element] {
        //@f:0
        var cc:  Int       = 0
        var arr: [Element] = []
        forEach(reverse: true) { if cc < k { cc += 1 } else { arr.insert($0, at: 0) } }
        return arr
        //@f:1
    }

    @inlinable public func removeFirst() -> Element {
        guard let n = firstNode else { fatalError("No first node.") }
        return removeNode(node: n)
    }

    @inlinable public func removeLast() -> Element {
        guard let n = lastNode else { fatalError("No last node.") }
        return removeNode(node: n)
    }

    @inlinable public func removeFirst(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        guard let n = try node(reverse: false, where: { node in try predicate(node.value) }) else { return nil }
        return removeNode(node: n)
    }

    @inlinable public func removeLast(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        guard let n = try node(reverse: true, where: { node in try predicate(node.value) }) else { return nil }
        return removeNode(node: n)
    }

    @inlinable public func popFirst() -> Element? {
        guard let n = firstNode else { return nil }
        return removeNode(node: n)
    }

    @inlinable public func popLast() -> Element? {
        guard let n = lastNode else { return nil }
        return removeNode(node: n)
    }

    @inlinable public func removeFirst(_ k: Int) {
        guard k > 0 else { fatalError("Invalid argument: \(k) <= 0") }
        for _ in (0 ..< k) { _ = popFirst() }
    }

    @inlinable public func removeLast(_ k: Int) {
        guard k > 0 else { fatalError("Invalid argument: \(k) <= 0") }
        for _ in (0 ..< k) { _ = popLast() }
    }

    @inlinable public func removeAll(where predicate: (Element) throws -> Bool) rethrows { try forEachNode(reverse: false) { n in if try predicate(n.value) { removeNode(node: n) } } }

    @inlinable public func makeIterator(reverse: Bool) -> Iterator { Iterator(reverse: reverse, firstNode: reverse ? lastNode : firstNode) }

    @inlinable public func makeIterator() -> Iterator { Iterator(firstNode: firstNode) }
}

extension BiDirectionalLinkedList: Codable where Element: Codable {
    public func encode(to encoder: Encoder) throws {
        var c = encoder.unkeyedContainer()
        try forEachNode(reverse: false) { try c.encode($0) }
    }
}
