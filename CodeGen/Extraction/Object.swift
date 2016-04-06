//
// Created by Rheese Burgess on 15/03/2016.
// Copyright (c) 2016 Momentumworks. All rights reserved.
//

import Foundation

public typealias Extension = String
public typealias Name = String
public typealias SourceString = String
public typealias Import = String
public typealias Kind = String

@objc public class Type: NSObject {
  public let accessibility : Accessibility?
  public let name : Name
  public let fields : [Field]
  public let extensions : [Extension]
  public let kind: Kind

  public init(accessibility: Accessibility?, name: Name, fields: [Field], extensions: [Extension], kind: Kind) {
    self.accessibility = accessibility
    self.name = name
    self.fields = fields
    self.extensions = extensions
    self.kind = kind
  }

  public func set(accessibility accessibility: Accessibility) -> Type {
    return Type(accessibility: accessibility, name: name, fields: fields, extensions: extensions, kind: kind)
  }

  public func set(fields fields: [Field]) -> Type {
    return Type(accessibility: accessibility, name: name, fields: fields, extensions: extensions, kind: kind)
  }

  public func appendExtensions(extensions: [Extension]) -> Type {
    return Type(accessibility: accessibility, name: name, fields: fields, extensions: self.extensions + extensions, kind: kind)
  }

  public func mergeWith(otherObj: Type) -> Type {
    guard otherObj.name == name else {
      return self
    }

    let accessibility = self.accessibility ?? otherObj.accessibility
    let fields = self.fields + otherObj.fields
    let extensions = self.extensions + otherObj.extensions

    return Type(accessibility: accessibility, name: name, fields: fields, extensions: extensions, kind: kind)
  }
}

@objc public class Field: NSObject {
  public let accessibility : String
  public let name : String
  public let type : String
    
  public init(accessibility: Accessibility, name: String, type: String) {
    self.accessibility = accessibility.description
    self.name = name
    self.type = type
  }
}

public enum Accessibility : String, CustomStringConvertible {
  case Private = "source.lang.swift.accessibility.private"
  case Internal = "source.lang.swift.accessibility.internal"
  case Public = "source.lang.swift.accessibility.public"

  public var description : String {
    switch self {
    case Private: return "private"
    case Internal: return ""
    case Public: return "public"
    }
  }
}
