Class {
	#name : #FormSGWorldMorph,
	#superclass : #OSWindowWorldMorph,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #'instance creation' }
FormSGWorldMorph >> open [
	self worldState worldRenderer: ((FormSGWorldRenderer forWorld: self)
		windowCloseAction: [self osWindowCloseButtonPressed]).
	self changed.
	self class addExtraWorld: self.
]
