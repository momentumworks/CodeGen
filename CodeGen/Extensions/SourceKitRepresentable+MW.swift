//
//  SourceKitRepresentable+MW.swift
//  CodeGen
//
//  Created by Mark Aron Szulyovszky on 27/05/2016.
//  Copyright © 2016 Momentumworks. All rights reserved.
//

import Foundation
import SourceKittenFramework

extension SourceKitRepresentable {
  
  var asDictionary: [String: SourceKitRepresentable]? {
    return self as? [String: SourceKitRepresentable]
  }
  
  var asArray: [SourceKitRepresentable]? {
    return self as? [SourceKitRepresentable]
  }
  
  var substructures: [SourceKitRepresentable]? {
    return self.asDictionary?["key.substructure"] as? [SourceKitRepresentable]
  }
  
  var entities: [SourceKitRepresentable]? {
    return self.asDictionary?["key.entities"] as? [SourceKitRepresentable]
  }
  
  var dependencies: [SourceKitRepresentable]? {
    return self.asDictionary?["key.dependencies"] as? [SourceKitRepresentable]
  }
  
  var name: Name? {
    return self.asDictionary?["key.name"] as? Name
  }
  
  var kind: String? {
    return self.asDictionary?["key.kind"] as? String
  }
  
  var typeName: Name? {
    return self.asDictionary?["key.typename"] as? Name
  }
  
  
  var accessibility: Accessibility? {
    guard let string = self.asDictionary?["key.accessibility"] as? String else { return nil }
    return Accessibility(rawValue: string)
  }
  
  var inheritedTypes: [SourceKitRepresentable]? {
    return self.asDictionary?["key.inheritedtypes"] as? [SourceKitRepresentable] ?? []
  }
  
}