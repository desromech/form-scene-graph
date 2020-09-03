Class {
	#name : #FormSGAthensWorldMorph,
	#superclass : #FormSGWorldMorph,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #'instance creation' }
FormSGAthensWorldMorph >> open [
	self worldState worldRenderer: ((FormAthensSGWorldRenderer forWorld: self)
		windowCloseAction: [self osWindowCloseButtonPressed]).
	self changed.
	self class addExtraWorld: self.
]
