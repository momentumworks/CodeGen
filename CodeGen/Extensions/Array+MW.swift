//
// Created by Rheese Burgess on 15/03/2016.
// Copyright (c) 2016 Momentumworks. All rights reserved.
//

import Foundation

extension Array {
  // This little beauty was found here: http://stackoverflow.com/a/30593673/1842158
  subscript (safe index: Int) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
  
  @warn_unused_result
  func splitBy<Key: Hashable>(keyExtractor: Element -> [Key]) -> [Key: [Element]] {
    return reduce([Key: [Element]]()) { (acc: [Key: [Element]], type: Element) in
      var newAcc = acc
      keyExtractor(type).forEach { ext in
        if let oldValue = newAcc[ext] {
          newAcc[ext] = oldValue + type
        } else {
          newAcc[ext] = [type]
        }
      }
      return newAcc
    }
  }
  
  @warn_unused_result
  func splitBy<Key: Hashable>(keyExtractor: Element -> Key) -> [Key: Element] {
    return reduce([Key: Element]()) { acc, item in
      var newAcc = acc
      newAcc[keyExtractor(item)] = item
      return newAcc
    }
  }

  @warn_unused_result
  public func find(@noescape predicate: Element -> Bool) -> Element? {
    return self.lazy.filter(predicate).first
  }

  
}

public func +<T>(left: [T], right: T) -> [T] {
  var newArray = left
  newArray.append(right)
  return newArray
}

public func +<T>(left: [T], right: T?) -> [T] {
  guard let right = right else { return left }
  var newArray = left
  newArray.append(right)
  return newArray
}

public func +<T>(left: [T], right: [T]?) -> [T] {
  guard let right = right else { return left }
  return left + right
}

extension SequenceType where Generator.Element: Hashable {
  
  var unique: [Generator.Element] {
    var seen: Set<Generator.Element> = []
    return filter {
      if seen.contains($0) {
        return false
      } else {
        seen.insert($0)
        return true
      }
    }
  }
  
}


public extension CollectionType {
  
  var array: [Generator.Element] {
    return Array(self)
  }
  
}

public extension CollectionType where SubSequence : CollectionType, SubSequence.SubSequence == SubSequence, SubSequence.Generator.Element == Generator.Element, Index == Int {
  
  @warn_unused_result
  public func parallelMap<U>(transform: Self.Generator.Element -> U ) -> [U] {
    guard !self.isEmpty else { return Array() }
    
    let r = transform(self[self.startIndex])
    var results = Array<U>(count: self.count, repeatedValue:r)
    
    results.withUnsafeMutableBufferPointer { (inout buffer: UnsafeMutableBufferPointer<U>) -> UnsafeMutableBufferPointer<U> in
      dispatch_apply(self.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { index in
        buffer[index] = transform(self[index])
      })
      return buffer
    }
    
    return results
  }
  
}

