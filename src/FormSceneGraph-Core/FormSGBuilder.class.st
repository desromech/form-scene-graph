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
FormSGBuilder >> string: string from: firstIndex to: lastIndex in: rectangle font: fontOrNil color: color underline: underline underlineColor: underlineColor strikethrough: strikethrough strikethroughColor: strikethroughColor [
	^ FormSGTextNode new
		rectangle: rectangle;
		string: string;
		firstIndex: firstIndex;
		lastIndex: lastIndex;
		font: fontOrNil;
		color: color;
		underline: underline;
		underlineColor: underlineColor;
		strikethrough: strikethrough;
		strikethroughColor: strikethroughColor;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> string: string in: boundsRect font: fontOrNil color: c underline: underline underlineColor: underlineColor strikethrough: strikethrough strikethroughColor: strikethroughColor [
	^ self string: string from: 1 to: string size in: boundsRect font: fontOrNil color: c underline: underline underlineColor: underlineColor strikethrough: strikethrough strikethroughColor: strikethroughColor
]

{ #category : #'node building' }
FormSGBuilder >> texturedRectangle: rectangle form: form [
	^ self texturedRectangle: rectangle form: form opaque: false
]

{ #category : #'node building' }
FormSGBuilder >> texturedRectangle: rectangle form: form opaque: fullyOpaque [
	^ FormSGTextureNode new
		rectangle: rectangle;
		form: form;
		isFullyOpaque: fullyOpaque;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> transform: child with: transform [
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
FormSGBuilder >> translate: child with: translation [
	^ FormSGTranslationNode new
		translation: translation;
		child: child;
		yourself
]
