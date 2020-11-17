"
A FormSGAthensRendererTest is a test class for testing the behavior of FormSGAthensRenderer
"
Class {
	#name : #FormSGAthensRendererTest,
	#superclass : #TestCase,
	#category : #'FormSceneGraph-Renderer-Basic'
}

{ #category : #tests }
FormSGAthensRendererTest >> testConvertAffineTransform [
	| transform athensTransform |
	transform := FormSGAffineTransform rows: #(
		1 2 3
		4 5 6
	).
	athensTransform := transform asAthensTransform.
	self assert: athensTransform sx equals: 1.
	self assert: athensTransform shx equals: 2.
	self assert: athensTransform x equals: 3.
	self assert: athensTransform shy equals: 4.
	self assert: athensTransform sy equals: 5.
	self assert: athensTransform y equals: 6.
]
