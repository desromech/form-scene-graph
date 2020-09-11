Extension { #name : #CompositeTransform }

{ #category : #'*FormSceneGraph-Renderer' }
CompositeTransform >> asFormSGTransform [
	^ self asMatrixTransform2x3 asFormSGTransform
]
