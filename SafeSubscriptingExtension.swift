//
//  SafeSubscriptingExtension.swift
//
//  Created by Shivanshu Verma on 23/03/24.
//

import Foundation

// MARK: - MutableCollection -
extension MutableCollection {
    /// Allows safe subscripting on a mutable collection with a safe index for both getting and setting elements.
    ///
    /// This extension enhances `MutableCollection` types by providing a safe subscripting mechanism for accessing and modifying elements using a specified index. It guards against out-of-bounds access, ensuring the safety and reliability of element retrieval and modification operations.
    ///
    /// Features:
    /// - **Safe Subscripting**: Accessing elements using the subscript ensures that only valid indices within the collection's bounds are accessed. If the provided index is outside the collection's bounds, `nil` is returned to indicate an invalid access attempt.
    /// - **Safe Element Modification**: The subscript also allows modifying elements at the specified index. If the provided index is valid, the element at that index is replaced with the provided new value. Otherwise, the modification operation is skipped to prevent out-of-bounds access.
    ///
    /// Usage:
    /// ```swift
    /// var array = [1, 2, 3, 4, 5]
    ///
    /// // Accessing elements safely
    /// let element = array[safe: 2] // Output: 3
    ///
    /// // Modifying an element safely
    /// array[safe: 2] = 10
    /// print(array) // Output: [1, 2, 10, 4, 5]
    /// ```
    ///
    /// This extension ensures safe and convenient manipulation of elements within a mutable collection, enhancing code reliability and readability.
    subscript(safe index: Index) -> Element? {
        get {
            /// Return the element at the specified index if it's within the collection's bounds, otherwise return nil
            return indices.contains(index) ? self[index] : nil
        }
        set(newValue) {
            /// If the provided index is within the collection's bounds and a new value is provided,
            /// set the element at the index to the new value
            guard indices.contains(index), let newValue = newValue else { return }
            self[index] = newValue
        }
    }
}

// MARK: - RangeReplaceableCollection -
extension RangeReplaceableCollection {
    /// Allows safe subscripting on a mutable collection with a safe range for both getting and setting elements.
    ///
    /// - Parameter safe: The range to access the elements safely.
    /// - Returns: The subrange of the collection that corresponds to the clamped range.
    ///            If the original range was entirely outside the bounds of the collection, an empty subsequence would be returned.
    ///
    /// This extension enhances `RangeReplaceableCollection` types, such as arrays, by providing a safe subscripting mechanism for both accessing and modifying elements within a specified range.
    ///
    /// Features:
    /// - **Safe Subscripting**: Accessing elements using the subscript ensures that only valid indices within the collection's bounds are accessed. If the provided range exceeds the collection's bounds, an empty subsequence is returned.
    /// - **Safe Element Modification**: The subscript also allows modifying elements within the specified range. If the range is valid, the elements within that range are replaced with the provided new values.
    ///
    /// Usage:
    /// ```swift
    /// var array = [1, 2, 3, 4, 5]
    ///
    /// // Accessing a safe subrange
    /// let subrange = array[safe: 1..<4] // Output: [2, 3, 4]
    ///
    /// // Modifying elements within a safe subrange
    /// array[safe: 1..<4] = [10, 20, 30]
    /// print(array)  // Output: [1, 10, 20, 30, 5]
    /// ```
    ///
    /// This extension ensures safe and convenient manipulation of elements within a collection's range, enhancing code reliability and readability.
    subscript<R: RangeExpression>(safe range: R) -> SubSequence where R.Bound == Index {
        get {
            /// Define the valid bounds of the collection.
            let collectionRange = startIndex..<endIndex
            /// Clamp the provided range to ensure it stays within the valid bounds.
            let clampedRange = range.relative(to: self).clamped(to: collectionRange)
            /// Return the subrange corresponding to the clamped range, ensuring safe access.
            /// If the original range lies entirely outside the collection's bounds, an empty subsequence is returned.
            return self[clampedRange]
        }
        set {
            /// Define the valid bounds of the collection.
            let collectionRange = startIndex..<endIndex
            /// Clamp the provided range to ensure it stays within the valid bounds.
            let clampedRange = range.relative(to: self).clamped(to: collectionRange)
            /// If the clamped range is not empty, indicating that it contains valid indices within the bounds of the collection, then replace the elements within that range with the provided new values.
            if clampedRange.isEmpty == false {
                replaceSubrange(clampedRange, with: newValue)
            }
        }
    }
}
