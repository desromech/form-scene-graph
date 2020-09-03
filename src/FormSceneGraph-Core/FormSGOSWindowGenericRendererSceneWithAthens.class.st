Class {
	#name : #FormSGOSWindowGenericRendererSceneWithAthens,
	#superclass : #OSWindowGenericRendererScene,
	#instVars : [
		'rootNode'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #rendering }
FormSGOSWindowGenericRendererSceneWithAthens >> renderAllWith: renderer [
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
FormSGOSWindowGenericRendererSceneWithAthens >> rootNode [
	^ rootNode
]

{ #category : #accessing }
FormSGOSWindowGenericRendererSceneWithAthens >> rootNode: anObject [
	rootNode := anObject
]
