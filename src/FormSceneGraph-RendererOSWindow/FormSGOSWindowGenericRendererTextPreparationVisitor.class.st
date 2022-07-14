"
I am scene graph visitor whose task is to insert the text glyphs into a font texture atlas cache. I also ommit vising the cached sub scene nodes which are already validated.
"
Class {
	#name : #FormSGOSWindowGenericRendererTextPreparationVisitor,
	#superclass : #FormSGTextPreparationVisitor,
	#instVars : [
		'renderer'
	],
	#category : #'FormSceneGraph-RendererOSWindow'
}

{ #category : #accessing }
FormSGOSWindowGenericRendererTextPreparationVisitor >> renderer [
	^ renderer
]

{ #category : #accessing }
FormSGOSWindowGenericRendererTextPreparationVisitor >> renderer: anObject [
	renderer := anObject
]

{ #category : #visiting }
FormSGOSWindowGenericRendererTextPreparationVisitor >> visitCachedSubScene: node [
	| renderTarget requiredExtent |
	renderTarget := renderer getRenderTargetTextureForObjectOrNil: node.
	requiredExtent := (node rectangle extent * surfaceScaleFactor) ceiling.
	(renderTarget isNotNil and: [
	requiredExtent = renderTarget extent and: [
	renderTarget modificationCount isNotNil and: [
	renderTarget modificationCount >= node modificationCount ]]]) ifTrue: [ ^ self ].

	^ super visitCachedSubScene: node
]
