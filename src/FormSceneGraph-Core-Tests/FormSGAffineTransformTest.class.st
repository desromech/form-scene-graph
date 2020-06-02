"
A FormSGAffineTransformTest is a test class for testing the behavior of FormSGAffineTransform
"
Class {
	#name : #FormSGAffineTransformTest,
	#superclass : #TestCase,
	#category : #'FormSceneGraph-Core-Tests'
}

{ #category : #tests }
FormSGAffineTransformTest >> testIdentity [
	| transform |
	transform := FormSGAffineTransform identity.
	self assert: transform isIdentity.
	self assert: transform asRowMajorArray equals: #(
		1 0 0
		0 1 0
	).
	
	self assert: (transform transformPoint: 0@0) equals: 0@0.
	self assert: (transform transformPoint: 0@1) equals: 0@1.
	self assert: (transform transformPoint: 1@0) equals: 1@0.
	self assert: (transform transformPoint: 1@1) equals: 1@1.
]

{ #category : #tests }
FormSGAffineTransformTest >> testTranslation [
	| transform |
	transform := FormSGAffineTransform translation: 4@3.
	self deny: transform isIdentity.
	self assert: transform isTranslationOnly.
	self assert: transform asRowMajorArray equals: #(
		1 0 4
		0 1 3
	).
	
	self assert: (transform transformPoint: 0@0) equals: 4@3.
	self assert: (transform transformPoint: 0@1) equals: 4@4.
	self assert: (transform transformPoint: 1@0) equals: 5@3.
	self assert: (transform transformPoint: 1@1) equals: 5@4.
]
