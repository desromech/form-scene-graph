Extension { #name : #CompositeTransform }

{ #category : #'*FormSceneGraph-Core' }
CompositeTransform >> asFormSGTransform [
	^ self asMatrixTransform2x3 asFormSGTransform
]
