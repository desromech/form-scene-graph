"
I am a wrapper on top of an scene graph node that connects with the OSWindowGenericRenderer interface.
"
Class {
	#name : #FormSGOSWindowGenericRendererScene,
	#superclass : #OSWindowGenericRendererScene,
	#instVars : [
		'rootNode'
	],
	#category : #'FormSceneGraph-Renderer'
}

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> renderAllWith: renderer [
	self flag: 'TODO: Select a more appropiate clear color'.
	renderer
		color: Color transparent;
		clear.
		
	rootNode ifNotNil: [ 
		FormSGOSWindowGenericRenderer render: rootNode with: renderer.
	].
	renderer present.
]

{ #category : #accessing }
FormSGOSWindowGenericRendererScene >> rootNode [
	^ rootNode
]

{ #category : #accessing }
FormSGOSWindowGenericRendererScene >> rootNode: anObject [
	rootNode := anObject
]
