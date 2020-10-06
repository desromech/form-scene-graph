Extension { #name : #FormSGAffineTransform }

{ #category : #'*FormSceneGraph-Renderer' }
FormSGAffineTransform >> asAthensTransform [
	^ AthensAffineTransform new
		sx: m11; shx: m12; x: m13;
		shy: m21; sy: m22; y: m23;
		yourself
]

{ #category : #'*FormSceneGraph-Renderer' }
FormSGAffineTransform >> asDisplayTransform [
	^ MatrixTransform2x3 new
		a11: m11; a12: m12; a13: m13;
		a21: m21; a22: m22; a23: m23;
		yourself
]

{ #category : #'*FormSceneGraph-Renderer' }
FormSGAffineTransform >> asFormSGTransform [
	^ self
]
