Extension { #name : #TestCase }

{ #category : #'*FormSceneGraph-SqueakCompatibility' }
TestCase >> assert: actualNumber closeTo: expectedNumber [
	^ self
		assert: (actualNumber closeTo: expectedNumber)
		description: [self comparingStringBetween: actualNumber and: expectedNumber]
]
