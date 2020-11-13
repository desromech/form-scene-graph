Extension { #name : #Cursor }

{ #category : #'*FormSceneGraph-Renderer' }
Cursor >> isValidHardwareCompatibleCursor [
	^ self depth = 1
]
