"
I am scene graph visitor whose task is to insert the text glyphs into a font texture atlas cache.
"
Class {
	#name : #FormSGTextPreparationVisitor,
	#superclass : #FormSGVisitor,
	#instVars : [
		'surfaceScaleFactor',
		'fontTextureAtlasCache'
	],
	#category : #'FormSceneGraph-Renderer-Basic'
}

{ #category : #accessing }
FormSGTextPreparationVisitor >> fontTextureAtlasCache [
	^ fontTextureAtlasCache
]

{ #category : #accessing }
FormSGTextPreparationVisitor >> fontTextureAtlasCache: anObject [
	fontTextureAtlasCache := anObject
]

{ #category : #initialization }
FormSGTextPreparationVisitor >> initialize [
	super initialize.
	surfaceScaleFactor := 1.0.
]

{ #category : #accessing }
FormSGTextPreparationVisitor >> surfaceScaleFactor [
	^ surfaceScaleFactor
]

{ #category : #accessing }
FormSGTextPreparationVisitor >> surfaceScaleFactor: anObject [
	surfaceScaleFactor := anObject
]

{ #category : #visiting }
FormSGTextPreparationVisitor >> visitCachedSubScene: node [
	^ self visitNode: node child
]

{ #category : #visiting }
FormSGTextPreparationVisitor >> visitChildAttributeNode: node [
	^ self visitNode: node child
]

{ #category : #visiting }
FormSGTextPreparationVisitor >> visitClipNode: node [
	self visitNode: node child
]

{ #category : #visiting }
FormSGTextPreparationVisitor >> visitContainerNode: node [
	self visitNodes: node children
]

{ #category : #visiting }
FormSGTextPreparationVisitor >> visitNullNode: node [
	"Nop"
]

{ #category : #visiting }
FormSGTextPreparationVisitor >> visitRectangleNode: node [
	"We do not care about this node."
]

{ #category : #visiting }
FormSGTextPreparationVisitor >> visitTextNode: node [
	| font scaledFont |
	fontTextureAtlasCache ifNil: [ ^ self ].
	
	font := node font.
	font ifNil: [ ^ self ].
	
	scaledFont := font.
	(surfaceScaleFactor closeTo: 1.0) ifFalse: [
		scaledFont := scaledFont withSizeIncrementedBy: (scaledFont pointSize*surfaceScaleFactor) - scaledFont pointSize
	].

	fontTextureAtlasCache prepareString: node string from: node firstIndex to: node lastIndex font: font scaledFont: scaledFont subpixelAllowed: true
]
