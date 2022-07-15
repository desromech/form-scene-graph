"
A FormSGAffineTransformTest is a test class for testing the behavior of FormSGAffineTransform
"
Class {
	#name : #FormSGAffineTransformTest,
	#superclass : #FormSGATestCase,
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
FormSGAffineTransformTest >> testRotationInDegrees [
	| transform |
	transform := FormSGAffineTransform rotationInDegrees: 90.
	self deny: transform isIdentity.
	self deny: transform isTranslationOnly.
	self assert: transform translation equals: 0@0.
	self assert: transform m11 closeTo: 0.
	self assert: transform m12 closeTo: -1.
	self assert: transform m21 closeTo: 1.
	self assert: transform m22 closeTo: 0.
	self assert: (transform transformPoint: 3@1) closeTo: -1@3.

]

{ #category : #tests }
FormSGAffineTransformTest >> testRotationInDegreesThenTranslation [
	| transform |
	transform := FormSGAffineTransform rotationInDegrees: 90 translation: 5@7.
	self deny: transform isIdentity.
	self deny: transform isTranslationOnly.
	self assert: transform translation equals: 5@7.
	self assert: transform m11 closeTo: 0.
	self assert: transform m12 closeTo: -1.
	self assert: transform m21 closeTo: 1.
	self assert: transform m22 closeTo: 0.
	self assert: (transform transformPoint: 3@1) closeTo: 4@10.

]

{ #category : #tests }
FormSGAffineTransformTest >> testRotationInRadians [
	| transform |
	transform := FormSGAffineTransform rotationInRadians: Float halfPi.
	self deny: transform isIdentity.
	self deny: transform isTranslationOnly.
	self assert: transform translation equals: 0@0.
	self assert: transform m11 closeTo: 0.
	self assert: transform m12 closeTo: -1.
	self assert: transform m21 closeTo: 1.
	self assert: transform m22 closeTo: 0.
	self assert: (transform transformPoint: 3@1) closeTo: -1@3.

]

{ #category : #tests }
FormSGAffineTransformTest >> testRotationInRadiansThenTranslation [
	| transform |
	transform := FormSGAffineTransform rotationInRadians: Float halfPi translation: 5@7.
	self deny: transform isIdentity.
	self deny: transform isTranslationOnly.
	self assert: transform translation equals: 5@7.
	self assert: transform m11 closeTo: 0.
	self assert: transform m12 closeTo: -1.
	self assert: transform m21 closeTo: 1.
	self assert: transform m22 closeTo: 0.
	self assert: (transform transformPoint: 3@1) closeTo: 4@10.

]

{ #category : #tests }
FormSGAffineTransformTest >> testRows [
	| transform |
	transform := FormSGAffineTransform rows: #(1 2 3 4 5 6).
	self assert: transform asRowMajorArray equals: #(1 2 3 4 5 6).
]

{ #category : #tests }
FormSGAffineTransformTest >> testScale [
	| transform |
	transform := FormSGAffineTransform scale: 3.
	self deny: transform isIdentity.
	self deny: transform isTranslationOnly.
	self assert: transform translation equals: 0@0.
	self assert: transform asRowMajorArray equals: #(
		3 0 0
		0 3 0
	).
	self assert: (transform transformPoint: 2@3) closeTo: 6@9.

]

{ #category : #tests }
FormSGAffineTransformTest >> testScaleTranslation [
	| transform |
	transform := FormSGAffineTransform scale: 3 translation: 4@7.
	self deny: transform isIdentity.
	self deny: transform isTranslationOnly.
	self assert: transform translation equals: 4@7.
	self assert: transform asRowMajorArray equals: #(
		3 0 4
		0 3 7
	).
	self assert: (transform transformPoint: 2@3) closeTo: 10@16.

]

{ #category : #tests }
FormSGAffineTransformTest >> testScaleXY [
	| transform |
	transform := FormSGAffineTransform scaleX: 3 Y: 5.
	self deny: transform isIdentity.
	self deny: transform isTranslationOnly.
	self assert: transform translation equals: 0@0.
	self assert: transform asRowMajorArray equals: #(
		3 0 0
		0 5 0
	).
	self assert: (transform transformPoint: 2@3) closeTo: 6@15.

]

{ #category : #tests }
FormSGAffineTransformTest >> testScaleXYTranslation [
	| transform |
	transform := FormSGAffineTransform scaleX: 3 Y: 5 translation: 4@7.
	self deny: transform isIdentity.
	self deny: transform isTranslationOnly.
	self assert: transform translation equals: 4@7.
	self assert: transform asRowMajorArray equals: #(
		3 0 4
		0 5 7
	).
	self assert: (transform transformPoint: 2@3) closeTo: 10@22.

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
