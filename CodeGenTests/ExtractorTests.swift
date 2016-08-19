//
//  ExtractorTests.swift
//  CodeGen
//
//  Created by Mark Aron Szulyovszky on 31/05/2016.
//  Copyright © 2016 Momentumworks. All rights reserved.
//

@testable import CodeGen
import Stencil

import PathKit

import Quick
import Nimble

class ExtractorTests: QuickSpec {

  override func spec() {
    describe("when extracting simple enums") {
      
      let file = Path( self.testBundle.pathForResource("SimpleEnum", ofType: "fixture")!)
      let metaData = SourceKittenExtractor().extractTypes([file]).groupBy { $0.name }
      
      it("should recognize its name & type") {
        expect(metaData["Anenum"]).toNot(beNil())
        expect(metaData["Anenum"]?.kind.isEnum).to(equal(true))
      }
      
      it("should recognize its cases") {
        let enumCases = [
          EnumCase(name: "One", associatedValues: []),
          EnumCase(name: "Two", associatedValues: []),
          EnumCase(name: "Three", associatedValues: [])
        ]
        expect(metaData["Anenum"]?.kind).to(equal(Kind.Enum(enumCases)))
      }
      
      it("should recognize its extensions") {
        let extensions: Set<Extension> = [
          "Protocol1",
          "Protocol2"
        ]
        expect(metaData["Anenum"]?.extensions).to(equal(extensions))
      }

    }
    
    describe("when extracting complex enums") {
      
      let file = Path( self.testBundle.pathForResource("ComplexEnum", ofType: "fixture")! )
      let metaData = SourceKittenExtractor().extractTypes([file]).groupBy { $0.name }
      
      it("should recognize its name & type") {
        expect(metaData["AComplexEnum"]).toNot(beNil())
        expect(metaData["AComplexEnum"]?.kind.isEnum).to(equal(true))
      }
      
      it("should recognize its cases") {
        let enumCases = [
          EnumCase(name: "One", associatedValues: [EnumAssociatedValue(name: "", type: "Int")]),
          EnumCase(name: "Two", associatedValues: [
            EnumAssociatedValue(name: "", type: "Int"),
            EnumAssociatedValue(name: "", type: "Int")]),
          EnumCase(name: "Three", associatedValues: [
            EnumAssociatedValue(name: "", type: "String"),
            EnumAssociatedValue(name: "", type: "Int"),
            EnumAssociatedValue(name: "", type: "String")]),
          EnumCase(name: "Four", associatedValues: [])
        ]
        expect(metaData["AComplexEnum"]?.kind).to(equal(Kind.Enum(enumCases)))
      }
      
      it("should recognize its extensions") {
        let extensions: Set<Extension> = [
          "Protocol1",
          "Protocol2",
          "Protocol3"
        ]
        expect(metaData["AComplexEnum"]?.extensions).to(equal(extensions))
      }
      
    }
    
    describe("when extracting complex nested types") {
      
      let file = Path( self.testBundle.pathForResource("NestedTypes", ofType: "fixture")!)
      let metaData = SourceKittenExtractor().extractTypes([file]).groupBy { $0.name }
      
      it("should recognize the parent type") {
        expect(metaData["Parent"]).toNot(beNil())
        expect(metaData["Parent"]?.kind.isClass).to(equal(true))
      }
      
      it("should recognize the nested type") {
        expect(metaData["Parent.Children"]).toNot(beNil())
        expect(metaData["Parent.Children"]?.kind.isStruct).to(equal(true))
      }
      
      it("should recognize the doubly nested type") {
        expect(metaData["Parent.Children.GrandChildren"]).toNot(beNil())
        expect(metaData["Parent.Children.GrandChildren"]?.kind.isStruct).to(equal(true))
      }
      
      it("should recognize a nested type when it's in an extension") {
        expect(metaData["Parent.Children.Other"]).toNot(beNil())
        expect(metaData["Parent.Children.Other"]?.kind.isStruct).to(equal(true))
      }
      
    }


    describe("when extracting an enum with only one case") {
      
      let file = Path( self.testBundle.pathForResource("OneCaseEnum", ofType: "fixture")!)
      let metaData = SourceKittenExtractor().extractTypes([file]).groupBy { $0.name }
      
      it("should recognize its name & type") {
        expect(metaData["OnlyOne"]).toNot(beNil())
        expect(metaData["OnlyOne"]?.kind.isEnum).to(equal(true))
      }
      
      it("should recognize its cases") {
        let enumCases = [
          EnumCase(name: "One", associatedValues: [EnumAssociatedValue(name: "", type: "Int")]),
        ]
        expect(metaData["OnlyOne"]?.kind).to(equal(Kind.Enum(enumCases)))
      }
    }
    
    describe("when extracting a string backed enum") {
      
      let file = Path( self.testBundle.pathForResource("StringBackedEnum", ofType: "fixture")!)
      let metaData = SourceKittenExtractor().extractTypes([file]).groupBy { $0.name }
      
      it("should recognize its name & type") {
        expect(metaData["StringBacked"]).toNot(beNil())
        expect(metaData["StringBacked"]?.kind.isEnum).to(equal(true))
      }
      
      it("should recognize its cases") {
        let enumCases = [
          EnumCase(name: "One", associatedValues: []),
          EnumCase(name: "Two", associatedValues: []),
          ]
        expect(metaData["StringBacked"]?.kind).to(equal(Kind.Enum(enumCases)))
      }
    }
    
    describe("when extracting a hinted enum") {
      
      let file = Path( self.testBundle.pathForResource("HintEnum", ofType: "fixture")!)
      let metaData = SourceKittenExtractor().extractTypes([file]).groupBy { $0.name }
      
      it("should recognize its name & type") {
        expect(metaData["AHintedEnum"]).toNot(beNil())
        expect(metaData["AHintedEnum"]?.kind.isEnum).to(equal(true))
      }
      
      it("should recognize its hinted, overriden cases") {
        let enumCases = [
          EnumCase(name: "One", associatedValues: [EnumAssociatedValue(name: "", type: "Int")]),
          EnumCase(name: "Two", associatedValues: [EnumAssociatedValue(name: "", type: "Int")]),
          EnumCase(name: "Three", associatedValues: [EnumAssociatedValue(name: "", type: "Int")]),
          EnumCase(name: "Four", associatedValues: [EnumAssociatedValue(name: "", type: "Int")]),
          EnumCase(name: "Five", associatedValues: [
            EnumAssociatedValue(name: "", type: "Dictionary<String,Int>"),
            EnumAssociatedValue(name: "", type: "Array<String>"),
            EnumAssociatedValue(name: "", type: "Double")
            ]),
          ]
        expect(metaData["AHintedEnum"]?.kind).to(equal(Kind.Enum(enumCases)))
      }
    }

  
  }
  
}
