Class {
	#name : #FormSGATestCase,
	#superclass : #TestCase,
	#category : #'FormSceneGraph-Core-Tests'
}

{ #category : #testing }
FormSGATestCase class >> isAbstract [
	^ self == FormSGATestCase
]

{ #category : #asserting }
FormSGATestCase >> assert: actualNumber closeTo: expectedNumber [
	"Method copied for Squeak compatiblity."
	^ self
		assert: (actualNumber closeTo: expectedNumber)
		description: [self comparingStringBetween: actualNumber and: expectedNumber]
]
