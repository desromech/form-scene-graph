"
I am an abstract renderer for a scene graph.
"
Class {
	#name : #FormSGRenderer,
	#superclass : #FormSGVisitor,
	#instVars : [
		'surfaceScaleFactor'
	],
	#category : #'FormSceneGraph-Renderer-Basic'
}

{ #category : #testing }
FormSGRenderer class >> isAbstract [
	^ self == FormSGRenderer
]

{ #category : #accessing }
FormSGRenderer >> initialize [
	super initialize.
	surfaceScaleFactor := 1.0.
]

{ #category : #accessing }
FormSGRenderer >> surfaceScaleFactor [
	^ surfaceScaleFactor
]

{ #category : #accessing }
FormSGRenderer >> surfaceScaleFactor: anObject [
	surfaceScaleFactor := anObject
]

{ #category : #visiting }
FormSGRenderer >> visitChildAttributeNode: node [
	"By default ignore the modified attribute and visit its child."
	^ self visitNode: node child
]

{ #category : #visiting }
FormSGRenderer >> visitRectangleNode: node [
	"By default do nothing"
]
