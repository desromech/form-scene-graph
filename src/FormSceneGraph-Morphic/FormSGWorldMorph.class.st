"
I am OSWindowMorph that uses the form scene graph for all of its rendering tasks.
"
Class {
	#name : #FormSGWorldMorph,
	#superclass : #OSWindowWorldMorph,
	#instVars : [
		'sceneScaleFactor',
		'userScaleFactor'
	],
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #'instance creation' }
FormSGWorldMorph >> open [
	self worldState worldRenderer: ((FormSGAbstractWorldRenderer forWorld: self)
		windowCloseAction: [self osWindowCloseButtonPressed]).
	self changed.
	self class addExtraWorld: self.
]

{ #category : #accessing }
FormSGWorldMorph >> scaleFactor [
	^ self userScaleFactor
]

{ #category : #accessing }
FormSGWorldMorph >> userScaleFactor [
	^ userScaleFactor ifNil: [ userScaleFactor := 1.0 ]
]

{ #category : #accessing }
FormSGWorldMorph >> userScaleFactor: anObject [
	userScaleFactor := anObject
]
