Extension { #name : #Rectangle }

{ #category : #'*FormSceneGraph-Core' }
Rectangle class >> empty [
	^ self basicNew setEmpty
]

{ #category : #'*FormSceneGraph-Core' }
Rectangle >> isEmpty [
	^ origin x > corner x or: [ origin y > corner y ]
]

{ #category : #'*FormSceneGraph-Core' }
Rectangle >> setEmpty [
	origin := Float infinity @ Float infinity.
	corner := Float negativeInfinity @ Float negativeInfinity.
]
