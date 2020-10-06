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
FormSGAffineTransformTest >> testRows [
	| transform |
	transform := FormSGAffineTransform rows: #(1 2 3 4 5 6).
	self assert: transform asRowMajorArray equals: #(1 2 3 4 5 6).
]

{ #category : #tests }
FormSGAffineTransformTest >> testTranslation [
	| transform |
	transform := FormSGAffineTransform translation: 4@3.
	self deny: transform isIdentity.
	self assert: transform isTranslationOnly.
	self assert: transform translation equals: 4@3.
	self assert: transform asRowMajorArray equals: #(
		1 0 4
		0 1 3
	).
	
	self assert: (transform transformPoint: 0@0) equals: 4@3.
	self assert: (transform transformPoint: 0@1) equals: 4@4.
	self assert: (transform transformPoint: 1@0) equals: 5@3.
	self assert: (transform transformPoint: 1@1) equals: 5@4.

	self assert: (transform inverseTransformPoint: 0@0) equals: -4 @ -3.
	self assert: (transform inverseTransformPoint: 0@1) equals: -4 @ -2.
	self assert: (transform inverseTransformPoint: 1@0) equals: -3 @ -3.
	self assert: (transform inverseTransformPoint: 1@1) equals: -3 @ -2.
]
