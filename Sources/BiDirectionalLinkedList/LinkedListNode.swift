/*****************************************************************************************************************************//**
 *     PROJECT: BiDirectionalLinkedList
 *    FILENAME: LinkedListNode.swift
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

@usableFromInline class LinkedListNode<T> {
    @usableFromInline var nextNode: LinkedListNode<T>? = nil
    @usableFromInline var prevNode: LinkedListNode<T>? = nil
    @usableFromInline let value:    T

    @usableFromInline init(value: T) { self.value = value }

    @usableFromInline required init(from decoder: Decoder) throws where T: Codable {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        value = try c.decode(T.self, forKey: .value)
    }
}

extension LinkedListNode: Codable where T: Codable {

    enum CodingKeys: String, CodingKey { case value }

    @usableFromInline func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(value, forKey: .value)
    }
}
