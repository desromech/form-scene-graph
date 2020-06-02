"
A FormSGBuilderTest is a test class for testing the behavior of FormSGBuilder
"
Class {
	#name : #FormSGBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'FormSceneGraph-Core-Tests'
}

{ #category : #running }
FormSGBuilderTest >> setUp [
	builder := FormSGBuilder new.
]

{ #category : #tests }
FormSGBuilderTest >> testBorderRectangle [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder borderRectangle: rectangle color: Color blue width: 2.
	self assert: node rectangle equals: rectangle.
	self assert: node color equals: Color blue.
	self assert: node width equals: 2.
]

{ #category : #tests }
FormSGBuilderTest >> testBoundingBox [
	self assert: builder null boundingBox isEmpty.
	self assert: (builder solidRectangle: (-1 @ -2 extent: 32 @ 64) color: Color red) boundingBox equals: (-1 @ -2 extent: 32 @ 64).
	self assert: (builder containerWith: {
		builder solidRectangle: (-1 @ -2 extent: 32 @ 64) color: Color red.
		builder null
	}) boundingBox equals: (-1 @ -2 extent: 32 @ 64).
	self assert: (builder containerWith: {
		builder solidRectangle: (-1 @ -2 extent: 32 @ 64) color: Color red.
		builder solidRectangle: (-5 @ -2 extent: 64 @ 32) color: Color red.
	}) boundingBox equals: (-5 @ -2 extent: 64 @ 64).
]

{ #category : #tests }
FormSGBuilderTest >> testContainer [
	| node children |
	children := {
		builder solidRectangle: (0@0 extent: 32@32) color: Color blue.
		builder solidRectangle: (10@10 extent: 20@20) color: Color red.
	}.
	node := builder containerWith: children.
	self assert: node children equals: children.
]

{ #category : #tests }
FormSGBuilderTest >> testIdentityTransform [
	self assert: builder identityTransform isIdentity.
	self assert: builder identityTransform isTranslationOnly.
]

{ #category : #tests }
FormSGBuilderTest >> testNullNode [
	| node |
	node := builder null.
	self assert: node isNullNode.
]

{ #category : #tests }
FormSGBuilderTest >> testSolidRectangle [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder solidRectangle: rectangle color: Color blue.
	self assert: node rectangle equals: rectangle.
	self assert: node color equals: Color blue.
]

{ #category : #tests }
FormSGBuilderTest >> testTransformNode [
	| node child |
	child := builder solidRectangle: (5@5 extent: 32@32) color: Color red.
	node := builder transform: child with: builder identityTransform.
	self assert: node transform equals: builder identityTransform.
	self assert: node child equals: child.

]

{ #category : #tests }
FormSGBuilderTest >> testTranslationNode [
	| node child |
	child := builder solidRectangle: (5@5 extent: 32@32) color: Color red.
	node := builder translate: child with: 4@5.
	self assert: node translation equals: 4@5.
	self assert: node child equals: child.

]

{ #category : #tests }
FormSGBuilderTest >> testTranslationTransform [
	| transform |
	transform := builder transformWithTranslation: 4@5.
	self deny: transform isIdentity.
	self assert: transform isTranslationOnly.

]
