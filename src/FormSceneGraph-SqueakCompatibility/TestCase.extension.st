Extension { #name : #TestCase }

{ #category : #'*FormSceneGraph-SqueakCompatibility' }
TestCase >> assert: actualNumber closeTo: expectedNumber [
	^ self
		assert: (actualNumber closeTo: expectedNumber)
		description: [self comparingStringBetween: actualNumber and: expectedNumber]
]

{ #category : #'*FormSceneGraph-SqueakCompatibility' }
TestCase >> skip [
	"Stub for skipping the test."
]
