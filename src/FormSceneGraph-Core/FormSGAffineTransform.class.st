"
I am a 2x3 affine matrix based transform.
[ 
	m11 m12 m13
	m21 m22 m23
]
"
Class {
	#name : #FormSGAffineTransform,
	#superclass : #Object,
	#instVars : [
		'm11',
		'm12',
		'm13',
		'm21',
		'm22',
		'm23'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #'instance creation' }
FormSGAffineTransform class >> identity [
	^ self new setIdentity; yourself
]

{ #category : #'instance creation' }
FormSGAffineTransform class >> translation: translation [
	^ self new setTranslation: translation; yourself
]

{ #category : #initialization }
FormSGAffineTransform >> = other [
	^ self class = other class and: [
		m11 = other m11 and: [
		m12 = other m12 and: [
		m13 = other m13 and: [
			
		m21 = other m21 and: [
		m22 = other m22 and: [
		m23 = other m23 ]]]]]]
]

{ #category : #converting }
FormSGAffineTransform >> asDisplayTransform [
	^ MatrixTransform2x3 new
		a11: m11; a12: m12; a13: m13;
		a21: m21; a22: m22; a23: m23;
		yourself
]

{ #category : #converting }
FormSGAffineTransform >> asFormSGTransform [
	^ self
]

{ #category : #converting }
FormSGAffineTransform >> asRowMajorArray [
	^ {
		m11 . m12 . m13 .
		m21 . m22 . m23 .
	}
]

{ #category : #initialization }
FormSGAffineTransform >> closeTo: other [
	^ self class = other class and: [
		(m11 closeTo: other m11) and: [
		(m12 closeTo: other m12) and: [
		(m13 closeTo: other m13) and: [
			
		(m21 closeTo: other m21) and: [
		(m22 closeTo: other m22) and: [
		(m23 closeTo: other m23) ]]]]]]
]

{ #category : #initialization }
FormSGAffineTransform >> hash [
	^ self class identityHash bitXor: (
		m11 hash bitXor: (
		m12 hash bitXor: (
		m13 hash bitXor: (
			
		m21 hash bitXor: (
		m22 hash bitXor: (
		m23 hash))))))
]

{ #category : #initialization }
FormSGAffineTransform >> initialize [ 
	self setIdentity
]

{ #category : #transformation }
FormSGAffineTransform >> inverseTransformPoint: aPoint [
	^ self inverted transformPoint: aPoint
]

{ #category : #transformation }
FormSGAffineTransform >> inverseTransformRectangle: aRectangle [
	^ self inverted transformRectangle: aRectangle
]

{ #category : #converting }
FormSGAffineTransform >> inverted [
	| det |
	det := (m11*m22) - (m21*m21).
	(det closeTo: 0.0) ifTrue: [ self error: 'Affine transform does not have an inverse.' ].
	^ self class new
		m11: m22 / det; m12: m12 negated / det ; m13: m13 negated;
		m21: m21 negated / det; m22: m11 / det; m23: m23 negated;
		yourself
]

{ #category : #testing }
FormSGAffineTransform >> isIdentity [
	^ self = self class identity
]

{ #category : #testing }
FormSGAffineTransform >> isTranslationOnly [
	^ (m11 closeTo: 1.0) and: [
		(m12 closeTo: 0.0) and: [
		(m21 closeTo: 0.0) and: [
		(m22 closeTo: 1.0) ]]]
]

{ #category : #accessing }
FormSGAffineTransform >> m11 [
	^ m11
]

{ #category : #accessing }
FormSGAffineTransform >> m11: anObject [
	m11 := anObject
]

{ #category : #accessing }
FormSGAffineTransform >> m12 [
	^ m12
]

{ #category : #accessing }
FormSGAffineTransform >> m12: anObject [
	m12 := anObject
]

{ #category : #accessing }
FormSGAffineTransform >> m13 [
	^ m13
]

{ #category : #accessing }
FormSGAffineTransform >> m13: anObject [
	m13 := anObject
]

{ #category : #accessing }
FormSGAffineTransform >> m21 [
	^ m21
]

{ #category : #accessing }
FormSGAffineTransform >> m21: anObject [
	m21 := anObject
]

{ #category : #accessing }
FormSGAffineTransform >> m22 [
	^ m22
]

{ #category : #accessing }
FormSGAffineTransform >> m22: anObject [
	m22 := anObject
]

{ #category : #accessing }
FormSGAffineTransform >> m23 [
	^ m23
]

{ #category : #accessing }
FormSGAffineTransform >> m23: anObject [
	m23 := anObject
]

{ #category : #initialization }
FormSGAffineTransform >> setIdentity [
	m11 := 1.0. m12 := 0.0. m13 := 0.0.
	m21 := 0.0. m22 := 1.0. m23 := 0.0.
]

{ #category : #initialization }
FormSGAffineTransform >> setRotationInDegrees: rotation [
	self setRotationInRadians: rotation degreesToRadians
]

{ #category : #initialization }
FormSGAffineTransform >> setRotationInDegrees: rotation translation: translation [
	self setRotationInRadians: rotation degreesToRadians translation: translation
]

{ #category : #initialization }
FormSGAffineTransform >> setRotationInRadians: rotation [
	| c s |
	c := rotation cos.
	s := rotation sin.
	m11 := c. m12 := s negated. m13 := 0.0.
	m21 := s. m22 := c. m23 := 0.0.
]

{ #category : #initialization }
FormSGAffineTransform >> setRotationInRadians: rotation translation: translation [
	| c s |
	c := rotation cos.
	s := rotation sin.
	m11 := c. m12 := s negated. m13 := translation x.
	m21 := s. m22 := c. m23 := translation y.
]

{ #category : #initialization }
FormSGAffineTransform >> setTranslation: translation [
	m11 := 1.0. m12 := 0.0. m13 := translation x asFloat.
	m21 := 0.0. m22 := 1.0. m23 := translation y asFloat.
]

{ #category : #transformation }
FormSGAffineTransform >> transformPoint: point [
	| x y |
	x := point x.
	y := point y.
	^ ((m11 * x) + (m12 * y) + m13) @ ((m21 * x) + (m22 * y) + m23)
]

{ #category : #transformation }
FormSGAffineTransform >> transformRectangle: rectangle [
	rectangle isEmpty ifTrue: [ ^ rectangle ].
	^ Rectangle encompassing: {
		self transformPoint: rectangle bottomLeft.
		self transformPoint: rectangle bottomRight.
		self transformPoint: rectangle topLeft.
		self transformPoint: rectangle topRight.
	}
]

{ #category : #accessing }
FormSGAffineTransform >> translation [
	^ m13 @ m23
]
