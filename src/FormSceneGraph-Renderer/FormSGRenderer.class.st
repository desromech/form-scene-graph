"
I am an abstract renderer for a scene graph.
"
Class {
	#name : #FormSGRenderer,
	#superclass : #FormSGVisitor,
	#category : #'FormSceneGraph-Renderer'
}

{ #category : #testing }
FormSGRenderer class >> isAbstract [
	^ self == FormSGRenderer
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
