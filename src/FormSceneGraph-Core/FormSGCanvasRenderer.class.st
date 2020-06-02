Class {
	#name : #FormSGCanvasRenderer,
	#superclass : #FormSGVisitor,
	#instVars : [
		'canvas',
		'currentTransform'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #rendering }
FormSGCanvasRenderer class >> render: node on: canvas [
	^ self new render: node on: canvas
]

{ #category : #rendering }
FormSGCanvasRenderer >> render: node on: aCanvas [
	canvas := aCanvas.
	currentTransform := FormSGAffineTransform identity.
	self visitNode: node.
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitBorderNode: node [
	canvas frameRectangle: node rectangle width: node width color: node color
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitColorNode: node [
	canvas fillRectangle: node rectangle color: node color
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitContainerNode: node [
	self visitNodes: node children
]

{ #category : #visiting }
FormSGCanvasRenderer >> visitNullNode: node [
	"Nothing required"
]
