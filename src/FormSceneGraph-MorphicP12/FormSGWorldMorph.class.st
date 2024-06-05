"
I am OSWindowMorph that uses the form scene graph for all of its rendering tasks.
"
Class {
	#name : 'FormSGWorldMorph',
	#superclass : 'OSWindowWorldMorph',
	#category : 'FormSceneGraph-MorphicP12-WorldRenderer',
	#package : 'FormSceneGraph-MorphicP12',
	#tag : 'WorldRenderer'
}

{ #category : 'instance creation' }
FormSGWorldMorph >> open [
	self worldState worldRenderer: ((self worldRendererClass forWorld: self)
		windowCloseAction: [self osWindowCloseButtonPressed]).
	self changed.
	self class addExtraWorld: self.
]

{ #category : 'accessing' }
FormSGWorldMorph >> scaleFactor: value [
	^ self setProperty: #scaleFactor toValue: value

]

{ #category : 'hooks' }
FormSGWorldMorph >> worldRendererClass [
	^ self subclassResponsibility
]
