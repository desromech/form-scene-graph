Class {
	#name : #FormSGBuilder,
	#superclass : #Object,
	#category : #'FormSceneGraph-Core'
}

{ #category : #'node building' }
FormSGBuilder >> borderRectangle: rectangle color: color width: width [
	^ FormSGBorderNode new
		rectangle: rectangle;
		color: color;
		width: width;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> clip: node withRectangle: rectangle [
	^ FormSGClipNode new
		child: node;
		rectangle: rectangle;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> containerWith: nodes [
	^ FormSGContainerNode new
		children: nodes;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> identityTransform [
	^ FormSGAffineTransform identity
]

{ #category : #'node building' }
FormSGBuilder >> null [
	^ FormSGNullNode new
]

{ #category : #'node building' }
FormSGBuilder >> solidRectangle: rectangle color: solidColor [
	^ FormSGColorNode new
		rectangle: rectangle;
		color: solidColor;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> transform: transform for: child [
	^ FormSGTransformNode new
		transform: transform;
		child: child;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> transformWithTranslation: translation [
	^ FormSGAffineTransform translation: translation
]

{ #category : #'node building' }
FormSGBuilder >> translation: translation for: child [
	^ FormSGTranslationNode new
		translation: translation;
		child: child;
		yourself
]
