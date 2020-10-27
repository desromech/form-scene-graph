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
	#category : #'FormSceneGraph-Core-Transform'
}

{ #category : #'instance creation' }
FormSGAffineTransform class >> identity [
	^ self new setIdentity; yourself
]

{ #category : #'instance creation' }
FormSGAffineTransform class >> rotationInDegrees: angle [
	^ self new setRotationInDegrees: angle; yourself
]

{ #category : #'instance creation' }
FormSGAffineTransform class >> rotationInDegrees: angle translation: translation [
	^ self new setRotationInDegrees: angle translation: translation; yourself
]

{ #category : #'instance creation' }
FormSGAffineTransform class >> rotationInRadians: angle [
	^ self new setRotationInRadians: angle; yourself
]

{ #category : #'instance creation' }
FormSGAffineTransform class >> rotationInRadians: angle translation: translation [
	^ self new setRotationInRadians: angle translation: translation; yourself
]

{ #category : #'instance creation' }
FormSGAffineTransform class >> rows: elements [
	self assert: elements size = 6.
	^ self new
		m11: (elements at: 1); m12: (elements at: 2); m13: (elements at: 3);
		m21: (elements at: 4); m22: (elements at: 5); m23: (elements at: 6);
		yourself
]

{ #category : #'instance creation' }
FormSGAffineTransform class >> scale: scaleFactor [
	^ self new setScale: scaleFactor; yourself
]

{ #category : #'instance creation' }
FormSGAffineTransform class >> scale: scale translation: translation [
	^ (self translation: translation) * (self scale: scale)
]

{ #category : #'instance creation' }
FormSGAffineTransform class >> scaleX: scaleFactorX Y: scaleFactorY [
	^ self new setScaleX: scaleFactorX Y: scaleFactorY; yourself
]

{ #category : #'instance creation' }
FormSGAffineTransform class >> scaleX: scaleX Y: scaleY translation: translation [
	^ (self translation: translation) * (self scaleX: scaleX Y: scaleY)
]

{ #category : #'instance creation' }
FormSGAffineTransform class >> translation: translation [
	^ self new setTranslation: translation; yourself
]

{ #category : #arithmetic }
FormSGAffineTransform >> * anAffineTransform [
	^ self transformTransform: anAffineTransform
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
FormSGAffineTransform >> closeTo: other precision: precision [
	^ self class = other class and: [
		(m11 closeTo: other m11 precision: precision) and: [
		(m12 closeTo: other m12 precision: precision) and: [
		(m13 closeTo: other m13 precision: precision) and: [
			
		(m21 closeTo: other m21 precision: precision) and: [
		(m22 closeTo: other m22 precision: precision) and: [
		(m23 closeTo: other m23 precision: precision) ]]]]]]
]

{ #category : #testing }
FormSGAffineTransform >> determinant [
	^ (m11 * m22) - (m21*m12)
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
FormSGAffineTransform >> isTranslationAndPositiveScaleOnly [
	^ (m11 closeTo: m22) and: [
		m11 > 0.0 and: [
		(m12 closeTo: 0.0) and: [
		(m21 closeTo: 0.0)]]]
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

{ #category : #accessing }
FormSGAffineTransform >> positiveScale [
	self assert: ((m11 closeTo: m22) and: [m11 > 0]).
	^ m11
]

{ #category : #printing }
FormSGAffineTransform >> printOn: aStream [
	aStream
		nextPut: $(; nextPutAll: self class name; nextPutAll: ' rows: #('; cr;
		tab; print: m11; space; print: m12; space; print: m13; cr;
		tab; print: m21; space; print: m22; space; print: m23; cr;
	nextPut: $)
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
FormSGAffineTransform >> setScale: scaleFactor [.
	self setScaleX: scaleFactor Y: scaleFactor
]

{ #category : #initialization }
FormSGAffineTransform >> setScaleX: scaleFactorX Y: scaleFactorY [.
	m11 := scaleFactorX asFloat. m12 := 0.0. m13 := 0.0.
	m21 := 0.0. m22 := scaleFactorY asFloat. m23 := 0.0.
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

{ #category : #arithmetic }
FormSGAffineTransform >> transformTransform: other [
	^ self class basicNew
		m11: (m11 * other m11) + (m12 * other m21);
		m12: (m11 * other m12) + (m12 * other m22);
		m13: (m11 * other m13) + (m12 * other m23) + m13;

		m21: (m21 * other m11) + (m22 * other m21);
		m22: (m21 * other m12) + (m22 * other m22);
		m23: (m21 * other m13) + (m22 * other m23) + m23;
		yourself
]

{ #category : #accessing }
FormSGAffineTransform >> translation [
	^ m13 @ m23
]
