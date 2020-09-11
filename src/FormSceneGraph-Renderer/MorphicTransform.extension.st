Extension { #name : #MorphicTransform }

{ #category : #'*FormSceneGraph-Renderer' }
MorphicTransform >> asFormSGTransform [
	self isPureTranslation ifTrue: [ ^ FormSGAffineTransform translation: offset negated ].
	^ self asMatrixTransform2x3 asFormSGTransform
]
