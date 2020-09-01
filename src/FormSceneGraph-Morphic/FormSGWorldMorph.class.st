Class {
	#name : #FormSGWorldMorph,
	#superclass : #OSWindowWorldMorph,
	#instVars : [
		'sceneScaleFactor'
	],
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #'instance creation' }
FormSGWorldMorph >> open [
	self worldState worldRenderer: ((FormSGWorldRenderer forWorld: self)
		windowCloseAction: [self osWindowCloseButtonPressed]).
	self changed.
	self class addExtraWorld: self.
]

{ #category : #accessing }
FormSGWorldMorph >> sceneScaleFactor [
	^ sceneScaleFactor ifNil: [ sceneScaleFactor := 1.0 ]
]

{ #category : #accessing }
FormSGWorldMorph >> sceneScaleFactor: anObject [
	sceneScaleFactor := anObject
]
