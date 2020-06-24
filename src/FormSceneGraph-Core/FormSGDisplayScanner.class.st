Class {
	#name : #FormSGDisplayScanner,
	#superclass : #DisplayScanner,
	#instVars : [
		'builder',
		'textNodes'
	],
	#category : #'FormSceneGraph-Core'
}

{ #category : #'instance creation' }
FormSGDisplayScanner class >> for: paragraph with: builder [
	^ self new initWithParagraph: paragraph andBuilder: builder; yourself
]

{ #category : #displaying }
FormSGDisplayScanner >> displayString: string from: startIndex to: stopIndex at: aPoint [
	| rectangle |
	rectangle := aPoint extent: ((font widthOfString: string from: startIndex to: stopIndex) @ font height).
	
	textNodes add: (builder string: string from: startIndex to: stopIndex in: rectangle font: font color: foregroundColor kern: kern)
]

{ #category : #displaying }
FormSGDisplayScanner >> fillTextBackground [
	backgroundColor ifNotNil: [
		textNodes add: (builder solidRectangle: (line left @ lineY extent: line width @ line lineHeight) color: backgroundColor)
	]
]

{ #category : #initialization }
FormSGDisplayScanner >> initWithParagraph: paragraph andBuilder: theBuilder [
	self text: paragraph text textStyle: paragraph textStyle.
	builder := theBuilder.
	textNodes := OrderedCollection new.
]

{ #category : #accessing }
FormSGDisplayScanner >> sceneGraphNode [
	textNodes isEmpty ifTrue: [ ^ builder null ].
	textNodes size = 1 ifTrue: [ ^ textNodes first ].
	^ builder containerWith: textNodes
]

{ #category : #accessing }
FormSGDisplayScanner >> textNodes [
	^ textNodes
]
